//
//  LCPlusViewController.m
//  weChat
//
//  Created by Lc on 16/5/4.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LCPlusViewController.h"
#import "LCPlusButton.h"
@interface LCPlusViewController ()
@property (weak, nonatomic) UIImageView *backgroupImageView;
@end

@implementation LCPlusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.userInteractionEnabled = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupBackgroupImageView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setupButtons];
    });
}

- (void)setupBackgroupImageView
{
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shareBottomBackground"]];
    imageV.frame = self.view.bounds;
    self.backgroupImageView = imageV;
    [self.view addSubview:self.backgroupImageView];
}
- (void)setupButtons
{
    NSArray *images = @[@"aio_voiceChange_effect_3", @"aio_voiceChange_effect_1", @"aio_voiceChange_effect_2", @"aio_voiceChange_effect_4", @"aio_voiceChange_effect_5", @"aio_voiceChange_effect_6"];
    NSArray *titles = @[@"demo1", @"demo2", @"demo3", @"demo4", @"demo5", @"demo6"];
    
    NSUInteger count = images.count;
    int maxColsCount = 3;
    NSUInteger rowsCount = (count + maxColsCount - 1) / maxColsCount;
    
    CGFloat buttonW = self.view.width / maxColsCount;
    CGFloat buttonH = buttonW * 0.85;
    CGFloat buttonStartY = (self.view.height - rowsCount * buttonH) * 0.5;
    
    for (int i = 0; i < count; i++) {
        
        LCPlusButton *button = [LCPlusButton buttonWithType:UIButtonTypeCustom];
        button.width = -1;
        
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        CGFloat buttonX = (i % maxColsCount) * buttonW;
        CGFloat buttonY = buttonStartY + (i / maxColsCount) * buttonH;
        
        [UIView animateWithDuration:2.0 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:5.0 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
            
            button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
            
        } completion:^(BOOL finished) {
            self.view.userInteractionEnabled = YES;
        }];
    }
}

#pragma mark - 点击
- (void)buttonClick:(LCPlusButton *)button
{
    LCLog(@"尚未开发");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
