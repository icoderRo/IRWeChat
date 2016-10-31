//
//  LCTabBarController.m
//  weChat
//
//  Created by Lc on 16/5/3.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LCTabBarController.h"
#import "LCTabBar.h"
#import "LCChatViewController.h"
#import "LCNavigationController.h"
#import "LCSettingViewController.h"
#import "LCSessionListViewController.h"
#import "LCGroupListViewController.h"
#import "LCNewsViewController.h"
#import "LCDiscoverViewController.h"

@interface LCTabBarController () <UIGestureRecognizerDelegate>

@end

@implementation LCTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupItem];
    
    [self setupChildVcs];
    
    [self setupTabBar];
    
//    [self setupGestureRecognizer];
}

- (void)setupTabBar
{
    [self setValue:[[LCTabBar alloc] init] forKeyPath:@"tabBar"];
}


- (void)setupChildVcs
{
    [self setupChildVc:[[LCSessionListViewController alloc] init] title:@"会话" image:@"home_normal" selectedImage:@"home_highlight"];
    [self setupChildVc:[[LCGroupListViewController alloc] init] title:@"讨论组" image:@"account_normal" selectedImage:@"account_highlight"];
    [self setupChildVc:[[LCDiscoverViewController alloc] init] title:@"发现" image:@"message_normal" selectedImage:@"message_highlight"];
    [self setupChildVc:[[LCSettingViewController alloc] init] title:@"设置" image:@"mycity_normal" selectedImage:@"mycity_highlight"];
}

- (void)setupChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    LCNavigationController *nav = [[LCNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
    
    nav.tabBarItem.title = title;
    nav.tabBarItem.image = [UIImage imageNamed:image];
    nav.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
}

- (void)setupItem
{
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}

//- (void)setupGestureRecognizer
//{
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
//    pan.delegate = self;
//    [self.view addGestureRecognizer:pan];
//}
//
//- (void)pan:(UIPanGestureRecognizer *)pan{
//    
//    CGPoint transP =  [pan translationInView:self.view];
//    
//    self.view.frame = [self frameWithoffsetX:transP.x];
//    
//    [pan setTranslation:CGPointZero inView:self.view];
//    
//    if(pan.state == UIGestureRecognizerStateEnded){
//        CGFloat target = 0;
//        if (self.view.frame.origin.x > screenW * 0.5) {
//            target = offsetRight;
//        }
//        
//        CGFloat offsetX = target - self.view.frame.origin.x;
//        
//        [UIView animateWithDuration:0.25 animations:^{
//            self.view.frame = [self frameWithoffsetX:offsetX];
//        }];
//    }
//}
//
//- (CGRect)frameWithoffsetX:(CGFloat)offsetX
//{
//    CGRect frame = self.view.frame;
//    frame.origin.x += offsetX;
//    if ( frame.origin.x <=0 ) {
//        frame.origin.x = 0;
//    }
////    CGFloat x = frame.origin.x + offsetX;
////    if (x <= 0) x = 0; // 限制右滑
//    
////    CGFloat y = x / screenW * 100;
////    CGFloat h = screenH - 2 * y;
////    CGFloat w = screenW * h / screenH;
//    
////    return CGRectMake(x, y, w, h);
//    return frame;
//}
//
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    for (LCNavigationController *nav in self.childViewControllers) {
//        if (nav.childViewControllers.count > 1) {
//            return NO;
//        }
//    }
//
//    return YES;
//}
@end
