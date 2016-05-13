//
//  LCBaseChatCell.h
//  weChat
//
//  Created by Lc on 16/3/29.
//  Copyright © 2016年 LC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCSession.h"

@class LCSession, LCBaseChatCell;

@protocol LCBaseChatCellDelegate <NSObject>
@required

- (void)chatCell:(LCBaseChatCell *)chatCell didClickAssetSession:(LCSession *)session;
- (void)chatCell:(LCBaseChatCell *)chatCell didClickRetrySession:(LCSession *)session;
- (void)chatCell:(LCBaseChatCell *)chatCell didClickMapViewSession:(LCSession *)session;
@end

@interface LCBaseChatCell : UITableViewCell

@property (weak, nonatomic) id<LCBaseChatCellDelegate> delegate;

/**
 *  聊天模型
 */
@property (strong, nonatomic) LCSession *session;

/**
 *
 *  @return 每行cell的高度
 */
- (CGFloat)cellHeight;



/* 在sender和receiver中公用的控件 */
/**
 *  消息
 */
@property (weak, nonatomic) UILabel *msgLabel;

/**
 *  消息背景
 */
@property (weak, nonatomic) UIImageView *backgroundMsgView;

/**
 *  头像图标
 */
@property (weak, nonatomic) UIImageView *headerImageView;

/**
 *  讨论组中显示个人的昵称
 */
@property (weak, nonatomic) UILabel *nicknameLabel;

/**
 *  声音时长
 */
@property (weak, nonatomic) UILabel *voiceTimeLabel;

/**
 *  接受者未读语音标示
 */
@property (weak, nonatomic) UIImageView *redCircleView;

/**
 *  菊花
 */
@property (weak, nonatomic) UIActivityIndicatorView *activityIndicatorView;

/**
 *  发送失败图标
 */
@property (weak, nonatomic) UIImageView *failImageView;
@end
