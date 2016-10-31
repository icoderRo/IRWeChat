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

- (instancetype)init
{
    if (self = [super init]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInterruption:) name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
        
           [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRouteChange:) name:AVAudioSessionRouteChangeNotification object:[AVAudioSession sharedInstance]];
    }
    
    return self;
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

- (void)handleInterruption:(NSNotification *)note
{
    NSDictionary *info = note.userInfo;
    AVAudioSessionInterruptionType type = [info[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    if (type == AVAudioSessionInterruptionTypeBegan) {
        [self stopPlaying];
//    } else {
//        AVAudioSessionInterruptionOptions options = [info[AVAudioSessionInterruptionOptionKey] unsignedIntegerValue];
//        
//        if (options == AVAudioSessionInterruptionOptionShouldResume) {
//            // 重新播放
//        }
    }
}

- (void)handleRouteChange:(NSNotification *)note
{
    NSDictionary *info = note.userInfo;
    AVAudioSessionRouteChangeReason reason = [info[AVAudioSessionRouteChangeReasonKey] unsignedIntegerValue];
    
    // 耳机断开的事件为例
    if (reason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        
        AVAudioSessionRouteDescription *previousRoute = info[AVAudioSessionRouteChangePreviousRouteKey];
        
        AVAudioSessionPortDescription *previousOutput = previousRoute.outputs.firstObject;
        NSString *portType = previousOutput.portType;
        if ([portType isEqualToString:AVAudioSessionPortHeadphones]) {
            [self stopPlaying];
        }
    }
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
