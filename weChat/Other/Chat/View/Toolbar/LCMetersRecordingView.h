//
//  LCMetersRecordingView.h
//  Antenna
//
//  Created by Lc on 16/4/8.
//  Copyright © 2016年 HHLY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, subTitleStatues) {
    subTitleStatuesDefault,
    subTitleStatuesCancel,
};
@interface LCMetersRecordingView : UIView
// 根据 状态更改 显示的内容
+ (void)subTitleLabelStatues:(subTitleStatues)statues;
+ (void)show;
+ (void)dismiss;
@end
