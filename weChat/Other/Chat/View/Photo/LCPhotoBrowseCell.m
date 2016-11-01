//
//  LCPhotoBrowseCell.m
//  weChat
//
//  Created by Lc on 16/3/29.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LCPhotoBrowseCell.h"
#import "LCSession.h"
#import "DALabeledCircularProgressView.h"

#define progressViewWH  100
@interface LCPhotoBrowseCell () <UIScrollViewDelegate>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *imgScrollView;
@property (strong, nonatomic) DALabeledCircularProgressView *progressView;
@property (nonatomic, assign) BOOL doubleTap;
@end

@implementation LCPhotoBrowseCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.imgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 0, self.width -10, self.height)];
        self.imgScrollView.delegate = self;
        self.imgScrollView.maximumZoomScale = 3.0;
        self.imgScrollView.minimumZoomScale = 1;
        self.imgScrollView.showsVerticalScrollIndicator = NO;
        self.imgScrollView.showsHorizontalScrollIndicator = NO;
        self.imgScrollView.decelerationRate = UIScrollViewDecelerationRateFast;
        self.imgScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.imgScrollView];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        self.imageView.userInteractionEnabled = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self.imgScrollView addSubview:self.imageView];
        
        self.progressView = [[DALabeledCircularProgressView alloc] initWithFrame:CGRectMake((self.width - progressViewWH) * 0.5 , (self.height  -progressViewWH )*0.5, progressViewWH, progressViewWH)];
        self.progressView.roundedCorners = 5;
        self.progressView.progressLabel.textColor = [UIColor whiteColor];
        self.progressView.hidden = YES;
        [self addSubview:self.progressView];

        // 监听点击
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
        singleTap.delaysTouchesBegan = YES;
        singleTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        
    }
    
    return self;
}
- (void)setSession:(LCSession *)session
{
    _session = session;
    LCWeakSelf
    if ([session.imageOriginalPath hasPrefix:@"http:"]) {
        
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:session.imageOriginalPath]  placeholderImage:nil options:SDWebImageLowPriority | SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
            weakSelf.progressView.hidden = NO;
            weakSelf.progressView.progress = 1.0 * receivedSize / expectedSize;
            weakSelf.progressView.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", weakSelf.progressView.progress * 100];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            weakSelf.progressView.hidden = YES;
            [self adjustFrame];
        }];
    }else{
        
        UIImage *image = [UIImage imageWithContentsOfFile:[NSString imageCachesPathWithImageName:session.imageFileName]];
        [self.imageView setImage:image];
        [self adjustFrame];
    }
    
    [self adjustFrame];
}

- (void)adjustFrame
{
    if (_imageView.image == nil) return;
    
    CGSize boundsSize = self.bounds.size;
    CGFloat boundsWidth = boundsSize.width;
    CGFloat boundsHeight = boundsSize.height;
    
    CGSize imageSize = _imageView.image.size;
    CGFloat imageWidth = imageSize.width;
    CGFloat imageHeight = imageSize.height;
    
    // 设置伸缩比例
    CGFloat minScale = boundsWidth / imageWidth;
    if (minScale > 1) minScale = 1.0;
    
    CGFloat maxScale = 3.0;
    
    if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
        maxScale = maxScale / [[UIScreen mainScreen] scale];
    }
    self.imgScrollView.maximumZoomScale = maxScale;
    self.imgScrollView.minimumZoomScale = minScale;
    self.imgScrollView.zoomScale = minScale;
    
    CGRect imageFrame = CGRectMake(0, 0, boundsWidth, imageHeight * boundsWidth / imageWidth);
    // 内容尺寸
    self.imgScrollView.contentSize = CGSizeMake(0, imageFrame.size.height);
    
    // y值
    if (imageFrame.size.height < boundsHeight) {
        imageFrame.origin.y = floorf((boundsHeight - imageFrame.size.height) / 2.0);
    } else {
        imageFrame.origin.y = 0;
    }
    
    _imageView.frame = imageFrame;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGRect imageViewFrame = _imageView.frame;
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    if (imageViewFrame.size.height > screenBounds.size.height) {
        imageViewFrame.origin.y = 0.0f;
    } else {
        imageViewFrame.origin.y = (screenBounds.size.height - imageViewFrame.size.height) / 2.0;
    }
    _imageView.frame = imageViewFrame;
}

- (void)handleSingleTap
{
    _doubleTap = NO;
    [self performSelector:@selector(hide) withObject:nil afterDelay:0.2];
    
}

- (void)hide
{
    if (_doubleTap) return;
    if ([self.delegate respondsToSelector:@selector(photoBrowseCellEndZooming:)]) {
        [self.delegate photoBrowseCellEndZooming:self];
    }
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)tap {
    _doubleTap = YES;
    
    CGPoint touchPoint = [tap locationInView:self];
    if (self.imgScrollView.zoomScale == self.imgScrollView.maximumZoomScale) {
        [self.imgScrollView setZoomScale:self.imgScrollView.minimumZoomScale animated:YES];
    } else {
        [self.imgScrollView zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) animated:YES];
    }
}

@end
