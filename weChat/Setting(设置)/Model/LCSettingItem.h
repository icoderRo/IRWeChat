//
//  LCSettingItem.h
//  TaiYangHua
//
//  Created by Lc on 15/12/24.
//  Copyright © 2015年 hhly. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^operation)();

@interface LCSettingItem : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *headerImageName;
@property (copy, nonatomic) operation operational;

+ (instancetype)itemWithTitle:(NSString *)title;
+ (instancetype)itemWithHeaderImageName:(NSString *)headerImageName title:(NSString *)title;


@end
