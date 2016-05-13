//
//  TYHInterGroupList.m
//  TaiYangHua
//
//  Created by Lc on 16/1/19.
//  Copyright © 2016年 hhly. All rights reserved.
//

#import "LCGroupList.h"

@implementation LCGroupList
+ (instancetype)internalGroupListWithHeadrImage:(NSString *)headerImage name:(NSString *)name detailSession:(NSString *)detailSession unreadCount:(NSString *)unreadCount time:(NSString *)time
{
    LCGroupList *internalSessionList = [[LCGroupList alloc] init];
    
    internalSessionList.headUrl = headerImage;
    internalSessionList.groupName = name;
    internalSessionList.detailSession = detailSession;
    internalSessionList.unreadCount = unreadCount;
    internalSessionList.time = time;
    
    return internalSessionList;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.targetType = 2;
    }
    
    return self;
}
@end
