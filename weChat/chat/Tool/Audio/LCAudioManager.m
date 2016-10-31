//
//  LCAudioManager.m
//  LCAudioManager
//
//  Created by Lc on 16/3/31.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LCAudioManager.h"
#import "LCAudioPlay.h"
#import "LCAudioRecord.h"
#import <AVFoundation/AVFoundation.h>
#import "lame.h"

#define audioRecordDurationTooShort -100
#define audioRecordStoping -101
#define audioRecordNotStarted -102
#define audioRecordConvertionFailure -103
#define audioRecordPathNotFound -104

#define recordMinDuration 1.0

typedef NS_ENUM(NSInteger, audioSession){
    audioSessionDefault = 0,
    audioSessionAudioRecord = 1,
    audioSessionPlay = 2
};

@interface LCAudioManager ()

@property (strong, nonatomic) NSDate *recordStartDate;
@property (strong, nonatomic) NSDate *recordEndDate;
@property (copy, nonatomic) NSString *audioSessionCategory;
@property (assign, nonatomic) BOOL currentActive;

@end

@implementation LCAudioManager

+ (instancetype)manager
{
    static LCAudioManager *audioManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        audioManager = [[self alloc] init];
    });
    
    return audioManager;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self changeProximityMonitorEnableState:YES];
        [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
        
    }
    
    return self;
}

- (BOOL)checkMicrophoneAvailability
{
    __block BOOL open = NO;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    if ([session respondsToSelector:@selector(requestRecordPermission:)]) {
        [session performSelector:@selector(requestRecordPermission:) withObject:^(BOOL status) {
            open = status;
        }];
    } else {
        open = YES;
    }
    
    return open;
}

#pragma mark - ProximityMonitor
- (void)changeProximityMonitorEnableState:(BOOL)enable
{
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    if ([UIDevice currentDevice].proximityMonitoringEnabled == YES) {
        if (enable) {
            
            //添加近距离事件监听，添加前先设置为YES，如果设置完后还是NO的读话，说明当前设备没有近距离传感器
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sensorStateChange) name:UIDeviceProximityStateDidChangeNotification object:nil];
            
        } else {
            //删除近距离事件监听
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceProximityStateDidChangeNotification object:nil];
            [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
        }
    }
}

- (void)sensorStateChange
{
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗
    if ([[UIDevice currentDevice] proximityState] == YES) {
        //黑屏
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        
    } else {
        //没黑屏幕
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        if (![self isPlaying]) {
            //没有播放了，也没有在黑屏状态下，就可以把距离传感器关了
            [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
        }
    }
}


- (void)dealloc
{
    [self changeProximityMonitorEnableState:NO];
}

#pragma mark - LCAudioRecord
- (void)startRecordingWithFileName:(NSString *)fileName completion:(void (^)(NSError *))completion
{
    if ([self isRecording]) {
        [self cancelRecording];
        if (completion) completion([NSError errorWithDomain:NSLocalizedString(@"LCAudio.recordStop", @"停止当前录音") code:audioRecordStoping userInfo:nil]);
        
        return;
    }
    
    if (!fileName || fileName.length == 0) {
        if (completion) completion([NSError errorWithDomain:NSLocalizedString(@"LCAudio.recordPathNotFound", @"尚未找到文件") code:audioRecordPathNotFound userInfo:nil]);
        return;
    }
    
    [self setCategory:audioSessionAudioRecord isActive:YES];
    [[LCAudioRecord sharedInstance] startRecordingWithRecordPath:[self recordPathWithfileName:fileName] completion:completion];
    
    self.recordStartDate = [NSDate date];
}

- (void)stopRecordingWithCompletion:(void (^)(NSString *, NSInteger, NSError *))completion
{
    if (![self isRecording]) {
        if (completion) completion(nil, 0, [NSError errorWithDomain:NSLocalizedString(@"LCAudio.recordNotStart", @"未有录音") code:audioRecordNotStarted userInfo:nil]);
        
        return;
    }
    
    self.recordEndDate = [NSDate date];
    __weak typeof(self) weakSelf = self;
    NSTimeInterval duration = [self.recordEndDate timeIntervalSinceDate:self.recordStartDate];
    if (duration < recordMinDuration) {
        if (completion) completion(nil, 0, [NSError errorWithDomain:NSLocalizedString(@"LCAudio.recordTimeTooShort", @"录音小于1秒") code:audioRecordDurationTooShort userInfo:nil]);
        
        
        [[LCAudioRecord sharedInstance] stopRecordingWithCompletion:^(NSString *recordPath) {
            [weakSelf setCategory:audioSessionDefault isActive:NO];
        }];
        
        return;
    }
    
    [[LCAudioRecord sharedInstance] stopRecordingWithCompletion:^(NSString *recordPath) {
        if (completion) {
            NSString *mp3FilePath = [self MP3FilePath:recordPath];
            BOOL convertResult = [self convertWAV:recordPath toMP3:mp3FilePath];
            if (convertResult) {
                // 删除录的wav
                [[NSFileManager defaultManager] removeItemAtPath:recordPath error:nil];
            }
            
            completion(mp3FilePath,(NSInteger)duration, nil);
        }
        
        [weakSelf setCategory:audioSessionDefault isActive:NO];
    }];
}

- (void)cancelRecording
{
    [[LCAudioRecord sharedInstance] cancelRecording];
}

- (BOOL)isRecording
{
    return [[LCAudioRecord sharedInstance] isRecording];
}

#pragma mark - LCAudioPlay

- (void)playingWithRecordPath:(NSString *)recordPath completion:(void (^)(NSError *))completion
{
    if ([self isPlaying]) [self stopPlaying];
    
    [self setCategory:audioSessionPlay isActive:YES];
    
    NSString *mp3FilePath = [self MP3FilePath:recordPath];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:mp3FilePath]) { // 如果没有转化成功,尝试再次转换
        BOOL convertResult = [self convertWAV:recordPath toMP3:mp3FilePath];
        if (convertResult) {
            // 删除录的wav
            [[NSFileManager defaultManager] removeItemAtPath:recordPath error:nil];
        } else {
            if (completion) completion([NSError errorWithDomain:NSLocalizedString(@"LCAudio.recordConvertionFailure", @"转换文件失败") code:audioRecordConvertionFailure userInfo:nil]);
            
            return;
        }
    }
    
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    [[LCAudioPlay sharedInstance] playingWithPath:[self MP3FilePath:recordPath] completion:^(NSError *error) {
        [self setCategory:audioSessionDefault isActive:NO];
        if (completion) completion(error);
    }];
}

- (void)stopPlaying
{
    [[LCAudioPlay sharedInstance] stopPlaying];
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    [self setCategory:audioSessionDefault isActive:NO];
}

- (BOOL)isPlaying
{
    return [[LCAudioPlay sharedInstance] isPlaying];
}

#pragma mark - setCategory && setActive
- (void)setCategory:(audioSession)session isActive:(BOOL)active
{
    NSError *error = nil;
    NSString *category = nil;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    switch (session) {
        case audioSessionAudioRecord:
            category = AVAudioSessionCategoryRecord;
            break;
        case audioSessionPlay:
            category = AVAudioSessionCategoryPlayback;
            break;
        default:
            category = AVAudioSessionCategoryAmbient;
            break;
    }
    
    if (![self.audioSessionCategory isEqualToString:category]) [audioSession setCategory:category error:nil];
    
    
    if (active != self.currentActive) {
        self.currentActive = active;
        BOOL success = [audioSession setActive:active withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
        if (!success || error) return ;
    }
    
    self.audioSessionCategory = category;
    
}

#pragma mark - path
- (NSString *)recordPathWithfileName:(NSString *)fileName
{
    NSString *recordPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    recordPath = [NSString stringWithFormat:@"%@/records/",recordPath];
    recordPath = [recordPath stringByAppendingPathComponent:fileName];
    if(![[NSFileManager defaultManager] fileExistsAtPath:[recordPath stringByDeletingLastPathComponent]]){
        [[NSFileManager defaultManager] createDirectoryAtPath:[recordPath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return recordPath;
}

- (NSString *)MP3FilePath:(NSString *)aFilePath
{
    return [[aFilePath stringByDeletingPathExtension] stringByAppendingPathExtension:@"mp3"];
}
#pragma mark - Convert
// 使用三方库 lame
- (BOOL)convertWAV:(NSString *)wavFilePath toMP3:(NSString *)mp3FilePath{
    BOOL ret = NO;
    BOOL isFileExists = [[NSFileManager defaultManager] fileExistsAtPath:wavFilePath];
    if (isFileExists) {
        int read, write;
        
        FILE *pcm = fopen([wavFilePath cStringUsingEncoding:1], "rb");   //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                                   //skip file header
        FILE *mp3 = fopen([mp3FilePath  cStringUsingEncoding:1], "wb"); //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 11025.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
        isFileExists = [[NSFileManager defaultManager] fileExistsAtPath:mp3FilePath];
        if (isFileExists) {
            ret = YES;
        }
    }
    
    return ret;
}
@end
