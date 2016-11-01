//
//  LCHttpParamTool.h
//  LC
//
//  Created by Lc on 16/3/22.
//  Copyright © 2016年 LC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCSession.h"
@interface LCHttpParamTool : NSObject

/**
 *  返回会话历史记录参数
 *
 *  @param sessionId 会话ID
 *  @param maxIndex  从哪个索引开始
 *  @param num       查询条数
 *  
 *  @return 参数
 */
+ (NSDictionary *)sessionsWithSessionId:(NSString *)sessionId maxIndex:(NSInteger)maxIndex num:(int)num;

/**
 *  返回上传语音的参数
 *
 *  @param session 模型
 *
 *  @return 参数
 */
+ (NSDictionary *)voiceParamsWithSession:(LCSession *)session;

/**
 *  返回发送语音URL的参数
 *
 *  @param session 模型
 *  @param fileURL 服务器返回的语音路径
 *
 *  @return 参数
 */
+ (NSDictionary *)voiceURLParamsWithSession:(LCSession *)session fileURL:(NSString *)fileURL;

/**
 *  返回上传图片的参数
 *
 *  @param session 模型
 *
 *  @return 参数
 */
+ (NSDictionary *)imageParamsWithSession:(LCSession *)session;

/**
 *  返回发送图片URL的参数
 *
 *  @param session 模型
 *  @param fileURL 服务器返回的语音路径
 *
 *  @return 参数
 */
+ (NSDictionary *)imageURLParamsWithSession:(LCSession *)session fileURL:(NSString *)fileURL;

/**
 *  更新消息为已读
 *
 *  @param sessionId   会话ID
 *  @param messageTime 消息时间
 *
 *  @return 参数
 */

+ (NSDictionary *)updateSessionTmWithSessionId:(NSString *)sessionId messageTime:(NSInteger)messageTime;
@end
