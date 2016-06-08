//
//  LCBaseSocket.h
//  LCSocket
//
//  Created by Lc on 16/6/6.
//  Copyright © 2016年 LC. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LCBaseSocket;

@protocol LCBaseSocketDelegate <NSObject>

- (void)baseSocketDidDisConnect:(LCBaseSocket *)socket withError:(NSError *)err;
- (void)baseSocket:(LCBaseSocket *)socket didConnectToHost:(NSString *)host port:(uint16_t)port;
- (void)baseSocket:(LCBaseSocket *)socket didReadData:(NSData *)data withTag:(long)tag;
- (void)baseSocket:(LCBaseSocket *)socket didWriteDataWithTag:(long)tag;

@end

@interface LCBaseSocket : NSObject

@property (weak, nonatomic) id<LCBaseSocketDelegate> delegate;

+ (instancetype)shareInstance;

- (BOOL)isConnected;

- (void)disconnect;

- (void)reconnect;

- (void)writeData:(NSData *)data withTimeout:(NSTimeInterval)timeout tag:(long)tag;

- (void)readDataWithTimeout:(NSTimeInterval)timeout tag:(long)tag;

- (BOOL)connectToHost:(NSString *)hostName port:(int)port;
@end
