//
//  UIImage+LCCategory.h
//  weChat
//
//  Created by Lc on 16/3/29.
//  Copyright © 2016年 LC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LCCategory)
/**
 *  将颜色转换为图片
 */
+ (UIImage *)createImageWithColor:(UIColor*) color;


/**
 *  修正上传服务器后,图片的显示方向
 *
 */
- (UIImage *)fixOrientation;

/**
 *  按比例缩小图片
 */
- (CGSize)fixSizeWithImageSize:(CGSize)size rate:(NSInteger)rate;
@end
