//
//  LCTextView.m
//  weChat
//
//  Created by Lc on 16/3/30.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LCTextView.h"
#import "LCEmotion.h"
#import "LCTextAttachment.h"
#import "LCSession.h"

@implementation LCTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTap:)]];
    }
    
    return self;
}
- (void)longTap:(UIGestureRecognizer*) recognizer
{
    [self becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder {
    
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    return (action == @selector(copy:) || action == @selector(selectAll:) || action == @selector(cut:) || action == @selector(paste:));
}

- (void)selectAll:(id)sender
{
    [super selectAll:sender];
}

- (void)copy:(id)sender
{
    UIPasteboard *pboard = [UIPasteboard pasteboardWithName:@"myPboard" create:YES];
    
    LCSession *session = [[LCSession alloc] init];
    
    if (self.selectedRange.length > 0) {
        NSAttributedString *atts = [self.attributedText attributedSubstringFromRange:self.selectedRange];
        session.fullText = [self copyText:atts];
    } else {
        session.fullText = self.fullText;
    }
    NSData *sessionData = [NSKeyedArchiver archivedDataWithRootObject:session];
    [pboard setData:sessionData forPasteboardType:@"session"];
    [super copy:sender];
}

- (void)cut:(id)sender
{
    UIPasteboard *pboard = [UIPasteboard pasteboardWithName:@"myPboard" create:YES];
    LCSession *session = [[LCSession alloc] init];
    NSAttributedString *atts = [self.attributedText attributedSubstringFromRange:self.selectedRange];
    session.fullText = [self copyText:atts];
    
    NSData *sessionData = [NSKeyedArchiver archivedDataWithRootObject:session];
    [pboard setData:sessionData forPasteboardType:@"session"];
    
    [super cut:sender];
}

- (void)paste:(id)sender
{
    UIPasteboard *pboard = [UIPasteboard pasteboardWithName:@"myPboard" create:YES];
    
    LCSession *session = [NSKeyedUnarchiver unarchiveObjectWithData:[pboard dataForPasteboardType:@"session"]];
    if (session == nil) return;
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] init];
    [attStr appendAttributedString:self.attributedText];
    NSUInteger loc = self.selectedRange.location;
    self.selectedRange = NSMakeRange(loc, 0);
    [attStr replaceCharactersInRange:self.selectedRange withAttributedString:[session.fullText emotionStringWithWH:24]];
    
    self.attributedText = [attStr copy];
    self.font = [UIFont systemFontOfSize:20];
    //    [super paste:sender];
}

// 生成富文本,用以显示表情
- (instancetype)insertEmotion:(LCEmotion *)emotion
{
    if (emotion.png) {
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] init];
        [attStr appendAttributedString:self.attributedText];
        
        LCTextAttachment *attachment = [[LCTextAttachment alloc] init];
        attachment.bounds = CGRectMake(0, -4, self.font.lineHeight, self.font.lineHeight);
        attachment.emotion = emotion;
        NSAttributedString *imgAtt = [NSAttributedString attributedStringWithAttachment:attachment];
        
        NSUInteger loc = self.selectedRange.location;
        //    [attStr insertAttributedString:imgAtt atIndex:loc];
        [attStr replaceCharactersInRange:self.selectedRange withAttributedString:imgAtt];
        [attStr addAttributes:@{NSFontAttributeName : self.font} range:NSMakeRange(0, attStr.length)];
        self.attributedText = attStr;
        self.selectedRange = NSMakeRange(loc + 1, 0);
    }
    
    return self;
}

- (NSString *)copyText:(NSAttributedString *)atts
{
    NSMutableString *fullText = [NSMutableString string];
    
    [atts enumerateAttributesInRange:NSMakeRange(0, atts.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        
        LCTextAttachment *attch = attrs[@"NSAttachment"];
        if (attch) {
            [fullText appendString:attch.emotion.chs];
        }else {
            NSAttributedString *str = [atts attributedSubstringFromRange:range];
            [fullText appendString:str.string];
        }
    }];
    
    return [fullText copy];
}

// 将富文本转换为文本,供以发送给服务器
- (NSString *)fullText
{
    NSMutableString *fullText = [NSMutableString string];
    
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        
        LCTextAttachment *attch = attrs[@"NSAttachment"];
        if (attch) {
            [fullText appendString:attch.emotion.chs];
        }else {
            NSAttributedString *str = [self.attributedText attributedSubstringFromRange:range];
            [fullText appendString:str.string];
        }
    }];
    
    return [fullText copy];
}

@end
