//
//  LCBaseViewController.m
//  weChat
//
//  Created by Lc on 16/5/12.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LCBaseViewController.h"
#import "LCTabBarController.h"
#import "LCDetailViewController.h"
#import "LCNavigationController.h"

@interface LCBaseViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, weak) UIView *tabBarView;
@property (nonatomic, weak) UIView *detailView;
@property (nonatomic, weak) UIView *coverView;
@end

@implementation LCBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupChildrenViewControllers];
    [self setupGestureRecognizer];
}

- (void)setupChildrenViewControllers
{
    LCDetailViewController *detailVc = [[LCDetailViewController alloc] init];
    [self addChildViewController:detailVc];
    detailVc.view.frame = CGRectMake(-offsetDetailRight, self.view.y, self.view.width, self.view.height);
    [self.view addSubview:detailVc.view];
    self.detailView = detailVc.view;

    LCTabBarController *tabVc = [[LCTabBarController alloc] init];
    [self addChildViewController:tabVc];
    tabVc.view.frame = self.view.bounds;
    [self.view addSubview:tabVc.view];
    self.tabBarView = tabVc.view;
    [self.tabBarView addObserver:self forKeyPath:@"frame" options:kNilOptions context:nil];

    UIView *coverView = [[UIView alloc] init];
    coverView.frame = self.tabBarView.frame;
    coverView.hidden = YES;
    [self.tabBarView addSubview:coverView];
    self.coverView = coverView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.coverView addGestureRecognizer:tap];
}

- (void)tap
{
    if (self.tabBarView.x != 0) {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.tabBarView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
            self.detailView.frame = CGRectMake(-offsetDetailRight, self.view.y, self.view.width, self.view.height);
        }];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (self.tabBarView.x == offsetMainRight) {
        self.coverView.hidden = NO;
    } else {
        self.coverView.hidden = YES;
    }
}

- (void)setupGestureRecognizer
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    pan.delegate = self;
    [self.tabBarView addGestureRecognizer:pan];
}

- (void)pan:(UIPanGestureRecognizer *)pan{
    
    CGPoint transP =  [pan translationInView:self.tabBarView];
    
    self.tabBarView.frame = [self tabFrameWithoffsetX:transP.x];
    [pan setTranslation:CGPointZero inView:self.tabBarView];

    self.detailView.frame = [self detailFrameWithoffsetX:transP.x];
    [pan setTranslation:CGPointZero inView:self.detailView];
    
    if(pan.state == UIGestureRecognizerStateEnded){
        CGFloat targetMain = 0;
        CGFloat targetDetail = offsetDetailRight;
        if (self.tabBarView.frame.origin.x > screenW * 0.5) {
            targetMain = offsetMainRight;
            targetDetail = 0;
        }
        
        CGFloat offsetMainX = targetMain - self.tabBarView.frame.origin.x;
        CGFloat offsetDetailX = - targetDetail;
        
        [UIView animateWithDuration:0.25 animations:^{
            self.tabBarView.frame = [self tabFrameWithoffsetX:offsetMainX];
            self.detailView.frame = CGRectMake(offsetDetailX, 0, self.view.width, self.view.height);
        }];
    }
}

- (CGRect)tabFrameWithoffsetX:(CGFloat)offsetX
{
    CGRect frame = self.tabBarView.frame;
    frame.origin.x += offsetX;
    if ( frame.origin.x <= 0 )  frame.origin.x = 0;
    
    return frame;
}

- (CGRect)detailFrameWithoffsetX:(CGFloat)offsetX
{
    CGRect frame = self.detailView.frame;
    frame.origin.x += (offsetX * offsetDetailRight / offsetMainRight);
    if ( frame.origin.x >= 0 )  frame.origin.x = 0;
    return frame;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    LCTabBarController *tabVc = self.childViewControllers[1];
    for (LCNavigationController *nav in tabVc.childViewControllers) {
        if (nav.childViewControllers.count > 1) {
            return NO;
        }
    }
    
    return YES;
}
@end
