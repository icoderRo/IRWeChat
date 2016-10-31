//
//  LCEmotionPopView.h
//  weChat
//
//  Created by Lc on 16/4/27.
//  Copyright © 2016年 LC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LCEmotion;
@interface LCEmotionPopView : UIView
+ (instancetype)popView;

- (void)showFrom:(UIButton *)button emotion:(LCEmotion *)emotion;
@end
