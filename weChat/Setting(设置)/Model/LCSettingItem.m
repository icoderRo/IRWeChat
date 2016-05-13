//
//  LCSettingItem.m
//  TaiYangHua
//
//  Created by Lc on 15/12/24.
//  Copyright © 2015年 hhly. All rights reserved.
//

#import "LCSettingItem.h"

@implementation LCSettingItem

+ (instancetype)itemWithTitle:(NSString *)title
{
    LCSettingItem *item = [[self alloc] init];
    item.title = title;
    
    return item;
}

+ (instancetype)itemWithHeaderImageName:(NSString *)headerImageName title:(NSString *)title
{
    LCSettingItem *item = [self itemWithTitle:title];
    item.headerImageName = headerImageName;
    
    return item;
}
@end
