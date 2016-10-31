//
//  LCMoreInputView.h
//  weChat
//
//  Created by Lc on 16/3/29.
//  Copyright © 2016年 LC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCMoreInputView;

@protocol LCMoreInputViewDelegate <NSObject>

@required

- (void)moreInputView:(LCMoreInputView *)moreInputView didFinishChooseImageThumbnailFrame:(CGSize)thumbnailFrame fileName:(NSString *)fileName;

- (void)moreInputView:(LCMoreInputView *)moreInputView didFinishLocatingMapViewName:(NSString *)mapViewName locationName:(NSString *)locationName mapViewFrame:(CGSize)mapViewFrame;

@end

@interface LCMoreInputView : UIView

@property (weak, nonatomic) id<LCMoreInputViewDelegate> delegate;

@end
