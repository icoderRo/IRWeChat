//
//  LCSettingArrowItem.h
//  TaiYangHua
//
//  Created by Lc on 15/12/24.
//  Copyright © 2015年 hhly. All rights reserved.
//

#import "LCSettingItem.h"

typedef void(^operation)();

@interface LCSettingArrowItem : LCSettingItem

@property (copy, nonatomic) operation operation;
@end
