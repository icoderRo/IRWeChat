//
//  LCTabBar.m
//  weChat
//
//  Created by Lc on 16/5/3.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LCTabBar.h"
#import "LCPlusViewController.h"
@interface LCTabBar ()
@property (nonatomic, weak) UIButton *plusButton;
@end

@implementation LCTabBar
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
    
        self.backgroundImage = [UIImage imageNamed:@"tabbar-light"];
        
        UIButton *plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [plusButton setBackgroundImage:[UIImage imageNamed:@"post_normal"] forState:UIControlStateNormal];
        [plusButton setBackgroundImage:[UIImage imageNamed:@"post_normal"] forState:UIControlStateHighlighted];
        [plusButton sizeToFit];
        [plusButton addTarget:self action:@selector(plusButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:plusButton];
        self.plusButton = plusButton;
    }
    return self;
}

- (void)plusButtonClick
{
    LCPlusViewController *chatVc = [[LCPlusViewController alloc] init];
    [self.window.rootViewController presentViewController:chatVc animated:YES completion:nil];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = self.width;
    CGFloat height = self.height;
    
    self.plusButton.center = CGPointMake(width * 0.5, height * 0.5);
    self.plusButton.y = -20;
    
    int index = 0;
    
    CGFloat tabBarButtonW = width / 5;
    CGFloat tabBarButtonH = height;
    CGFloat tabBarButtonY = 0;

    for (UIView *tabBarButton in self.subviews) {
        if (![NSStringFromClass(tabBarButton.class) isEqualToString:@"UITabBarButton"]) continue;
        
        
        CGFloat tabBarButtonX = index * tabBarButtonW;
        if (index >= 2) {
            tabBarButtonX += tabBarButtonW;
        }
        
        
        tabBarButton.frame = CGRectMake(tabBarButtonX, tabBarButtonY, tabBarButtonW, tabBarButtonH);
        
        index++;
    }
    
    [self bringSubviewToFront:self.plusButton];
}

@end
