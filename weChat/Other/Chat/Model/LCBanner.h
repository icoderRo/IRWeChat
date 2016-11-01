//
//  LCBanner.h
//  weChat
//
//  Created by Lc on 16/4/28.
//  Copyright © 2016年 LC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCBanner : NSObject

/**
 *  提醒:例如加入讨论组等
 */
@property (copy, nonatomic) NSString *alertString;

/**
 *  每组cell的时间
 */
@property (copy, nonatomic) NSString *timerString;

+ (instancetype)bannerWithTimerString:(NSString *)string;

+ (instancetype)bannerWithAlertString:(NSString *)string;
@end
