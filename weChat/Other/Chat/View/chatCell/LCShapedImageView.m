//
//  LCShapedImageView.m
//  weChat
//
//  Created by Lc on 16/4/21.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LCShapedImageView.h"

@implementation LCShapedImageView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
 
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.fillColor = [UIColor grayColor].CGColor;
        maskLayer.contentsCenter = CGRectMake(0.6, 0.6, 0.01, 0.01);
        maskLayer.contentsScale = [UIScreen mainScreen].scale;
        self.layer.mask = maskLayer;
        
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.maskView.frame = CGRectInset(self.bounds, 0, 0);
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
    self.layer.mask.frame = CGRectInset(self.bounds, 0, 0);
}
@end
