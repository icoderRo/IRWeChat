//
//  LCSettingLoginItem.h
//  TaiYangHua
//
//  Created by Lc on 15/12/24.
//  Copyright © 2015年 hhly. All rights reserved.
//

#import "LCSettingItem.h"

@interface LCSettingLoginItem : LCSettingItem

@property (nonatomic, copy) NSString *yearMothDay;
@property (nonatomic, copy) NSString *hourMinutes;
@property (nonatomic, copy) NSString *machineTypeImageName;

@property (copy, nonatomic) NSString *lastLoginYearMothDay;
@property (copy, nonatomic) NSString *lastLoginHourMinutes;
@property (copy, nonatomic) NSString *curLoginYearMothDay;
@property (copy, nonatomic) NSString *curLoginHourMinutes;

@property (copy, nonatomic) NSString *machineType;
@end
