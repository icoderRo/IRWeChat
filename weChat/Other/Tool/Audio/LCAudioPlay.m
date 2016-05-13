//
//  LCAudioPlay.m
//  LCAudioManager
//
//  Created by Lc on 16/3/31.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LCAudioPlay.h"
#import <AVFoundation/AVFoundation.h>

#define audioFileNotFound -106
#define audioPlayerInitFilure -107

@interface LCAudioPlay ()<AVAudioPlayerDelegate>

@property (strong, nonatomic) AVAudioPlayer *player;
@property (copy, nonatomic) void(^completion)(NSError *);

@end

@implementation LCAudioPlay
+ (instancetype)sharedInstance
{
    static LCAudioPlay *player = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [[self alloc] init];
    });
    
    return player;
}

- (void)playingWithPath:(NSString *)recordPath completion:(void (^)(NSError *))completion
{
    self.completion = completion;
    
    NSError *error = nil;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:recordPath]) {
        error = [NSError errorWithDomain:NSLocalizedString(@"LCAudio.fileNotFound", @"未找到文件") code:audioFileNotFound userInfo:nil];
        
        if (self.completion) self.completion(error);
        
        self.completion = nil;
        
        return;
    }
    
    NSURL *mp3URL = [NSURL fileURLWithPath:recordPath];
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:mp3URL error:&error];
    
    if (!self.player || error) {
        error = [NSError errorWithDomain:NSLocalizedString(@"LCAudio.audioPlayerInitFilure", @"初始化播放器失败") code:audioPlayerInitFilure userInfo:nil];
        
        self.player = nil;
        
        if (self.completion) self.completion(error);
        
        self.completion = nil;
        
        return;
    }
    
    self.player.delegate = self;
    [self.player prepareToPlay];
    [self.player play];
    
}

- (BOOL)isPlaying
{
    return !!self.player;
}

- (void)stopPlaying
{
    if (self.player) {
        self.player.delegate = nil;
        [self.player stop];
        self.player = nil;
    }
    
    if (self.completion) self.completion = nil;
}

- (void)dealloc
{
    [self stopPlaying];
}
#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (self.completion) self.completion(nil);
    [self stopPlaying];
}

@end
