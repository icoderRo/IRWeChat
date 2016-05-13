//
//  LCSessionList.m
//  TaiYangHua
//
//  Created by Lc on 16/1/18.
//  Copyright © 2016年 hhly. All rights reserved.
//

#import "LCSessionList.h"

@implementation LCSessionList

+ (instancetype)internalSessionListWithHeadrImage:(NSString *)headerImage name:(NSString *)name detailSession:(NSString *)detailSession unreadCount:(NSString *)unreadCount time:(NSString *)time
{
    LCSessionList *internalSessionList = [[LCSessionList alloc] init];
    
    internalSessionList.headUrl = headerImage;
    internalSessionList.targetName = name;
    internalSessionList.lastMessage = detailSession;
    internalSessionList.unReadSize = unreadCount;
    internalSessionList.lastMessageTime = time;
    
    return internalSessionList;
}

@end
