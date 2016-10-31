//
//  LCEmotionView.h
//  weChat
//
//  Created by Lc on 16/3/29.
//  Copyright © 2016年 LC. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^didclickSender)();
@interface LCEmotionView : UIView
@property (copy, nonatomic) didclickSender didclickSenderEmotion;
@end
