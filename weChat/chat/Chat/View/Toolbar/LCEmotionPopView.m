//
//  LCEmotionPopView.m
//  weChat
//
//  Created by Lc on 16/4/27.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LCEmotionPopView.h"
#import "LCEmotion.h"
@interface LCEmotionPopView ()
@property (weak, nonatomic) UIImageView *backgroupView;
@property (weak, nonatomic) UIImageView *emotionPreView;
@end

@implementation LCEmotionPopView

#pragma mark - lazy
- (UIImageView *)backgroupView
{
    if (!_backgroupView) {
        UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"preview_background"]];
        _backgroupView = bgView;
        [self addSubview:_backgroupView];
    }
    
    return _backgroupView;
}

- (UIImageView *)emotionPreView
{
    if (!_emotionPreView) {
        UIImageView *epView = [[UIImageView alloc] init];
        _emotionPreView = epView;
        [self addSubview:epView];
    }
    
    return _emotionPreView;
}

+ (instancetype)popView
{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self backgroupView];
        [self emotionPreView];
    }
    
    return self;
}

- (void)showFrom:(UIButton *)button emotion:(LCEmotion *)emotion
{
    if (button == nil) return;
    
    self.emotionPreView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", emotion.png]];
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:self];
    
    CGRect btnFrame = [button convertRect:button.bounds toView:nil];
    self.y = CGRectGetMidY(btnFrame)- 80;
    self.centerX = CGRectGetMidX(btnFrame) -30;

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.backgroupView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
    }];
    
    [self.emotionPreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.backgroupView);
        make.size.equalTo(@(40));
    }];
}
@end
