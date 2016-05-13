//
//  LCAudioRecord.h
//  LCAudioManager
//
//  Created by Lc on 16/3/31.
//  Copyright © 2016年 LC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCAudioRecord : NSObject

+ (instancetype)sharedInstance;

/**
 *  开始录音
 *
 */
- (void)startRecordingWithRecordPath:(NSString *)recordPath
                             completion:(void(^)(NSError *error))completion;

/**
 *  停止录音
 *
 */
- (void)stopRecordingWithCompletion:(void(^)(NSString *recordPath))completion;

/**
 *  取消录音
 */
- (void)cancelRecording;

/**
 *  当前是否正在录音
 *
 */
- (BOOL)isRecording;
@end
