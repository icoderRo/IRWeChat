//
//  LCLoginStatusView.m
//  TaiYangHua
//
//  Created by Lc on 15/12/24.
//  Copyright © 2015年 hhly. All rights reserved.
//

#import "LCLoginStatusView.h"
#import "LCSettingLoginItem.h"

@interface LCLoginStatusView ()
@property (weak, nonatomic) IBOutlet UIImageView *machineTypeImageView;
@property (weak, nonatomic) IBOutlet UILabel *yearMothDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *hourMinutesLabel;


@end

@implementation LCLoginStatusView

- (void)setLoginStatusModel:(LCSettingLoginItem *)loginStatusModel
{
    _loginStatusModel = loginStatusModel;
    self.machineTypeImageView.image = [UIImage imageNamed:loginStatusModel.machineTypeImageName];
    self.yearMothDayLabel.text = loginStatusModel.yearMothDay;
    self.hourMinutesLabel.text = loginStatusModel.hourMinutes;
} 
@end
