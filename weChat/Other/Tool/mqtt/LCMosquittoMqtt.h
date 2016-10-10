//
//  LCMosquittoMqtt.h
//  LCMosquittoMqtt
//
//  Created by Lc on 16/6/27.
//  Copyright © 2016年 LC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "mosquitto.h"

//MOTT文档: https://mcxiaoke.gitbooks.io/mqtt-cn/content/
//mosquitto代理服务器 https://github.com/eclipse/mosquitto.git

/** QoS(Quality of Service,服务质量) */
typedef NS_ENUM(UInt8, MQTTQosLevel) {
    MQTTQosLevelAtMostOnce = 0,               //至多一次，发完即丢弃，<=1
    MQTTQosLevelAtLeastOnce = 1,              //至少一次, 可能重复，需要确认回复，>=1
    MQTTQosLevelExactlyOnce = 2,              //只有一次，需要确认回复，＝1
};

/** 连接返回码(Connect Return code) */
typedef NS_ENUM(NSUInteger, MQTTConnectReturnCode) {
    MQTTConnectAccepted = 0, // 连接已被服务端接受
    MQTTConnectRefusedUnAcceptableProtocolVersion, // 服务端不支持客户端请求的MQTT协议级别
    MQTTConnectRefusedIdentiferRejected, // 客户端标识符是正确的UTF-8编码，但服务端不允许使用
    MQTTConnectRefusedServerUnavailable, // 网络连接已建立，但MQTT服务不可用
    MQTTConnectRefusedBadUserNameOrPassword, //用户名或密码的数据格式无效
    MQTTConnectRefusedNotAuthorized, // 客户端未被授权连接到此服务器
};

/** MQTT 断开连接的原因, 0为调用<mosquitto_disconnect>断开, 其余未知 */
typedef NS_ENUM(UInt8, MQTTDisconnectReturnCode) {
    MQTTMosquittoDisconnect = 0,               // <mosquitto_disconnect>.断开
    
};

@class LCMosquittoMqtt;
@protocol LCMosquittoMqttDelegate <NSObject>

@optional

/**
 *  连接回调
 *
 *  @param mqtt mqtt
 *  @param code 连接状态码
 */
- (void)mosMqtt:(LCMosquittoMqtt *)mosMqtt didConnectedWithReturnCode:(MQTTConnectReturnCode)code;

/**
 *   断开回调
 *
 *  @param mqtt mqtt
 *  @param code 断开连接状态码
 */
- (void)mosMqtt:(LCMosquittoMqtt *)mosMqtt didDisConnectedWithReturnCode:(MQTTDisconnectReturnCode)code;

/**
 *  发布回调
 *
 *  @param mqtt      mqtt
 *  @param MessageId 消息索引
 */
- (void)mosMqtt:(LCMosquittoMqtt *)mosMqtt didPublishedWithMessageId:(int)MessageId;

/**
 *  消息回调 (when a message is received from the broker)
 *
 *  @param mqtt      mqtt
 *  @param topic     主题
 *  @param message   文本
 *  @param qos       服务质量
 *  @param retain    是否保持
 *  @param MessageId 消息索引
 */
- (void)mosMqtt:(LCMosquittoMqtt *)mosMqtt didReceivedMessageWithTopic:(NSString *)topic data:(NSData *)data qos:(MQTTQosLevel)qos retain:(BOOL)retain  messageId:(NSUInteger)MessageId;

/**
 *  订阅回调
 *
 *  @param mqtt        mqtt
 *  @param qosCount    授予订购的数量
 *  @param grantedQos  授予的QoS订阅数组
 *  @param subscribeId 订阅消息的id.
 */
- (void)mosMqtt:(LCMosquittoMqtt *)mosMqtt didSubscribeWithQosCount:(NSUInteger)qosCount grantedQos:(NSArray *)grantedQos subscribeId:(int)subscribeId;

/**
 *  退订回调
 *
 *  @param mqtt          mqtt
 *  @param unSubscribeId 取消订阅消息的id.
 */
- (void)mosMqtt:(LCMosquittoMqtt *)mosMqtt didUnsubscribeWithUnSubscribeId:(int)unSubscribeId;
@end


@interface LCMosquittoMqtt : NSObject

//+ (instancetype)shareInstance;

@property (weak, nonatomic) id<LCMosquittoMqttDelegate> delegate;


/**
 *  客户端标识符 (ClientId) 必须存在而且必须是CONNECT报文有效载荷的第一个字段
 */
@property (copy, nonatomic) NSString *clientID;

/**
 *  是否连接
 */
@property (assign, nonatomic, getter=isConnected) BOOL connected;


/**
 *  连接
 *
 *  @param host                          ip
 *  @param port                          端口
 *  @param userName                      用户名
 *  @param password                      密码
 *  @param keepAlive                     空闲最大时间
 *  @param reconnect_delay               延迟多少秒连接
 *  @param reconnect_delay_max           最大延迟多少面
 
 
 *  @param reconnect_exponential_backoff
 
 * Example 1:
 *	delay=2, delay_max=10, exponential_backoff=False
 *	Delays would be: 2, 4, 6, 8, 10, 10, ...
 *
 * Example 2:
 *	delay=3, delay_max=30, exponential_backoff=True
 *	Delays would be: 3, 6, 12, 24, 30, 30, ...

 
 */
- (void)connectToHost:(NSString *)host port:(int)port userName:(NSString *)userName password:(NSString *)password keepAlive:(int)keepAlive reconnect_delay:(unsigned int)reconnect_delay reconnect_delay_max:(unsigned int)reconnect_delay_max reconnect_exponential_backoff:(BOOL)reconnect_exponential_backoff;

/**
 *  断开连接
 */
- (void)disconnect;

/**
 *  重连
 */
- (void)reconnect;

/**
 *  发布消息
 *
 *  @param data   NSData数据类型
 *  @param topic  主题
 *  @param qos    服务质量
 *  @param retain 保留标志
 */
- (void)publishData:(NSData *)data topic:(NSString *)topic qos:(MQTTQosLevel)qos retain:(BOOL)retain;

/**
 *  订阅
 *
 *  @param topic 主题
 *  @param qos   服务质量
 */
- (void)subscribeWithTopic:(NSString *)topic qos:(MQTTQosLevel)qos;

/**
 *  取消订阅
 *
 *  @param topic 主题
 */
- (void)unSubscribeWithTopic:(NSString *)topic;

/**
 *  设置遗嘱
 *
 *  @param data   遗嘱
 *  @param topic  主题
 *  @param qos    服务质量
 *  @param retain 保留标志
 */
- (void)setWillData:(NSData *)data toTopic:(NSString *)topic qos:(MQTTQosLevel)qos retain:(BOOL)retain;

/**
 *  清楚遗嘱
 */
- (void)clearWill;
@end
