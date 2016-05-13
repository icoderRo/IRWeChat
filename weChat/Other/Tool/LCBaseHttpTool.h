//
//  LCBaseHttpTool.h
//  weChat
//
//  Created by Lc on 16/4/27.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface LCBaseHttpTool : AFHTTPSessionManager

+ (instancetype)shareInstance;
/**
 *  发送一个POST请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
- (void)postWithURL:(NSString *)url
             params:(NSDictionary *)params
            success:(void (^)(id json))success
            failure:(void (^)(NSError *error))failure;

/**
 *  发送一个POST请求(上传文件数据)
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param formData  文件参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
- (void)postWithURL:(NSString *)url
             params:(NSDictionary *)params
      formDataArray:(NSArray *)formDataArray
            success:(void (^)(id json))success
           progress:(void (^)(CGFloat progress))progress
            failure:(void (^)(NSError *error))failure;

/**
 *  发送一个GET请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
- (void)getWithURL:(NSString *)url
            params:(NSDictionary *)params
           success:(void (^)(id json))success
           failure:(void (^)(NSError *error))failure;

/**
 *  下载文件
 *
 *  @param request     下载请求
 *  @param progress    下载进度
 *  @param destination 存储路径
 *  @param completion  完成后的回调
 */
- (void)downloadTaskWithRequest:(NSURLRequest *)request
                       progress:(NSProgress *)progress
                    destination:(NSURL * (^)(NSURLResponse *response))destination
                     completion:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completion;

@end

/**
 *  文件数据模型
 */

@interface LCFormData : NSObject
/**
 *  文件数据
 */
@property (nonatomic, strong) NSData *data;

/**
 *  参数名
 */
@property (nonatomic, copy) NSString *name;

/**
 *  文件名
 */
@property (nonatomic, copy) NSString *filename;

/**
 *  文件类型
 */
@property (nonatomic, copy) NSString *mimeType;

@end
