//
//  LCSessionListViewController.m
//  TaiYangHua
//
//  Created by Lc on 16/1/18.
//  Copyright © 2016年 hhly. All rights reserved.
//

#import "LCSessionListViewController.h"
#import "LCSessionList.h"
#import "LCSessionListCell.h"
#import "LCSessionListViewController.h"
#import "LCChatViewController.h"

@interface LCSessionListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *sessionList;
@property (weak, nonatomic) UITableView *tableView;
@end

@implementation LCSessionListViewController

static NSString * const internalSessionListCellId = @"internalSessionListCellId";

#pragma mark - lazy
- (NSMutableArray *)sessionList
{
    if (!_sessionList) {
        _sessionList = [NSMutableArray array];
    }
    
    return _sessionList;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    LCSessionList *list1 = [LCSessionList internalSessionListWithHeadrImage:@"aio_voiceChange_effect_0" name:@"罗聪" detailSession:@"源码于 https://github.com/icoderRo/LCWeChat" unreadCount:@"99" time:@"15:35"];
    [self.sessionList addObject:list1];
    LCSessionList *list2 = [LCSessionList internalSessionListWithHeadrImage:@"aio_voiceChange_effect_1" name:@"罗聪" detailSession:@"源码于 https://github.com/icoderRo/LCWeChat" unreadCount:@"99" time:@"15:35"];
    [self.sessionList addObject:list2];
    LCSessionList *list3 = [LCSessionList internalSessionListWithHeadrImage:@"aio_voiceChange_effect_2" name:@"罗聪" detailSession:@"源码于 https://github.com/icoderRo/LCWeChat" unreadCount:nil time:@"15:35"];
    [self.sessionList addObject:list3];
    LCSessionList *list4 = [LCSessionList internalSessionListWithHeadrImage:@"aio_voiceChange_effect_3" name:@"罗聪" detailSession:nil  unreadCount:@"99" time:@"15:35"];
    [self.sessionList addObject:list4];
    LCSessionList *list5 = [LCSessionList internalSessionListWithHeadrImage:@"aio_voiceChange_effect_0" name:@"罗聪" detailSession:@"源码于 https://github.com/icoderRo/LCWeChat" unreadCount:@"99" time:@"15:35"];
    [self.sessionList addObject:list5];
    LCSessionList *list6 = [LCSessionList internalSessionListWithHeadrImage:@"aio_voiceChange_effect_1" name:@"罗聪" detailSession:@"源码于 https://github.com/icoderRo/LCWeChat" unreadCount:@"99" time:@"15:35"];
    [self.sessionList addObject:list6];
    LCSessionList *list7 = [LCSessionList internalSessionListWithHeadrImage:@"aio_voiceChange_effect_2" name:@"罗聪" detailSession:@"源码于 https://github.com/icoderRo/LCWeChat" unreadCount:nil time:@"15:35"];
    [self.sessionList addObject:list7];
    LCSessionList *list8 = [LCSessionList internalSessionListWithHeadrImage:@"aio_voiceChange_effect_3" name:@"罗聪" detailSession:nil  unreadCount:@"99" time:@"15:35"];
    [self.sessionList addObject:list8];
    
    [self setupTableView];
    [self setupNav];
}


- (void)setupTableView
{
    UITableView *tableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[LCSessionListCell class] forCellReuseIdentifier:internalSessionListCellId];
    self.tableView.rowHeight = 60;
    if (iPhone6SP) self.tableView.rowHeight = 70;
    
    self.tableView.backgroundColor = colorf0fGrey;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 50, 0);

}

- (void)setupNav
{
    self.navigationItem.title = @"会话";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"pin_green"] style:UIBarButtonItemStyleDone target:self action:@selector(clickHomeButton)];
}


- (void)clickHomeButton
{
    if (self.tabBarController.view.x == 0) {
        [UIView animateWithDuration:0.25 animations:^{
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            CGRect frame = self.tabBarController.view.frame;
            frame.origin.x = offsetMainRight;
            self.tabBarController.view.frame = frame;
            frame.origin.x = 0;
            [self.tabBarController.view.superview.subviews[0] setFrame:frame];
        }];
    } 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sessionList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LCSessionListCell *cell = [tableView dequeueReusableCellWithIdentifier:internalSessionListCellId];
    cell.internalSessionList = self.sessionList[indexPath.row];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LCChatViewController *internalSessionVc = [[LCChatViewController alloc] init];
    
    [self.navigationController pushViewController:internalSessionVc animated:YES];
    
}

@end
