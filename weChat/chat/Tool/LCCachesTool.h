//
//  LCCachesTool.h
//  weChat
//
//  Created by Lc on 16/4/12.
//  Copyright © 2016年 LC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LCSession;

@interface LCCachesTool : NSObject
/**
 *  存储多条session数据
 *
 */
+ (void)addSessions:(NSArray *)sessionArray;

/**
 *  存储一条session
 *
 */
+ (void)addSession:(LCSession *)session;

/**
 *  根据maxIndex 和minIndex查询数据
 *
 *  @param param 参数
 *
 */
+ (NSArray *)selectSessionWithIndexParam:(NSDictionary *)param;

/**
 *  根据maxIndex 和number查询数据
 *
 *  @param param 参数
 *
 */
+ (NSArray *)selectSessionWithNumberParams:(NSDictionary *)param;
@end
