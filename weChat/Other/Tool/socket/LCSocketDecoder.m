//
//  LCSocketDecoder.m
//  LCSocket
//
//  Created by Lc on 16/6/2.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LCSocketDecoder.h"

@interface LCSocketDecoder ()

@property (strong, nonatomic) NSMutableData *tempData;
@property (assign, nonatomic, getter=isNeedAppend) BOOL needAppend;
@end

@implementation LCSocketDecoder
static NSUInteger countOfLengthByte = 4;

- (NSMutableData *)tempData
{
    if (!_tempData) {
        _tempData = [NSMutableData data];
    }
    
    return _tempData;
}

- (void)decode:(id)object output:(id<LCSocketDecoderOutputProtocol>)output
{
    if (![object isKindOfClass:[NSData class]]) {
        [output didEndDecode:nil error:[NSError errorWithDomain:@"当前数据类型非NSData" code:-1 userInfo:nil]];
        return;
    }
    
    self.needAppend = NO;
    NSData *packetData = object;
    [self.tempData appendData:packetData];
    packetData = [self.tempData copy];
    
    NSData *headerData = [packetData subdataWithRange:NSMakeRange(0, countOfLengthByte)];
    NSUInteger contentLength = [self lengthForData:headerData reverse:YES];
    
    while (packetData.length >= contentLength) { // 粘包
        if (contentLength > 1000000 - countOfLengthByte) { // 服务器定的...
            [output didEndDecode:nil error:[NSError errorWithDomain:@"数据太长" code:-1 userInfo:nil]];
            return;

        }
        
        NSData *contentData = [packetData subdataWithRange:NSMakeRange(countOfLengthByte, contentLength)];
        [output didEndDecode:contentData error:nil];
        
        packetData = [packetData subdataWithRange:NSMakeRange(contentLength + countOfLengthByte , packetData.length - contentLength - countOfLengthByte)];
        
        if (packetData.length < countOfLengthByte) {
            if (self.tempData.length != 0) {
                [self.tempData resetBytesInRange:NSMakeRange(0, self.tempData.length)];
                [self.tempData setLength:0];
                self.needAppend = YES;
            }
            break;
        }
    
        headerData = [packetData subdataWithRange:NSMakeRange(0, countOfLengthByte)];
        contentLength = [self lengthForData:headerData reverse:YES];
        
        if (self.tempData.length != 0) {
            [self.tempData resetBytesInRange:NSMakeRange(0, self.tempData.length)];
            [self.tempData setLength:0];
        }
        
        self.needAppend = YES;
    }
    
    if (self.isNeedAppend) { // 半包等待下次数据进行拼接
        [self.tempData appendData:packetData];
    }
}

- (NSUInteger)lengthForData:(NSData *)data reverse:(BOOL)reverse
{
    NSData *tempData = data;
    if (reverse) tempData = [self dataWithReverse:tempData];
    return [self lengthForData:tempData];
}


- (NSUInteger)lengthForData:(NSData *)data
{
    NSUInteger dataLen = data.length;
    NSUInteger length = 0;
    
    int offset = 0;
    while (offset < dataLen) {
        NSUInteger tempVal = 0;
        [data getBytes:&tempVal range:NSMakeRange(offset, 1)];
        length += (tempVal << (8 * offset));
        offset++;
    }
    
    return length;
}

- (NSData *)dataWithReverse:(NSData *)data
{
    NSMutableData *dstData = [[NSMutableData alloc] initWithData:data];
    NSUInteger count = data.length / 2;
    
    for (NSUInteger i = 0; i < count; i++) {
        
        NSRange head = NSMakeRange(i, 1);
        NSRange end = NSMakeRange(data.length - i - 1, 1);
        
        NSData *headData = [data subdataWithRange:head];
        NSData *endData = [data subdataWithRange:end];
        
        [dstData replaceBytesInRange:head withBytes:endData.bytes];
        [dstData replaceBytesInRange:end withBytes:headData.bytes];
    }
    
    return dstData;
}
@end
