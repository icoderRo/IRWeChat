//
//  LCPhotosView.h
//  weChat
//
//  Created by Lc on 16/5/9.
//  Copyright © 2016年 LC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCPhotosView : UIView
@property (strong, nonatomic) NSArray *photos;

+ (CGSize)photosViewSizeWithPhotosCount:(NSInteger)count image:(UIImage *)image;
@end
