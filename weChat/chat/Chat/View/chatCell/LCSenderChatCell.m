//
//  LCSenderChatCell.m
//  weChat
//
//  Created by Lc on 16/3/29.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LCSenderChatCell.h"

@implementation LCSenderChatCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundMsgView.image = [UIImage imageNamed:@"chatBubble_Sending_Solid"];
        self.msgLabel.textColor = [UIColor darkGrayColor];
        
        [self layout];
    }
    
    return self;
}

- (void)layout
{
    // 有些布局参数可能不是很准, 这变只是为了演示一下
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-7);
        make.top.equalTo(self.contentView).offset(7);
        make.width.height.equalTo(@(46));
    }];
    
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImageView).offset(-2);
        make.right.equalTo(self.headerImageView.mas_left).offset(-15);
    }];
    
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headerImageView.mas_left).offset(-18);
        make.top.equalTo(self.nicknameLabel.mas_bottom).offset(9);
        
    }];
    
    [self.backgroundMsgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.msgLabel).insets(UIEdgeInsetsMake(-7, -12, -6, -15));
        
    }];
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.msgLabel).insets(UIEdgeInsetsMake(-5, -3, -1, -8));
        
    }];
    
    [self.backgroundVoiceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.msgLabel).insets(UIEdgeInsetsMake(-7, -12, -6, -15));
    }];
    
    [self.voiceTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backgroundMsgView.mas_left).offset(-10);
        make.centerY.equalTo(self.backgroundMsgView);
    }];
    
    [self.voiceTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backgroundMsgView.mas_left).offset(-10);
        make.centerY.equalTo(self.backgroundMsgView);
    }];
    
    [self.activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.voiceTimeLabel.mas_left).offset(-10);
        make.centerY.equalTo(self.backgroundMsgView);
    }];
    
    [self.failImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.voiceTimeLabel.mas_left).offset(-10);
        make.centerY.equalTo(self.backgroundMsgView);
        make.size.equalTo(@(15));
    }];

}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.contentView).offset(-7);
//        make.top.equalTo(self.contentView).offset(7);
//        make.width.height.equalTo(@(46));
//    }];
//    
//    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.headerImageView).offset(-2);
//        make.right.equalTo(self.headerImageView.mas_left).offset(-15);
//    }];
//    
//    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//        if (self.session.messageType == messageTypeImage || self.session.messageType == messageTypeMap) {
//            make.right.equalTo(self.headerImageView.mas_left).offset(-4);
//        } else {
//            make.right.equalTo(self.headerImageView.mas_left).offset(-20);
//        }
//        
//        make.top.equalTo(self.nicknameLabel.mas_bottom).offset(13);
//    }];
//    
//    [self.backgroundMsgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.edges.equalTo(self.msgLabel).insets(UIEdgeInsetsMake(-8, -10, -10, -15));
//        
//    }];
//    
//    [self.voiceTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.backgroundMsgView.mas_left).offset(-10);
//        make.centerY.equalTo(self.backgroundMsgView);
//    }];
//    
//    [self.activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.voiceTimeLabel.mas_left).offset(-10);
//        make.centerY.equalTo(self.backgroundMsgView);
//    }];
//    
//    [self.failImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.voiceTimeLabel.mas_left).offset(-10);
//        make.centerY.equalTo(self.backgroundMsgView);
//        make.size.equalTo(@(15));
//    }];
//}

@end
