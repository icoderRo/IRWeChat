//
//  LCChatViewController.h
//  weChat
//
//  Created by Lc on 16/3/29.
//  Copyright © 2016年 LC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCChatViewController : UIViewController
/**
 *  会话标志
 *  1-个聊 2-群聊
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

/**
 *  目标对象名字
 */
@property (copy, nonatomic) NSString *targetName;
@end
