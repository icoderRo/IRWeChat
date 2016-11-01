//
//  LCSocketCoderProtocol.h
//  LCSocket
//
//  Created by Lc on 16/6/2.
//  Copyright © 2016年 LC. All rights reserved.
//

#import <Foundation/Foundation.h>

// decoder
#pragma mark - decoder output protocol
@protocol LCSocketDecoderOutputProtocol <NSObject>

@required

/**
 *  数据解码后，分发对象协议
 */
- (void)didEndDecode:(id)decodedPacket error:(NSError *)error;

@end


#pragma mark - decoder protocol
@protocol LCSocketDecoderProtocol <NSObject>

@required

/**
 *  根据服务器的格式解码数据
 *
 *  @param object 推送过来的数据
 *  @param output 解码后的数据
 *
 *  @return 错误码
 */
- (void)decode:(id)object output:(id<LCSocketDecoderOutputProtocol>)output;

@end





// encoder
#pragma mark - encoder output protocol
@protocol LCSocketEncoderOutputProtocol <NSObject>

@required

/**
 *  将字典编码为服务器格式的数据
 */
- (void)didEndEncode:(id)encodedPacket error:(NSError *)error;

@end


#pragma mark - encoder protocol
@protocol LCSocketEncoderProtocol <NSObject>

@required

/**
 *  根据服务器的格式编码数据
 *
 *  @param object 数据源
 *  @param output 编码后的数据
 *
 */
- (void)encode:(id)object output:(id<LCSocketEncoderOutputProtocol>)output;

@end
