//
//  LCAudioPlayTool.m
//  LC
//
//  Created by Lc on 16/3/3.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LCAudioPlayTool.h"
#import "LCSession.h"
#import "LCAudioManager.h"

static UIImageView *animatingImageView;
static LCSession *lastSession;
@implementation LCAudioPlayTool

+ (void)playWithMessage:(LCSession *)internalSession msgLabel:(UILabel *)msgLabel receiver:(BOOL)receiver{
    
    // 停止当前播放中的语音
    if ([[LCAudioManager manager] isPlaying] && internalSession == lastSession) {
        [self stop];
        return;
    }
    // 移除之前播放的动画
    [animatingImageView stopAnimating];
    [animatingImageView removeFromSuperview];
    
    NSString *path = internalSession.recordPath;
    LCLog(@"%@", path);
    lastSession = internalSession;

    [[LCAudioManager manager] playingWithRecordPath:path completion:^(NSError *error) {
        [animatingImageView stopAnimating];
        [animatingImageView removeFromSuperview];
        internalSession.voicePlaying = NO;
    }];
    
    // 播放动画
    UIImageView *imgView = [[UIImageView alloc] init];
    [msgLabel addSubview:imgView];
    
    if (receiver) {
        imgView.animationImages = @[[UIImage imageNamed:@"ReceiverVoiceNodePlaying000_ios7"],
                                    [UIImage imageNamed:@"ReceiverVoiceNodePlaying001_ios7"],
                                    [UIImage imageNamed:@"ReceiverVoiceNodePlaying002_ios7"],
                                    [UIImage imageNamed:@"ReceiverVoiceNodePlaying003_ios7"]];
        imgView.frame = CGRectMake(0, 0, 25, 25);
    }else{
        imgView.animationImages = @[[UIImage imageNamed:@"SenderVoiceNodePlaying000_ios7"],
                                    [UIImage imageNamed:@"SenderVoiceNodePlaying001_ios7"],
                                    [UIImage imageNamed:@"SenderVoiceNodePlaying002_ios7"],
                                    [UIImage imageNamed:@"SenderVoiceNodePlaying003_ios7"]];
        
        imgView.frame = CGRectMake(msgLabel.bounds.size.width - 25, 0, 25, 25);
    }
    
    imgView.animationDuration = 1;
    [imgView startAnimating];
    animatingImageView = imgView;
    internalSession.voicePlaying = YES;
}

+ (void)stop
{
    [[LCAudioManager manager] stopPlaying];
    [animatingImageView stopAnimating];
    [animatingImageView removeFromSuperview];
    lastSession.voicePlaying = NO;
}

+ (void)playingImageView
{
    [animatingImageView startAnimating];
}

+ (void)stopPlayingImageView
{
    [animatingImageView stopAnimating];
}
@end
