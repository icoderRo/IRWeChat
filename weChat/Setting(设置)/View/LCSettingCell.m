//
//  LCSettingCell.m
//  TaiYangHua
//
//  Created by Lc on 15/12/24.
//  Copyright © 2015年 hhly. All rights reserved.
//

#import "LCSettingCell.h"
#import "LCSettingItem.h"
#import "LCSettingSwitchItem.h"
#import "LCSettingArrowItem.h"
#import "LCSettingLoginItem.h"
#import "LCLoginStatusView.h"
#import "LCSettingStatusItem.h"
#import "LCSettingConst.h"
#import <AudioToolbox/AudioToolbox.h>

@interface LCSettingCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint;
@property (weak, nonatomic) UISwitch *switchView;
@property (weak, nonatomic) LCLoginStatusView *loginStatusView;
@property (weak, nonatomic) UILabel *statusLabel;
@property (weak, nonatomic) UIImageView *statusImageView;

@end

@implementation LCSettingCell

#pragma mark - lazy
- (UIImageView *)statusImageView
{
    if (!_statusImageView) {
        UIImageView *imageV = [[UIImageView alloc] init];
        _statusImageView = imageV;
        [self.headerImageView addSubview:_statusImageView];
        
        [_statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@(12));
            make.bottom.equalTo(self.headerImageView).offset(-7);
            make.right.equalTo(self.headerImageView).offset(-12);
        }];
    }
    return _statusImageView;
}

- (UILabel *)statusLabel
{
    if (!_statusLabel) {
        UILabel *sLabel = [[UILabel alloc] init];
        _statusLabel = sLabel;
        _statusLabel.text = @"在线";
        _statusLabel.font = [UIFont systemFontOfSize:15];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.textColor = LCColor(187, 186, 193);
        _statusLabel.hidden = YES;
        [self.contentView addSubview:_statusLabel];
        
        [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-LCSettingLabelMargin);
            make.top.bottom.equalTo(self.contentView);
        }];
        
    }
    return _statusLabel;
}

- (LCLoginStatusView *)loginStatusView
{
    if (!_loginStatusView) {
        LCLoginStatusView *lsView = [LCLoginStatusView viewFromXib];
        _loginStatusView = lsView;
        _loginStatusView.loginStatusModel = (LCSettingLoginItem *)self.item;
        [self.contentView addSubview:_loginStatusView];
    }
    return _loginStatusView;
}

- (UISwitch *)switchView
{
    if (!_switchView) {
        LCSettingSwitchItem *switchItem = (LCSettingSwitchItem *)self.item;
        UISwitch *switchT = [[UISwitch alloc] init];
        switchT.tag = switchItem.switchType;
        _switchView = switchT;
        _switchView.onTintColor = LCColor(28, 98, 222);
        [_switchView addTarget:self action:@selector(switchValueChange:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:_switchView];
    }
    return _switchView;
}

#pragma mark - monitor & Cache
- (void)switchValueChange:(UISwitch *)switchView
{
    [[NSUserDefaults standardUserDefaults] setBool:self.switchView.isOn forKey:self.item.title];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (switchView.isOn && switchView.tag == LCSettingSwitchItemSharkType) {
        [self sharkStart];
    } else if (switchView.isOn && switchView.tag == LCSettingSwitchItemSourceType){
        [self sourcePlay];
    } else {
        return;
    }
}

- (void)sharkStart
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)sourcePlay
{
    NSURL *soundURL = [[NSBundle mainBundle] URLForResource:@"receive_msg"
                                              withExtension:@"caf"];
    SystemSoundID ID;
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(soundURL), &ID);
    
    AudioServicesPlaySystemSound(ID);
    
}

#pragma mark - init
- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeStatus:) name:LCSettingStatusChangeViewDidChangeStatus object:nil];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didChangeStatus:(NSNotification *)note
{
    NSString *title = note.userInfo[@"title"];
    self.statusLabel.text = title;
    self.statusImageView.image = [UIImage imageNamed:title];
}

- (void)setItem:(LCSettingItem *)item
{
    [self setupLeftStatus:item];
    [self setupRightStatus:item];
}


- (void)setupRightStatus:(LCSettingItem *)item
{
    _item = item;
    
    if ([item isKindOfClass:[LCSettingArrowItem class]]) {
        self.accessoryView = nil;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.statusLabel.hidden = YES;
        
    } else if ([item isKindOfClass:[LCSettingSwitchItem class]]){
        self.accessoryView = self.switchView;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.statusLabel.hidden = YES;
        self.switchView.on = [[NSUserDefaults standardUserDefaults] boolForKey:self.item.title];
        
    } else if ([item isKindOfClass:[LCSettingLoginItem class]]){
        self.accessoryView = self.loginStatusView;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.statusLabel.hidden = YES;
        
    } else if ([item isKindOfClass:[LCSettingStatusItem class]]){
        self.accessoryView = nil;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.statusLabel.hidden = NO;
        
    } else {
        self.accessoryView = nil;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.statusLabel.hidden = YES;
    }
}

- (void)setupLeftStatus:(LCSettingItem *)item
{
    _item = item;
    
    if (item.headerImageName) {
        self.headerImageView.hidden = NO;
        self.headerImageView.image = [UIImage imageNamed:item.headerImageName];
        self.constraint.priority = UILayoutPriorityDefaultLow;
        self.statusImageView.image = [UIImage imageNamed:@"在线"];
    } else {
        self.headerImageView.hidden = YES;
        self.constraint.priority = UILayoutPriorityDefaultHigh;
    }
    
    self.titleLabel.text = item.title;
}

- (void)setFrame:(CGRect)frame
{
    frame.size.height -= 1;
    [super setFrame:frame];
}



@end
