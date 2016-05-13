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
+ (void)subTitleLabelStatues:(subTitleStatues)statues;
+ (void)show;
+ (void)dismiss;
@end
