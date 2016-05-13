//
//  LCGroupListViewController.m
//  TaiYangHua
//
//  Created by Lc on 16/1/18.
//  Copyright © 2016年 hhly. All rights reserved.
//

#import "LCGroupListViewController.h"
#import "LCGroupList.h"
#import "LCGroupListCell.h"
#import "LCGroupListViewController.h"
#import "LCChatViewController.h"

@interface LCGroupListViewController ()
@property (strong, nonatomic) NSMutableArray *groupList;
@end

@implementation LCGroupListViewController

static NSString * const internalGroupListCellId = @"internalGroupListCellId";

#pragma mark - lazy
- (NSMutableArray *)groupList
{
    if (!_groupList) {
        _groupList = [NSMutableArray array];
    }
    
    return _groupList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    LCGroupList *list1 = [LCGroupList internalGroupListWithHeadrImage:@"aio_voiceChange_effect_5" name:@"体育彩票" detailSession:nil unreadCount:@"99" time:@"15:35"];
    [self.groupList addObject:list1];
    LCGroupList *list2 = [LCGroupList internalGroupListWithHeadrImage:@"aio_voiceChange_effect_6" name:@"福利彩票" detailSession:@"你知道常用语在哪里快速查找吗" unreadCount:@"99" time:@"15:35"];
    [self.groupList addObject:list2];
    LCGroupList *list3 = [LCGroupList internalGroupListWithHeadrImage:@"aio_voiceChange_effect_3" name:@"售后服务" detailSession:@"你知道常用语在哪里快速查找吗" unreadCount:nil time:@"15:35"];
    [self.groupList addObject:list3];
    LCGroupList *list4 = [LCGroupList internalGroupListWithHeadrImage:@"aio_voiceChange_effect_0" name:@"售前咨询" detailSession:nil unreadCount:nil time:@"15:35"];
    [self.groupList addObject:list4];
    LCGroupList *list5 = [LCGroupList internalGroupListWithHeadrImage:@"aio_voiceChange_effect_5" name:@"体育彩票" detailSession:nil unreadCount:@"99" time:@"15:35"];
    [self.groupList addObject:list5];
    LCGroupList *list6 = [LCGroupList internalGroupListWithHeadrImage:@"aio_voiceChange_effect_6" name:@"福利彩票" detailSession:@"你知道常用语在哪里快速查找吗" unreadCount:@"99" time:@"15:35"];
    [self.groupList addObject:list6];
    LCGroupList *list7 = [LCGroupList internalGroupListWithHeadrImage:@"aio_voiceChange_effect_3" name:@"售后服务" detailSession:@"你知道常用语在哪里快速查找吗" unreadCount:nil time:@"15:35"];
    [self.groupList addObject:list7];
    LCGroupList *list8 = [LCGroupList internalGroupListWithHeadrImage:@"aio_voiceChange_effect_0" name:@"售前咨询" detailSession:nil unreadCount:nil time:@"15:35"];
    [self.groupList addObject:list8];
    
    [self.tableView registerClass:[LCGroupListCell class] forCellReuseIdentifier:internalGroupListCellId];
    if (iPhone6SP) {
        self.tableView.rowHeight = 70;
    } else {
        
        self.tableView.rowHeight = 60;
    }
     self.navigationItem.title = @"讨论组";
    self.tableView.backgroundColor = colorf0fGrey;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 50, 0);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.groupList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LCGroupListCell *cell = [tableView dequeueReusableCellWithIdentifier:internalGroupListCellId];
    cell.internalGroupList = self.groupList[indexPath.row];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LCChatViewController *internalSessionVc = [[LCChatViewController alloc] init];
   
    [self.navigationController pushViewController:internalSessionVc animated:YES];
}

@end
