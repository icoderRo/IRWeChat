//
//  LCTextAttachment.h
//  weChat
//
//  Created by Lc on 16/2/26.
//  Copyright © 2016年 LC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LCEmotion;
@interface LCTextAttachment : NSTextAttachment
@property (nonatomic, strong) LCEmotion *emotion;
@end
