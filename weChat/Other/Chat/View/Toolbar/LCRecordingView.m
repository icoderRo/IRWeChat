//
//  LCRecordingView.m
//  weChat
//
//  Created by 聪 on 16/4/11.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LCRecordingView.h"

@interface LCRecordingView ()
@property (assign, nonatomic) CGFloat angle;
@property (weak, nonatomic) UIImageView *bordImageView;
@property (weak, nonatomic) UILabel *centerLabel;
@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UILabel *subTitleLabel;
@property (assign, nonatomic) NSTimeInterval seconds;
@end

@implementation LCRecordingView

static LCRecordingView *recordingView;
static NSTimer *timer;

#pragma mark - lazy
- (UIImageView *)bordImageView
{
    if (!_bordImageView) {
        UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"chat_bar_record_circle"]];
        _bordImageView = imageV;
        [self addSubview:_bordImageView];
    }
    
    return _bordImageView;
}

- (UILabel *)centerLabel
{
    if (!_centerLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"60";
        label.font = [UIFont systemFontOfSize:28];
        label.textColor = [UIColor yellowColor];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        _centerLabel = label;
        [self addSubview:_centerLabel];
    }
    
    return _centerLabel;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"录音倒计时";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:16];
        _titleLabel = label;
        [self addSubview:_titleLabel];
    }
    
    return _titleLabel;
}

- (UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"松开发送语音";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:14];
        _subTitleLabel = label;
        [self addSubview:_subTitleLabel];
    }
    
    return _subTitleLabel;
}

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
        
        [self bordImageView];
        [self centerLabel];
        [self subTitleLabel];
        [self titleLabel];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    }
    
    return self;
}

+ (void)subTitleLabelStatues:(subTitleStatues)statues
{
    [recordingView subTitleLabelStatues:statues];
}

- (void)subTitleLabelStatues:(subTitleStatues)statues
{
    switch (statues) {
        case subTitleStatuesDefault:
            self.subTitleLabel.text = @"松开发送语音";
            break;
        case subTitleStatuesCancel:
            self.subTitleLabel.text = @"松开手指,取消发送语音";
            break;
        default:
            break;
    }
}

- (void)timerAction
{
    self.angle -= 3;
    self.seconds ++ ;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.09];
    UIView.AnimationRepeatAutoreverses = YES;
    self.bordImageView.transform = CGAffineTransformMakeRotation(self.angle * (M_PI / 180.0f));
    float second = [self.centerLabel.text floatValue];
    if (second <= 10.0f) {
        self.centerLabel.textColor = [UIColor redColor];
    }else{
        self.centerLabel.textColor = [UIColor yellowColor];
    }
    self.centerLabel.text = [NSString stringWithFormat:@"%.1fs",second-0.1];
    [UIView commitAnimations];
    if (second <= 0.1) {
        [self.class dismiss];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"recordDUrationToolong" object:nil];
    }
}

+ (void)show
{
    LCRecordingView *rcView = [[LCRecordingView alloc] init];
    UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
    recordingView = rcView;
    [window addSubview:recordingView];
}

+ (void)dismiss
{
    [timer invalidate];
    timer = nil;
    [recordingView removeFromSuperview];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.bordImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [self.centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(150));
        make.height.equalTo(@(40));
        make.center.equalTo(self);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.centerLabel);
        make.height.equalTo(@(20));
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(50);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.subTitleLabel);
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-50);
    }];
}
@end
