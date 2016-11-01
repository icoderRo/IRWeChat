//
//  LCTextView.h
//  weChat
//
//  Created by Lc on 16/3/30.
//  Copyright © 2016年 LC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LCEmotion;
@interface LCTextView : UITextView
/**
 *   生成富文本,用以显示表情
 *
 *  @param emotion 表情模型
 */
- (instancetype)insertEmotion:(LCEmotion *)emotion;
/**
 *   将富文本转换为文本,供以发送给服务器
 *
 */
@property (copy, nonatomic) NSString *fullText;
@end
