//
//  LCTextAttachment.m
//  weChat
//
//  Created by Lc on 16/2/26.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LCTextAttachment.h"
#import "LCEmotion.h"

@implementation LCTextAttachment
- (void)setEmotion:(LCEmotion *)emotion
{
    _emotion = emotion;
    self.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", emotion.png]];
}
@end
