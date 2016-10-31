//
//  LCReceiverChatCell.m
//  weChat
//
//  Created by Lc on 16/3/29.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LCReceiverChatCell.h"

@implementation LCReceiverChatCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundMsgView.image = [UIImage imageNamed:@"chatBubble_Receiving_Solid"];
        self.msgLabel.textColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(7);
        make.top.equalTo(self.contentView).offset(7);
        make.width.height.equalTo(@(46));
        
    }];
    
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImageView).offset(-2);
        make.left.equalTo(self.headerImageView.mas_right).offset(15);
    }];
    
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.session.messageType == messageTypeImage || self.session.messageType == messageTypeMap) {
            make.left.equalTo(self.headerImageView.mas_right).offset(4);
        } else {
            make.left.equalTo(self.headerImageView.mas_right).offset(20);
        }
        
        make.top.equalTo(self.nicknameLabel.mas_bottom).offset(13);
    }];
    
    [self.backgroundMsgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.msgLabel).insets(UIEdgeInsetsMake(-8, -15, -8, -10));
    }];
    
    [self.voiceTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backgroundMsgView.mas_right).offset(10);
        make.centerY.equalTo(self.backgroundMsgView);
    }];
    
    [self.redCircleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.voiceTimeLabel.mas_centerX);
        make.top.equalTo(self.backgroundMsgView);
        make.size.equalTo(@(7));
    }];
}

@end
