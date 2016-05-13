//
//  LCAudioRecord.m
//  LCAudioManager
//
//  Created by Lc on 16/3/31.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LCAudioRecord.h"
#import <AVFoundation/AVFoundation.h>

#define recorderInitFailure -105

@interface LCAudioRecord ()<AVAudioRecorderDelegate>

@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) NSDictionary *recordSetting;
@property (copy, nonatomic) void(^completion)(NSString *recordPath);

@end

@implementation LCAudioRecord

+ (instancetype)sharedInstance
{
    static LCAudioRecord *audioRecord = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        audioRecord = [[self alloc] init];
    });
    
    return audioRecord;
}   

- (NSDictionary *)recordSetting
{
    if (!_recordSetting) { // 转换为的MP3格式
        _recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                          [NSNumber numberWithFloat: 11025.0],AVSampleRateKey, //采样率 44100.0
                          [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                          [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,//采样位数 默认 16
                          [NSNumber numberWithInt: 2], AVNumberOfChannelsKey,//通道的数目
                          [NSNumber numberWithInt:AVAudioQualityMax], AVEncoderAudioQualityKey, // 录音质量
                          nil];
    }
    
    return _recordSetting;
}

- (void)startRecordingWithRecordPath:(NSString *)recordPath completion:(void (^)(NSError *))completion
{
    NSError *error = nil;
    NSURL *wavURL = [NSURL fileURLWithPath:[[recordPath stringByDeletingPathExtension] stringByAppendingPathExtension:@"wav"]];
    self.recorder = [[AVAudioRecorder alloc] initWithURL:wavURL settings:self.recordSetting error:&error];
    if (!self.recorder || error) {
        if (completion) {
            error = [NSError errorWithDomain:NSLocalizedString(@"LCAudio.recorderInitFailure", @"初始化失败") code:recorderInitFailure userInfo:nil];
            completion(error);
        }
        self.recorder = nil;
        return;
    }
    
    self.recorder.meteringEnabled = YES;
    self.recorder.delegate = self;
    [self.recorder record];
    
    if (completion) completion(error);
    
}

- (void)stopRecordingWithCompletion:(void(^)(NSString *recordPath))completion
{
    self.completion = completion;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.recorder stop];
    });
}

- (BOOL)isRecording
{
    return !!self.recorder;
}

- (void)cancelRecording
{
    self.recorder.delegate = nil;
    if (self.recorder) [self.recorder stop];
    self.recorder = nil;
    
}

- (void)dealloc
{
    if (self.recorder) {
        self.recorder.delegate = nil;
        [self.recorder stop];
        [self.recorder deleteRecording];
        self.recorder = nil;
    }
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    NSString *recordPath = [[_recorder url] path];
    if (self.completion) {
        if (!flag) recordPath = nil;
        self.completion(recordPath);
    }
    
    self.recorder = nil;
    self.completion = nil;
}

@end
