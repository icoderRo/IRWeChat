//
//  NSData+LCCategory.h
//  weChat
//
//  Created by Lc on 16/4/11.
//  Copyright © 2016年 LC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (LCCategory)
/**
 *  从sd查找缓存的图片
 */
+ (NSData *)imageDataWithURL:(NSString *)imageURL;

//- (NSString *)cachesImageDataWithFileName:(NSString *)fileName;

/**
 *  压缩图片
 */
- (NSData *)compressImage:(UIImage *)image toMaxFileSize:(NSInteger)maxFileSize;
@end
