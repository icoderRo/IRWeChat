//
//  LCDetailViewController.m
//  weChat
//
//  Created by Lc on 16/5/12.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LCDetailViewController.h"

@interface LCDetailViewController ()

@end

@implementation LCDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (instancetype)init
{
    return [[UIStoryboard storyboardWithName:NSStringFromClass([LCDetailViewController class]) bundle:nil] instantiateInitialViewController];
}



@end
