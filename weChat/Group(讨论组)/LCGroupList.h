//
//  TYHInterGroupList.h
//  TaiYangHua
//
//  Created by Lc on 16/1/19.
//  Copyright © 2016年 hhly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCGroupList : NSObject
/** 群组名称*/
@property (copy, nonatomic) NSString *groupName;
/** 群组头像*/
@property (copy, nonatomic) NSString *headUrl;
/** 会话标志 1-个聊 2-群聊*/
@property (assign, nonatomic) NSInteger targetType;
@property (copy, nonatomic) NSString *detailSession;
@property (copy, nonatomic) NSString *time;
@property (copy, nonatomic) NSString *unreadCount;

+ (instancetype)internalGroupListWithHeadrImage:(NSString *)headerImage name:(NSString *)name detailSession:(NSString *)detailSession unreadCount:(NSString *)unreadCount time:(NSString *)time;
@end
