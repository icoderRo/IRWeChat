//
//  LCSettingSwitchItem.h
//  TaiYangHua
//
//  Created by Lc on 15/12/24.
//  Copyright © 2015年 hhly. All rights reserved.
//

#import "LCSettingItem.h"

typedef NS_ENUM(NSInteger, LCSettingSwitchItemType) {
    LCSettingSwitchItemSourceType = 1,
    LCSettingSwitchItemSharkType = 2,
};

@interface LCSettingSwitchItem : LCSettingItem

@property (assign, nonatomic) LCSettingSwitchItemType switchType;

@end
