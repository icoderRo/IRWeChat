//
//  LCBaseSocket.m
//  LCSocket
//
//  Created by Lc on 16/6/6.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LCBaseSocket.h"
#import "GCDAsyncSocket.h"

@interface LCBaseSocket ()<GCDAsyncSocketDelegate>
@property (strong, nonatomic) GCDAsyncSocket *asyncSocket;
@property (copy, nonatomic) NSString *hostName;
@property (assign, nonatomic) int port;
@end

@implementation LCBaseSocket

+ (instancetype)shareInstance
{
    static LCBaseSocket *baseSocket = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        baseSocket = [[self alloc] init];
    });
    
    return baseSocket;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        self.asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        [self.asyncSocket setIPv4PreferredOverIPv6:NO];
    }
    
    return self;
}

- (BOOL)connectToHost:(NSString *)hostName port:(int)port
{
    NSError *error = nil;
    self.hostName = hostName;
    self.port = port;
    return [self.asyncSocket connectToHost:hostName onPort:port error:&error];
}

- (BOOL)isConnected
{
    return [self.asyncSocket isConnected];
}

- (void)disconnect
{
    [self.asyncSocket disconnect];
}

- (void)reconnect
{
    if ([self isConnected]) {
        [self.asyncSocket setDelegate:nil];
        [self.asyncSocket disconnect];
    }

    [self.asyncSocket setDelegate:self delegateQueue:dispatch_get_main_queue()];
    [self.asyncSocket setIPv4PreferredOverIPv6:NO];
    [self connectToHost:self.hostName port:self.port];
}

- (void)writeData:(NSData *)data withTimeout:(NSTimeInterval)timeout tag:(long)tag
{
    [self.asyncSocket writeData:data withTimeout:timeout tag:tag];
}

- (void)readDataWithTimeout:(NSTimeInterval)timeout tag:(long)tag
{
    [self.asyncSocket readDataWithTimeout:timeout tag:tag];
}

#pragma mark - GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    [sock readDataWithTimeout:-1 tag:tag];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(baseSocket:didReadData:withTag:)]) {
        [self.delegate baseSocket:self didReadData:data withTag:tag];
    }
    [sock readDataWithTimeout:-1 tag:tag];
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(baseSocket:didConnectToHost:port:)]) {
        [self.delegate baseSocket:self didConnectToHost:host port:port];
    }

}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(baseSocketDidDisConnect:withError:)]) {
        [self.delegate baseSocketDidDisConnect:self withError:err];
    }
}

- (void)dealloc
{
    [self.asyncSocket setDelegate:nil];
    [self.asyncSocket disconnect];
    self.asyncSocket = nil;
}
@end
