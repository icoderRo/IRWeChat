//
//  LCEmotion.m
//  weChat
//
//  Created by Lc on 16/2/26.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LCEmotion.h"

@implementation LCEmotion

+ (instancetype)emotionWithDict:(NSDictionary *)dict
{
    LCEmotion *emotion = [[LCEmotion alloc] init];
    emotion.chs = dict[@"chs"];
    emotion.png = dict[@"png"];
    
    return emotion;
}

@end
