//
//  LCSocketEncoder.m
//  LCSocket
//
//  Created by Lc on 16/6/6.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LCSocketEncoder.h"

@implementation LCSocketEncoder
static NSUInteger countOfLengthByte = 4;

- (void)encode:(id)object output:(id<LCSocketEncoderOutputProtocol>)output
{
    
    if (![NSJSONSerialization isValidJSONObject:object]) {
        [output didEndEncode:nil error:[NSError errorWithDomain:@"数据不能解析为json" code:-1 userInfo:nil]];
        return;
    }
    
    NSError *error = nil;
    NSData *contentData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    NSString *contentStr = [[NSString alloc] initWithData:contentData encoding:NSUTF8StringEncoding];
    contentData = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
    
    if (contentData.length > 1000000 - countOfLengthByte) {
        [output didEndEncode:nil error:[NSError errorWithDomain:@"encoder的数据太长" code:-1 userInfo:nil]];
        return;
    }
    
    NSUInteger contentDataLength = contentData.length;
    NSData *headData = [self dataForLength:contentDataLength byteCount:countOfLengthByte reverse:NO];
    
    NSMutableData *data = [NSMutableData data];
    [data appendData:headData];
    [data appendData:contentData];
    

    [output didEndEncode:data error:nil];
}


- (NSData *)dataForLength:(NSUInteger)value byteCount:(NSUInteger)byteCount reverse:(BOOL)reverse
{
    NSData *tempData = [self dataForLength:value byteCount:byteCount];
    if (reverse) return tempData;
    return [self dataWithReverse:tempData];
}


- (NSData *)dataForLength:(NSUInteger)length byteCount:(NSUInteger)byteCount
{
    NSMutableData *valData = [NSMutableData data];
    NSUInteger templen = length;
    
    int offset = 0;
    while (offset < byteCount) {
        unsigned char valChar = 0xff & templen;
        [valData appendBytes:&valChar length:1];

        templen = templen >> 8;
        offset++;
    }

    return valData;
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
