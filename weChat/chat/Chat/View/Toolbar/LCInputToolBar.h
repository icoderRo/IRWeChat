//
//  LCInputToolBar.h
//  weChat
//
//  Created by Lc on 16/3/29.
//  Copyright © 2016年 LC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCInputToolBar, LCSession;

@protocol LCInputToolBarDelegate <NSObject>

@required
- (void)inputToolBar:(LCInputToolBar *)inputToolBar didSendTextSession:(LCSession *)textSession isNeedToAdd:(BOOL)add;

- (void)inputToolBar:(LCInputToolBar *)inputToolBar didSendVoiceSession:(LCSession *)voiceSession isNeedToAdd:(BOOL)add;

- (void)inputToolBar:(LCInputToolBar *)inputToolBar didSendImageSession:(LCSession *)imageSession isNeedToAdd:(BOOL)add;

- (void)inputToolBar:(LCInputToolBar *)inputToolBar didSendMapSession:(LCSession *)mapSession isNeedToAdd:(BOOL)add;
@end

@interface LCInputToolBar : UIView
+ (instancetype)inputToolBar;
@property (assign, nonatomic) BOOL switchingKeybaord;


/**
 *  会话标志
 */
@property (assign, nonatomic) NSInteger targetType;

/**
 *  会话ID
 */
@property (copy, nonatomic) NSString *sessionId;

/**
 *  目标对象ID
 */
@property (copy, nonatomic) NSString *targetId;


@property (copy, nonatomic) void (^inputBarHeight)(CGFloat height);

@property (weak, nonatomic) id<LCInputToolBarDelegate> delegate;

@end
