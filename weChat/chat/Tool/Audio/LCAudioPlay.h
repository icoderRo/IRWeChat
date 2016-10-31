//
//  LCAudioPlay.h
//  LCAudioManager
//
//  Created by Lc on 16/3/31.
//  Copyright © 2016年 LC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCAudioPlay : NSObject

+ (instancetype)sharedInstance;

/**
 *  当前是否正在播放
 *
 */
- (BOOL)isPlaying;

/**
 *  播放音频
 *
 */
- (void)playingWithPath:(NSString *)recordPath
                  completion:(void(^)(NSError *error))completion;

/**
 *  停止播放
 *
 */
- (void)stopPlaying;
@end
