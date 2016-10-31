//
//  LCBannerCell.m
//  weChat
//
//  Created by Lc on 16/3/29.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LCBannerCell.h"

@interface LCBannerCell ()
@property (weak, nonatomic) UILabel *timeLabel;

@property (weak, nonatomic) UILabel *alertLabel;
@end

@implementation LCBannerCell
- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        UILabel *tm = [[UILabel alloc] init];
        tm.font = [UIFont systemFontOfSize:12];
        tm.textColor = [UIColor lightGrayColor];
        tm.textAlignment = NSTextAlignmentCenter;
        _timeLabel = tm;
        [self.contentView addSubview:_timeLabel];
    }
    
    return _timeLabel;
}

- (UILabel *)alertLabel
{
    if (!_alertLabel) {
        UILabel *alert = [[UILabel alloc] init];
        alert.font = [UIFont systemFontOfSize:15];
        alert.textColor = [UIColor whiteColor];
        alert.textAlignment = NSTextAlignmentCenter;
        alert.layer.cornerRadius = 5;
        alert.backgroundColor = [UIColor blackColor];
        _alertLabel = alert;
        
        [self.contentView addSubview:_alertLabel];
    }
    
    return _alertLabel;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = colorf0fGrey;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}


- (void)setTime:(NSString *)time
{
    _time = time;
    self.timeLabel.text = time;
}

- (void)setAlert:(NSString *)alert
{
    _alert = alert;
    self.alertLabel.text = alert;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@(18));
    }];
    
    [_alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@(18));
    }];
}

@end
