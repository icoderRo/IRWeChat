//
//  LCHttpTool.h
//  LC
//
//  Created by Lc on 16/3/3.
//  Copyright © 2016年 LC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCBaseHttpTool.h"
@class LCSession;

@interface LCHttpTool : NSObject

/**
 *  上传 图片
 *
 *  @param params        参数
 *  @param formDataArray 数据与格式
 *  @param success       成功
 *  @param progress      进度
 *  @param failure       失败
 */
+ (void)uploadImageWithParams:(NSDictionary *)params
             imageSession:(LCSession *)imageSession
                   success:(void (^)(id json))success
                  progress:(void (^)(CGFloat progress))progress
                   failure:(void (^)(NSError *error))failure;

/**
 *  上传 语音
 *
 *  @param params        参数
 *  @param formDataArray 数据与格式
 *  @param success       成功
 *  @param progress      进度
 *  @param failure       失败
 */
+ (void)uploadVoiceWithParams:(NSDictionary *)params
                voiceSession:(LCSession *)voiceSession
                      success:(void (^)(id json))success
                     progress:(void (^)(CGFloat progress))progress
                      failure:(void (^)(NSError *error))failure;

/**
 *  下载音频
 *
 *  @param requestString 请求路劲
 *  @param progress      成功
 *  @param completion    失败
 */
+ (void)downloadVoiceWithRequest:(NSString *)requestString
                      cachesPath:(NSString *)cachesPath
                       progress:(NSProgress *)progress
                     completion:(void (^)(NSURLResponse *response, NSString *filePath, NSError *error))completion;

/**
 *  查询用户会话列表
 *
 */
+ (void)findUserSessionsWithparams:(NSDictionary *)params
                           success:(void (^)(id json))success
                           failure:(void (^)(NSError *error, id json))failure;

/**
 *  查询用户联系人列表
 *
 */
+ (void)findUserContactsWithparams:(NSDictionary *)params
                           success:(void (^)(id json))success
                           failure:(void (^)(NSError *error))failure;
/**
 *  查询用户讨论组列表
 *
 */
+ (void)findUserGroupsWithparams:(NSDictionary *)params
                         success:(void (^)(id json))success
                         failure:(void (^)(NSError *error))failure;

/**
 *  创建讨论组
 *
 */
+ (void)createGroupWithparams:(NSDictionary *)params
                      success:(void (^)(id json))success
                      failure:(void (^)(NSError *error))failure;

/**
 *  添加讨论组成员
 *
 */
+ (void)addGroupUserWithparams:(NSDictionary *)params
                       success:(void (^)(id json))success
                       failure:(void (^)(NSError *error))failure;

/**
 *  查询讨论组所有成员
 *
 */
+ (void)findGroupUsersWithparams:(NSDictionary *)params
                         success:(void (^)(id json))success
                         failure:(void (^)(NSError *error))failure;

/**
 *  退出讨论组
 *
 */
+ (void)exitGroupWithparams:(NSDictionary *)params
                    success:(void (^)(id json))success
                    failure:(void (^)(NSError *error))failure;

/**
 *  查询会话内容
 *
 */


+ (void)findSessionMsgsWithparams:(NSDictionary *)params
                         maxIndex:(NSInteger)maxIndex
                       targetType:(NSInteger)targetType
                completionHandler:(void (^)(id json, NSInteger index))handler;
/**
 *  查询与目标客服的会话
 *
 */
+ (void)findUserSessionWithparams:(NSDictionary *)params
                          success:(void (^)(id json))success
                          failure:(void (^)(NSError *error))failure;
/**
 *  更新会话读取时间
 *
 */
+ (void)updateSessionTmWithPatams:(NSDictionary *)params
                          success:(void (^)(id json))success
                          failure:(void (^)(NSError *error))failure;
@end
