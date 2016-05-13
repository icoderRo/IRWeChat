//
//  LCSettingViewController.m
//  TaiYangHua
//
//  Created by lc on 15/12/21.
//  Copyright © 2015年 hhly. All rights reserved.
//

#import "LCSettingViewController.h"
#import "LCSettingCell.h"
#import "LCSettingItem.h"
#import "LCSettingSwitchItem.h"
#import "LCSettingArrowItem.h"
#import "LCSettingLoginItem.h"
#import "LCSettingConst.h"
#import "LCSettingStatusItem.h"
#import "LCSettingStatusChangeView.h"
#import "LCSettingPasswordChangeView.h"
#import "LCLoginoffView.h"
#import "LCSettingAboutUsViewController.h"
#import "LCSettingAboutUsItem.h"

@interface LCSettingViewController ()<UITableViewDataSource,UITableViewDelegate, UIActionSheetDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *groups;
@end

static NSString *const settingCellId = @"settingCell";

@implementation LCSettingViewController

#pragma mark - lazy
- (NSMutableArray *)groups
{
    if (!_groups) {
        _groups = [NSMutableArray array];
    }
    return _groups;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _tableView = tableView;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = colorf0fGrey;
        _tableView.sectionHeaderHeight = LCSettingCommonGroupMargin;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCSettingCell class]) bundle:nil] forCellReuseIdentifier:settingCellId];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark - init
- (void)viewDidLoad {
    [super viewDidLoad];
    [self tableView];
    [self setupItems];
    self.navigationItem.title = @"设置";
}

- (void)setupItems
{
    [self setUpDetailGroup];
    [self setUpStatusGroup];
    [self setUpLoginTimeGroup];
    [self setUpAboutUsGroup];
    [self setUpLoginOffGroup];
}

- (void)setUpDetailGroup
{
    LCSettingItem *detailItem = [LCSettingItem itemWithHeaderImageName:@"aio_voiceChange_effect_0" title:@"lawCong"];
    NSArray *detailItems = @[detailItem];
    [self.groups addObject:detailItems];
}

- (void)setUpStatusGroup
{
    LCSettingItem *loginStatus = [LCSettingStatusItem itemWithTitle:@"状态"];
    LCSettingSwitchItem *voiceAlert = [LCSettingSwitchItem itemWithTitle:@"声音提醒"];
    voiceAlert.switchType = LCSettingSwitchItemSourceType;
    LCSettingSwitchItem *shakeAlert = [LCSettingSwitchItem itemWithTitle:@"震动提醒"];
    shakeAlert.switchType = LCSettingSwitchItemSharkType;
    
    LCSettingArrowItem *pwdChange = [LCSettingArrowItem itemWithTitle:@"密码修改"];
    pwdChange.operation = ^(){
        [self presentPwdChange];
    };
    
    NSArray *statusItems = @[loginStatus, voiceAlert, shakeAlert, pwdChange];
    [self.groups addObject:statusItems];
}

- (void)setUpLoginTimeGroup
{
    LCSettingLoginItem *curLogin = [LCSettingLoginItem itemWithTitle:@"本次登录"];
    curLogin.machineTypeImageName = curLogin.machineType;
    curLogin.yearMothDay = curLogin.curLoginYearMothDay;
    curLogin.hourMinutes = curLogin.curLoginHourMinutes;
    
    LCSettingLoginItem *lastLogin = [LCSettingLoginItem itemWithTitle:@"上次登录"];
    lastLogin.machineTypeImageName = curLogin.machineType;
    lastLogin.yearMothDay = lastLogin.lastLoginYearMothDay;
    lastLogin.hourMinutes = lastLogin.lastLoginHourMinutes;
    NSArray *loginItems = @[curLogin, lastLogin];
    [self.groups addObject:loginItems];
}

- (void)setUpAboutUsGroup
{
    LCSettingAboutUsItem *aboutUs = [LCSettingAboutUsItem itemWithTitle:@"关于我们"];
    aboutUs.operation = ^ {
        [self pushToAboutUsViewController];
    };
    
    NSArray *aboutUsItems = @[aboutUs];
    [self.groups addObject:aboutUsItems];
}

- (void)setUpLoginOffGroup
{
    LCSettingItem *loginOff = [LCSettingItem itemWithTitle:@"注销登录"];
    loginOff.operational = ^(){
        [self presentLoginoffView];
    };
    
    NSArray *loginOffItems = @[loginOff];
    [self.groups addObject:loginOffItems];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *items = self.groups[section];
    return items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LCSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:settingCellId];
    NSArray *items = self.groups[indexPath.section];
    cell.item = items[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (iPhone6SP) {
        if (indexPath.section == 0) return LCSettingFirstGroupHeight + 10;
        
        return LCSettingCommonGroupHeight + 10;
    } else {
        
        if (indexPath.section == 0) return LCSettingFirstGroupHeight;
        
        return LCSettingCommonGroupHeight;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *items = self.groups[indexPath.section];
    LCSettingItem *item = items[indexPath.row];
    if ([item isKindOfClass:[LCSettingStatusItem class]]) {
        // 修改状态
        [self presentstatusChangeView];
        
    } else if ([item isKindOfClass:[LCSettingArrowItem class]]){
        // 修改密码
        LCSettingArrowItem *arrowItem = (LCSettingArrowItem *)item;
        if (arrowItem.operation) arrowItem.operation();
        
    }else if ([item isKindOfClass:[LCSettingItem class]]){
        // 注销登录
        if (item.operational) item.operational();
        
    } else if ([item isKindOfClass:[LCSettingAboutUsItem class]]) {
        // 关于我们
        if (item.operational) item.operational();
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    // 让tableView顶部无间距
    return 0.1;
}

#pragma mark - presentAlerView
- (void)presentstatusChangeView
{
    LCSettingStatusChangeView *statusChangeView = [LCSettingStatusChangeView viewFromXib];
    statusChangeView.frame = self.tableView.frame;
    [statusChangeView show];
}

- (void)presentPwdChange
{
    LCSettingPasswordChangeView *pwdView = [LCSettingPasswordChangeView viewFromXib];
    pwdView.frame = self.tableView.frame;
    [pwdView show];
}

- (void)presentLoginoffView
{
    LCLoginoffView *loginOffView = [LCLoginoffView viewFromXib];
    loginOffView.frame = self.tableView.frame;
    [loginOffView show];
}

- (void)pushToAboutUsViewController
{
    LCSettingAboutUsViewController *aboutUsVc = [[LCSettingAboutUsViewController alloc] init];
    [self.navigationController pushViewController:aboutUsVc animated:YES];
}


@end
