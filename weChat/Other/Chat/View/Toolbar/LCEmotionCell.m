//
//  LCEmotionCell.m
//  weChat
//
//  Created by Lc on 16/3/29.
//  Copyright © 2016年 LC. All rights reserved.
//

#define column 9
#define row 3

#import "LCEmotionCell.h"
#import "LCEmotion.h"
#import "LCEmotionPopView.h"
@interface LCEmotionCell ()
@property (strong, nonatomic) LCEmotionPopView *popView;

@end
@implementation LCEmotionCell

- (LCEmotionPopView *)popView
{
    if (!_popView) {
        self.popView = [LCEmotionPopView popView];
    }
    return _popView;
}


- (void)setEmotions:(NSArray *)emotions
{
    if (self.contentView.subviews.count > 0) {
        for (UIButton *btn in self.contentView.subviews) {
            [btn removeFromSuperview];
        }
    }
    
    _emotions = emotions;
    
    CGFloat width = 30;
    CGFloat height = width;
    
    CGFloat columnMargin = (self.contentView.width - width * column) / (column + 1);
    CGFloat rowMargin = (self.contentView.height - height * row) / (row + 1);
    
    for (int i = 0; i < self.emotions.count + 1; i++) {
        UIButton *button = [[UIButton alloc] init];
        
        CGFloat x = i % column * (width + columnMargin) + columnMargin;
        CGFloat y = i / column * (height + rowMargin) + rowMargin;
        button.frame = CGRectMake(x, y, width, height);
        
        if (i == self.emotions.count) {
            
            [button addTarget:self action:@selector(clickDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
            [button setBackgroundImage:[UIImage imageNamed:@"DeleteEmoticonBtn_ios7"] forState:UIControlStateNormal];
            [self.contentView addSubview:button];
            
            return;
        }
        
        LCEmotion *emotion = self.emotions[i];
        
        [button addTarget:self action:@selector(clickEmotion:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", emotion.png]] forState:UIControlStateNormal];
        button.tag = i;
        [self.contentView addSubview:button];
        
        [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressPageView:)]];
    }
}

- (void)clickEmotion:(UIButton *)button
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    LCEmotion *emotion = self.emotions[button.tag];
    dict[@"emotion"] = emotion;
    
   [self.popView showFrom:button emotion:emotion];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.popView removeFromSuperview];
    });
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userClickEmotion" object:nil userInfo:dict];
    
    
}

- (void)clickDeleteButton:(UIButton *)button
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didDeleteEmotion" object:nil];
}

- (UIButton *)emotionButtonWithLocation:(CGPoint)location
{
    NSUInteger count = self.emotions.count;
    for (int i = 0; i<count; i++) {
        UIButton *btn = self.contentView.subviews[i];
        if (CGRectContainsPoint(btn.frame, location)) {
            return btn;
        }
    }
    return nil;
}

- (void)longPressPageView:(UILongPressGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:recognizer.view];
    
    UIButton *btn = [self emotionButtonWithLocation:location];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    LCEmotion *emotion = self.emotions[btn.tag];
    dict[@"emotion"] = emotion;

    switch (recognizer.state) {
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
            
            [self.popView removeFromSuperview];
            
            if (btn) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"userClickEmotion" object:nil userInfo:dict];
            }
            break;
            
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged: { 
            [self.popView showFrom:btn emotion:emotion];
            break;
        }
            
        default:
            break;
    }
}
@end
