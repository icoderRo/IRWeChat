//
//  LCSocketDecoder.h
//  LCSocket
//
//  Created by Lc on 16/6/2.
//  Copyright © 2016年 LC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCSocketCoderProtocol.h"

/**
 * 服务器: netty  LengthFieldBasedFrameDecoder(100000000,0,4,0,4)
 * 传输协议
 * |------------------------------------------
 * |总长度4byte |pkey长度4byte      |
 * |------------------------------------------
 * | value 4byte|name 4byte|zip  1 |
 * |------------------------------------------
 * |skey值      8byte(long型时间，固定) |
 * |------------------------------------------------
 * |  包体内容                                             |
 * |
 * |------------------------------------------------
 */

@interface LCSocketDecoder : NSObject <LCSocketDecoderProtocol>

@end
