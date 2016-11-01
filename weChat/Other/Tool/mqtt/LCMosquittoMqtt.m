//
//  LCMosquittoMqtt.m
//  LCMosquittoMqtt
//
//  Created by Lc on 16/6/27.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LCMosquittoMqtt.h"

@interface LCMosquittoMqtt ()
@property (assign, nonatomic) struct mosquitto *mosq;
@end

@implementation LCMosquittoMqtt
#pragma mark - init
- (instancetype)initWithClientId:(NSString *)clientId
{
    if (self = [super init]) {
        /*
         * 头文件注释
         * Function: mosquitto_lib_init
         *
         * Must be called before any other mosquitto functions.
         *
         * Returns:
         * 	MOSQ_ERR_SUCCESS - always
         *
         * See Also:
         * 	<mosquitto_lib_cleanup>, <mosquitto_lib_version>
         */
        mosquitto_lib_init();
        
        // 必传. 客户端和服务端都必须使用ClientId识别两者之间的MQTT会话相关的状态
        
        const char *clientID = [clientId cStringUsingEncoding:NSUTF8StringEncoding];
        
        // new
        self.mosq = mosquitto_new(clientID, NO, (__bridge void *)(self));
        
        // 连接的回调函数
        mosquitto_connect_callback_set(self.mosq, on_connect);
        
        // 断开连接的回调函数
        mosquitto_disconnect_callback_set(self.mosq, on_disconnect);
        
        // 发布消息的回调函数
        mosquitto_publish_callback_set(self.mosq, on_publish);
        
        // 接受消息的回调函数
        mosquitto_message_callback_set(self.mosq, on_message);
        
        // 订阅消息的回调函数
        mosquitto_subscribe_callback_set(self.mosq, on_subscribe);
        
        // 取消订阅消息的回调函数
        mosquitto_unsubscribe_callback_set(self.mosq, on_unsubscribe);
        
#ifdef DEBUG
        mosquitto_log_callback_set(self.mosq, on_log);
#else
#endif
        
    }
    
    return self;
}

#pragma mark - connection
- (void)connectToHost:(NSString *)host port:(int)port userName:(NSString *)userName password:(NSString *)password keepAlive:(int)keepAlive reconnect_delay:(unsigned int)reconnect_delay reconnect_delay_max:(unsigned int)reconnect_delay_max reconnect_exponential_backoff:(BOOL)reconnect_exponential_backoff
{
    const char *cStrUserName = NULL;
    const char *cStrPassword = NULL;
    const char *cStrHost = [host cStringUsingEncoding:NSUTF8StringEncoding];

    int defaultPort = 1883;
    int defaultKeepAlive = 60;
    
    if (userName) {
        cStrUserName = [userName cStringUsingEncoding:NSUTF8StringEncoding];
    }
    if (password) {
        cStrPassword = [password cStringUsingEncoding:NSUTF8StringEncoding];
    }
    
    if (port != 0) {
        defaultPort = port;
    }
    
    if (keepAlive != 0) {
        defaultKeepAlive = keepAlive;
    }
    
    mosquitto_username_pw_set(self.mosq, cStrUserName, cStrPassword);

    mosquitto_reconnect_delay_set(self.mosq, reconnect_delay, reconnect_delay_max, reconnect_exponential_backoff);
    mosquitto_connect(self.mosq, cStrHost, defaultPort, defaultKeepAlive);
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        mosquitto_loop_forever(self.mosq, -1, 1);
    });
}

- (void)reconnect
{
    //    if (self.connected) { // 头文件说: It must not be called before <mosquitto_connect>. 测试后, 直接调用也没啥问题
    mosquitto_reconnect(self.mosq);
    //    }
}

- (void)disconnect
{
    mosquitto_disconnect(self.mosq);
}

#pragma mark - publish
- (void)publishData:(NSData *)data topic:(NSString *)topic qos:(MQTTQosLevel)qos retain:(BOOL)retain
{
    int mid;
    const char *cStrTopic = [topic cStringUsingEncoding:NSUTF8StringEncoding];
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wshorten-64-to-32"
     mosquitto_publish(self.mosq, &mid, cStrTopic, data.length, data.bytes, qos, retain);
#pragma clang diagnostic pop
    
}

#pragma mark - subscribe
- (void)subscribeWithTopic:(NSString *)topic qos:(MQTTQosLevel)qos
{
    int mid;
    const char *cStrTopic = [topic cStringUsingEncoding:NSUTF8StringEncoding];
    mosquitto_subscribe(self.mosq, &mid, cStrTopic, qos);
}

- (void)unSubscribeWithTopic:(NSString *)topic
{
    int mid;
    const char *cStrTopic = [topic cStringUsingEncoding:NSUTF8StringEncoding];
    
    mosquitto_unsubscribe(self.mosq, &mid, cStrTopic);
}

#pragma mark - will
- (void)setWillData:(NSData *)data toTopic:(NSString *)topic qos:(MQTTQosLevel)qos retain:(BOOL)retain
{
    const char* cstrTopic = [topic cStringUsingEncoding:NSUTF8StringEncoding];
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wshorten-64-to-32"
    mosquitto_will_set(self.mosq, cstrTopic, data.length, data.bytes, qos, retain);
#pragma clang diagnostic pop
}

- (void)clearWill
{
    mosquitto_will_clear(self.mosq);
}

#pragma mark - dealloc
- (void) dealloc
{
    if (self.mosq) {
        mosquitto_destroy(self.mosq);
        self.mosq = NULL;
    }
}

#pragma mark - mosquitto
static void on_log(struct mosquitto *mosq, void *obj, int level, const char *str)
{
    NSString *string = [NSString stringWithCString:str encoding:NSUTF8StringEncoding];
//    LCLog(@" on_log  level %d %@", level, string );
}

static void on_connect(struct mosquitto *mosq, void *obj, int rc)
{
    LCMosquittoMqtt *mqtt = (__bridge LCMosquittoMqtt *) obj;
    mqtt.connected = (rc == MQTTConnectAccepted);
    if (mqtt.delegate && [mqtt.delegate respondsToSelector:@selector(mosMqtt:didConnectedWithReturnCode:)]) {
        [mqtt.delegate mosMqtt:mqtt didConnectedWithReturnCode:rc];
    }
}

static void on_disconnect(struct mosquitto *mosq, void *obj, int rc)
{
    LCMosquittoMqtt *mqtt = (__bridge LCMosquittoMqtt *) obj;
    mqtt.connected = NO;
    
    if (mqtt.delegate && [mqtt.delegate respondsToSelector:@selector(mosMqtt:didDisConnectedWithReturnCode:)]) {
        [mqtt.delegate mosMqtt:mqtt didDisConnectedWithReturnCode:rc];
    }
}

static void on_publish(struct mosquitto *mosq, void *obj, int message_id)
{
    LCMosquittoMqtt *mqtt = (__bridge LCMosquittoMqtt *) obj;
    
    if (mqtt.delegate && [mqtt.delegate respondsToSelector:@selector(mosMqtt:didPublishedWithMessageId:)]) {
        [mqtt.delegate mosMqtt:mqtt didPublishedWithMessageId:message_id];
    }
}

static void on_message(struct mosquitto *mosq, void *obj, const struct mosquitto_message *mosq_msg)
{
    @autoreleasepool {
        LCMosquittoMqtt *mqtt = (__bridge LCMosquittoMqtt *) obj;
        if (mqtt.delegate && [mqtt.delegate respondsToSelector:@selector(mosMqtt:didReceivedMessageWithTopic:data:qos:retain:messageId:)]) {
            NSData *data = [NSData dataWithBytes:mosq_msg->payload length:mosq_msg->payloadlen];
            [mqtt.delegate mosMqtt:mqtt didReceivedMessageWithTopic:[NSString stringWithUTF8String:mosq_msg->topic] data:data qos:mosq_msg->qos retain:mosq_msg->retain messageId:mosq_msg->mid];
        }
    }
}

static void on_subscribe(struct mosquitto *mosq, void *obj, int message_id, int qos_count, const int *granted_qos)
{
    LCMosquittoMqtt *mqtt = (__bridge LCMosquittoMqtt *) obj;
    if (mqtt.delegate && [mqtt.delegate respondsToSelector:@selector(mosMqtt:didSubscribeWithQosCount:grantedQos:subscribeId:)]) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:qos_count];
        for (int i = 0; i < qos_count; i++) {
            [array addObject:@(granted_qos[i])];
        }
        
        [mqtt.delegate mosMqtt:mqtt didSubscribeWithQosCount:qos_count grantedQos:array subscribeId:message_id];
    }
    
}

static void on_unsubscribe(struct mosquitto *mosq, void *obj, int message_id)
{
    LCMosquittoMqtt *mqtt = (__bridge LCMosquittoMqtt *) obj;
    if (mqtt.delegate && [mqtt.delegate respondsToSelector:@selector(mosMqtt:didSubscribeWithQosCount:grantedQos:subscribeId:)]) {
        [mqtt.delegate mosMqtt:mqtt didUnsubscribeWithUnSubscribeId:message_id];
    }
}

@end
