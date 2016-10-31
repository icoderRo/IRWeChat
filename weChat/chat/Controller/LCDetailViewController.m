//
//  LCDetailViewController.m
//  weChat
//
//  Created by Lc on 16/5/13.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LCDetailViewController.h"

@interface LCDetailViewController () <UITabBarDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *array;
@end

@implementation LCDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.array = @[@"开通会员", @"QQ钱包", @"个性装扮", @"我的收藏", @"我的相册", @"我的文件", @"我的名片夹"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCellId"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellId"];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = self.array[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", self.array[indexPath.row]]];
    return cell;
}
@end
