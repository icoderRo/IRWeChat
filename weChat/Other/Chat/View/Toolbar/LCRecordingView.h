//
//  LCRecordingView.h
//  weChat
//
//  Created by 聪 on 16/4/11.
//  Copyright © 2016年 LC. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, subTitleStatues) {
    subTitleStatuesDefault,
    subTitleStatuesCancel,
};

@interface LCRecordingView : UIView
// 根据 状态更改 显示的内容
+ (void)subTitleLabelStatues:(subTitleStatues)statues;
+ (void)show;
+ (void)dismiss;
@end
