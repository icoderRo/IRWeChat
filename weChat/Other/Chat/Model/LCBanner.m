//
//  LCBanner.m
//  weChat
//
//  Created by Lc on 16/4/28.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LCBanner.h"

@implementation LCBanner
+ (instancetype)bannerWithTimerString:(NSString *)string
{
    LCBanner *banner = [[self alloc] init];
    banner.timerString = string;
    
    return banner;
}

+ (instancetype)bannerWithAlertString:(NSString *)string
{
    LCBanner *banner = [[self alloc] init];
    banner.alertString = string;
    
    return banner;
}
@end
