//
//  LCLayer.m
//  LCLabel
//
//  Created by Lc on 16/7/9.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LCLayer.h"
#import <libkern/OSAtomic.h>

@interface LCLayer ()

@property (strong, nonatomic) LCFlag *flag;

@end

@implementation LCFlag
{
    int32_t _value;
}

- (int32_t)value
{
    return _value;
}

- (int32_t)increment
{
    return OSAtomicIncrement32(&_value);
}

@end


@implementation LCLayer

#pragma mark - serial queue
+ (dispatch_queue_t)displayQueue
{
    #define MAX_QUEUE_COUNT 16
    static int queueCount;
    static dispatch_queue_t queues[MAX_QUEUE_COUNT];
    static dispatch_once_t onceToken;
    static int32_t counter = 0;
    dispatch_once(&onceToken, ^{
        queueCount = (int)[NSProcessInfo processInfo].activeProcessorCount;
        queueCount = queueCount < 1 ? 1 : queueCount > MAX_QUEUE_COUNT ? MAX_QUEUE_COUNT : queueCount;
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            for (NSUInteger i = 0; i < queueCount; i++) {
                dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INITIATED, 0);
                queues[i] = dispatch_queue_create("com.icoderRo.weChat", attr);
            }
        } else {
            for (NSUInteger i = 0; i < queueCount; i++) {
                queues[i] = dispatch_queue_create("com.icoderRo.weChat", DISPATCH_QUEUE_SERIAL);
                dispatch_set_target_queue(queues[i], dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
            }
        }
    });
    int32_t cur = OSAtomicIncrement32(&counter);
    if (cur < 0) cur = -cur;
    return queues[(cur) % queueCount];
    #undef MAX_QUEUE_COUNT
}


#pragma mark - Override
+ (id)defaultValueForKey:(NSString *)key
{
    if ([key isEqualToString:@"drawAsync"]) {
        return @(YES);
    } else {
        return [super defaultValueForKey:key];
    }
}

#pragma mark - LifeCycle

- (instancetype)init
{
    if (self = [super init]) {
        
        _flag = [[LCFlag alloc] init];
        
        static CGFloat scale;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            scale = [UIScreen mainScreen].scale;
        });
        self.contentsScale = scale;
        
        _drawAsync = YES;
    }
    
    return self;
}

- (void)setNeedsDisplay
{
    // 取消绘制
    [self.flag increment];
    [super setNeedsDisplay];
}


- (void)display
{
    super.contents = super.contents;
    [self display:self.drawAsync];
}

#pragma mark - private
- (void)display:(BOOL)drawAsync
{
    __strong id<LCLayerDelegate> delegate = self.delegate;
    LCLayerTask *task = [delegate displayTask];
    
    if (!task.display) {
        if (task.willDisplay) task.willDisplay(self);
        self.contents = nil;
        if (task.didEndDisplay) task.didEndDisplay(self, YES);
        return;
    }
    
    if (drawAsync) {
        if (task.willDisplay) task.willDisplay(self);
        
        LCFlag *flag = self.flag;
        BOOL (^cancel)() = ^BOOL(){
            return flag.value != self.flag.value;
        };
        
        CGColorRef backgroundColor = (self.opaque && self.backgroundColor) ?
        CGColorRetain(self.backgroundColor) : NULL;
        
        if (self.bounds.size.width < 1 || self.bounds.size.height < 1) {
            CGImageRef image = (__bridge_retained CGImageRef)(self.contents);
            self.contents = nil;
            if (image) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                    CFRelease(image);
                });
            }
            
            if (task.didEndDisplay) task.didEndDisplay(self, YES);
            CGColorRelease(backgroundColor);
            return;
        }
        
        dispatch_async([LCLayer displayQueue], ^{ // 开启线程绘制
            
            if (cancel()) {
                CGColorRelease(backgroundColor);
                return ;
            }
            
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, self.contentsScale);
            
            CGContextRef context = UIGraphicsGetCurrentContext();
            
            if (self.opaque) {
                CGContextSaveGState(context);
                
                if (!backgroundColor || CGColorGetAlpha(backgroundColor) < 1) {
                    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
                    CGContextAddRect(context, CGRectMake(0, 0, self.bounds.size.width * self.contentsScale, self.bounds.size.height * self.contentsScale));
                    CGContextFillPath(context);
                }
                
                if (backgroundColor) {
                    CGContextSetFillColorWithColor(context, backgroundColor);
                    CGContextAddRect(context, CGRectMake(0, 0, self.bounds.size.width * self.contentsScale, self.bounds.size.height * self.contentsScale));
                    CGContextFillPath(context);
                }
                
                CGContextRestoreGState(context);
                CGColorRelease(backgroundColor);
            }
            
            task.display(context, self.bounds.size, cancel);
            
            if (cancel()) {
                UIGraphicsEndImageContext();
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (task.didEndDisplay) task.didEndDisplay(self, NO);
                });
                return;
            }
            
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            if (cancel()) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (task.didEndDisplay) task.didEndDisplay(self, NO);
                });
                return;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (cancel()) {
                    
                    if (task.didEndDisplay) task.didEndDisplay(self, NO);
                    
                } else {
                    self.contents = (__bridge id)(image.CGImage);
                    
                    if (task.didEndDisplay) task.didEndDisplay(self, YES);
                }
            });
        });
        
    } else {
        
        // 用于取消异步的绘制
        [self.flag increment];
        
        if (task.willDisplay) task.willDisplay(self);
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, self.contentsScale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        if (self.opaque) {
            CGSize size = self.bounds.size;
            size.width *= self.contentsScale;
            size.height *= self.contentsScale;
            CGContextSaveGState(context); {
                if (!self.backgroundColor || CGColorGetAlpha(self.backgroundColor) < 1) {
                    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
                    CGContextAddRect(context, CGRectMake(0, 0, size.width, size.height));
                    CGContextFillPath(context);
                }
                if (self.backgroundColor) {
                    CGContextSetFillColorWithColor(context, self.backgroundColor);
                    CGContextAddRect(context, CGRectMake(0, 0, size.width, size.height));
                    CGContextFillPath(context);
                }
            } CGContextRestoreGState(context);
        }
        
        task.display(context, self.bounds.size, ^{return NO;});
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.contents = (__bridge id)(image.CGImage);
        
        if (task.didEndDisplay) task.didEndDisplay(self, YES);
 
    }
    
}
@end

@implementation LCLayerTask

@end