//
//  LCLayer.h
//  LCLabel
//
//  Created by Lc on 16/7/9.
//  Copyright © 2016年 LC. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

/**
 *  监控绘制任务对象
 */
@interface LCFlag : NSObject

/**
 *  用来判断是否需要，取消当前的绘制, 值不等 取消回执
 *
 *  @return 标示符的值
 */
- (int32_t)value;

/**
 *  原值加1
 *
 *  @return 增加1后的值
 */
- (int32_t)increment;

@end



/**
 *  绘制图层
 */
@interface LCLayer : CALayer

/**
 *  是否异步绘制，默认是YES
 */
@property (nonatomic, assign, getter=isDrawAsync) BOOL drawAsync;

/**
 *  flag 监控绘制对象
 */
@property (nonatomic, strong, readonly) LCFlag *flag;

@end



/**
 *  渲染LCLayer用的task
 */
@interface LCLayerTask : NSObject

/**
 * 即将绘制的时候调用
 
  @param layer  当前layer
 
*/

@property (nullable, nonatomic, copy) void (^willDisplay)(CALayer *layer);

/**
 * 绘制时候调用
 
 @discussion 在主线程/子线程调用 需要保证线程的安全.
 
 @param context      新的位图内容.
 @param size         内容大小.
 @param isCancelled  是否需要绘制.
 
 */
@property (nullable, nonatomic, copy) void (^display)(CGContextRef context, CGSize size, BOOL(^cancel)(void));

/**
 * 绘制完成时候调用
 
 @param layer  当前layer.
 @param finished  是否绘制完成
 
 */
@property (nullable, nonatomic, copy) void (^didEndDisplay)(CALayer *layer, BOOL finished);

@end

@protocol LCLayerDelegate <NSObject>

/**
 *  绘制协议的代理方法
 *  @return 返回一个绘制任务，得到将要绘制时，绘制时，和绘制完成时的回调。
 */
- (LCLayerTask *)displayTask;

@end

NS_ASSUME_NONNULL_END