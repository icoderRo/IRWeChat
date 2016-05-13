//
//  LCAudioPlayTool.h
//  LC
//
//  Created by Lc on 16/3/3.
//  Copyright © 2016年 LC. All rights reserved.
//
#import <Foundation/Foundation.h>
@class LCSession;

@interface LCAudioPlayTool : NSObject

/**
 *  播放当前的选中的音频
 *
 *  @param session 模型
 *  @param msgLabel        显示音频的label
 *  @param receiver        是否接受者
 */
+ (void)playWithMessage:(LCSession *)internalSession msgLabel:(UILabel *)msgLabel receiver:(BOOL)receiver;

/**
 *  停止播放
 */
+ (void)stop;

/**
 *  播放动画
 */
+ (void)playingImageView;
/**
 *  停止播放动画
 */
+ (void)stopPlayingImageView;

@end
