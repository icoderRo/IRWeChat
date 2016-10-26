//
//  LCMetersRecordingView.m
//  Antenna
//
//  Created by Lc on 16/4/8.
//  Copyright © 2016年 HHLY. All rights reserved.
//

#import "LCMetersRecordingView.h"
#import "LCAudioRecord.h"

@interface LCMetersRecordingView ()

@property (weak, nonatomic) UIImageView *bordImageView;
@property (weak, nonatomic) UILabel *subTitleLabel;
@property (assign, nonatomic) NSTimeInterval seconds;
@property (assign, nonatomic) NSInteger status;
@end

@implementation LCMetersRecordingView

static LCMetersRecordingView *recordingView;
static NSTimer *timer;

#pragma mark - lazy
- (UIImageView *)bordImageView
{
    if (!_bordImageView) {
        UIImageView *imageV = [[UIImageView alloc]init];
        imageV.alpha = 0.6;
        _bordImageView = imageV;
        [self addSubview:_bordImageView];
    }
    
    return _bordImageView;
}

- (UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor whiteColor];
        label.text = @"手指上滑, 取消发送";
        label.font = [UIFont systemFontOfSize:12];
        label.layer.cornerRadius = 10;
        label.layer.masksToBounds = YES;
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
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.01];
        
        [self bordImageView];
        [self subTitleLabel];
        
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
    self.status = statues;
    switch (statues) {
        case subTitleStatuesDefault:
            self.subTitleLabel.text = @"  手指上滑, 取消发送  ";
            self.subTitleLabel.backgroundColor = [UIColor clearColor];
            break;
        case subTitleStatuesCancel:
            self.subTitleLabel.text = @"  松开手指, 取消发送  ";
            self.bordImageView.image = [UIImage imageNamed:@"取消语音"];
            self.subTitleLabel.backgroundColor = [UIColor yellowColor];
            break;
        default:
            break;
    }
}

- (void)timerAction
{
    if (self.status == subTitleStatuesDefault) {
        
        if ([LCAudioRecord recorder]) [[LCAudioRecord recorder] updateMeters];

        float peakPower = [[LCAudioRecord recorder] averagePowerForChannel:0];
        double ALPHA = 0.05;
        double value = pow(10, (ALPHA * peakPower));
        if (value < 0.1 ) {
            self.bordImageView.image = [UIImage imageNamed:@"语音中-1"];
        } else if (value < 0.15) {
            self.bordImageView.image = [UIImage imageNamed:@"语音中-2"];
        } else if (value < 0.25) {
            self.bordImageView.image = [UIImage imageNamed:@"语音中-3"];
        } else if (value < 0.35) {
            self.bordImageView.image = [UIImage imageNamed:@"语音中-4"];
        } else if (value < 0.9 ) {
            self.bordImageView.image = [UIImage imageNamed:@"语音中-5"];
        }
    }
    
    self.seconds ++;
    if (self.seconds >= 599.9) {
        [self.class dismiss];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"recordDUrationToolong" object:nil];
        
    }
}

+ (void)show
{
    LCMetersRecordingView *rcView = [[LCMetersRecordingView alloc] init];
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
        make.width.height.equalTo(@(200));
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(20));
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(70);
    }];
    
 
}

@end
