//
//  LCAudioManager.h
//  LCAudioManager
//
//  Created by Lc on 16/3/31.
//  Copyright © 2016年 LC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCAudioManager : NSObject

+ (instancetype)manager;

#pragma mark - LCAudioRecord
// 判断麦克风是否可用
- (BOOL)checkMicrophoneAvailability;
 
/**
 *  开始录音
 *
 */
- (void)startRecordingWithFileName:(NSString *)fileName
                             completion:(void(^)(NSError *error))completion;

/**
 *  停止录音
 *
 */
- (void)stopRecordingWithCompletion:(void(^)(NSString *recordPath,
                                                 NSInteger aDuration,
                                                 NSError *error))completion;
/**
 *  取消录音
 */
- (void)cancelRecording;

/**
 *  当前是否正在录音
 *
 */
- (BOOL)isRecording;


#pragma mark - LCAudioPlay
/**
 *  播放音频
 *
 */
- (void)playingWithRecordPath:(NSString *)recordPath
                  completion:(void(^)(NSError *error))completion;

/**
 *  停止播放
 *
 */
- (void)stopPlaying;

/**
 *  当前是否正在播放
 *
 */
-(BOOL)isPlaying;
@end
