//
//  NSString+LCCatory.h
//  weChat
//
//  Created by Lc on 16/3/29.
//  Copyright © 2016年 LC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LCCatory)
/**
 *  文本转换为富文本
 */
- (NSAttributedString *)emotionStringWithWH:(CGFloat)WH;
/**
 *  时间
 */
- (NSString *)timeString;
/**
 *  录音文件名
 *
 */
+ (NSString *)recordFileName;
/**
 *  录音文件地址
 */
+ (NSString *)recordPathWithfileName:(NSString *)fileName;

/**
 *  图片地址
 *
 */
+ (NSString *)imageCachesPathWithImageName:(NSString *)imageName;
@end
