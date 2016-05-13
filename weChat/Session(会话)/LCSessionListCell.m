//
//  LCSessionListCell.m
//  TaiYangHua
//
//  Created by Lc on 16/1/18.
//  Copyright © 2016年 hhly. All rights reserved.
//

#import "LCSessionListCell.h"
#import "LCSessionList.h"

@interface LCSessionListCell ()

@property (weak, nonatomic) UIImageView *headerImageView;
@property (weak, nonatomic) UILabel *nameLabel;
@property (weak, nonatomic) UILabel *detailSession;
@property (weak, nonatomic) UIButton *unreadCountBtn;
@property (weak, nonatomic) UILabel *timeLabel;

@end

@implementation LCSessionListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - lazy
- (UIImageView *)headerImageView
{
    if (!_headerImageView) {
        UIImageView *imageV = [[UIImageView alloc] init];
        [self.contentView addSubview:imageV];
        _headerImageView = imageV;
    }
    
    return _headerImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        UILabel *nameL = [[UILabel alloc] init];
        nameL.font = [UIFont systemFontOfSize:15];
        nameL.textColor = LCColor(100, 100, 100);
        [self.contentView addSubview:nameL];
        _nameLabel = nameL;
    }
    
    return _nameLabel;
}

- (UILabel *)detailSession
{
    if (!_detailSession) {
        UILabel *detailL = [[UILabel alloc] init];
        detailL.font = [UIFont systemFontOfSize:12];
        detailL.textColor = LCColor(150, 150, 150);
        [self.contentView addSubview:detailL];
        _detailSession = detailL;
    }
    
    return _detailSession;
}


- (UIButton *)unreadCountBtn
{
    if (!_unreadCountBtn) {
        UIButton *btn = [[UIButton alloc] init];
        btn.backgroundColor = [UIColor redColor];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        btn.enabled = NO;
        [self.contentView addSubview:btn];
        _unreadCountBtn = btn;
        self.unreadCountBtn.layer.cornerRadius = 10;
        self.unreadCountBtn.layer.masksToBounds = YES;
    }
    
    return _unreadCountBtn;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        UILabel *timeL = [[UILabel alloc] init];
        timeL.font = [UIFont systemFontOfSize:10];
        timeL.textColor = LCColor(200, 200, 200);
        [self.contentView addSubview:timeL];
        _timeLabel = timeL;
    }
    
    return _timeLabel;
}

- (void)setInternalSessionList:(LCSessionList *)internalSessionList
{
    _internalSessionList = internalSessionList;
    
    if (internalSessionList.unReadSize) {
        self.unreadCountBtn.hidden = NO;
        [self.unreadCountBtn setTitle:internalSessionList.unReadSize forState:UIControlStateNormal];
    } else {
        self.unreadCountBtn.hidden = YES;
    }
    
    if (internalSessionList.lastMessage) {
        self.detailSession.hidden = NO;
        self.detailSession.text = internalSessionList.lastMessage;
    } else {
        self.detailSession.hidden = YES;
    }
    
    self.headerImageView.image = [UIImage imageNamed:internalSessionList.headUrl];
    self.nameLabel.text = internalSessionList.targetName;
    self.timeLabel.text = internalSessionList.lastMessageTime;
    
    
    
}

#pragma mark -  layoutSubviews
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(7);
        make.bottom.equalTo(self.contentView).offset(-7);
        if (iPhone6SP) {
             make.width.height.equalTo(@(56));
        } else {
            make.width.height.equalTo(@(46));
        }
    }];
    
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.mas_right).offset(12);
        if (!self.internalSessionList.lastMessage) {
             make.centerY.equalTo(self.contentView);
        } else {
            make.top.equalTo(self.contentView).offset(12);
        }
    }];

    
    [self.detailSession mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-12);
        make.left.equalTo(self.nameLabel);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(12);
        make.right.equalTo(self.contentView).offset(-12);
    }];
    
    [self.unreadCountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-11);
        make.right.equalTo(self.timeLabel);
        make.width.height.equalTo(@(20));
    }];
}

- (void)setFrame:(CGRect)frame
{
    frame.size.height -= 1;
    [super setFrame:frame];
}

@end
