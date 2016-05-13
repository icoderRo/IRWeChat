//
//  LCDiscoverViewController.m
//  weChat
//
//  Created by 聪 on 16/5/11.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LCDiscoverViewController.h"
#import "LCNewsViewController.h"
@interface LCDiscoverViewController ()

@end

@implementation LCDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发现";
}

- (instancetype)init
{
    
    return [[UIStoryboard storyboardWithName:NSStringFromClass([LCDiscoverViewController class]) bundle:nil] instantiateInitialViewController];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        LCNewsViewController *newsVc = [[LCNewsViewController alloc] init];
        [self.navigationController pushViewController:newsVc animated:YES];
    }
}


@end
