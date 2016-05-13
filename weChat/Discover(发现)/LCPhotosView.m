//
//  LCPhotosView.m
//  weChat
//
//  Created by Lc on 16/5/9.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LCPhotosView.h"

#define LCPhotoMargin 5

@interface LCPhotosView ()
@property (weak, nonatomic) UIImageView *photoView;
@end

@implementation LCPhotosView
static CGSize onePhotoSize;
static CGFloat photoDefaultWH;
static CGFloat onePhotoH;
- (void)awakeFromNib
{
    [super awakeFromNib];
    for (NSInteger i = 0; i < 9; i ++) {
        UIImageView *imageV = [[UIImageView alloc] init];
        imageV.userInteractionEnabled = YES;
        [imageV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoViewTap:)]];
        _photoView = imageV;
        [self addSubview:_photoView];
    }
    
    if (iPhone5 || iPhone4S) {
        photoDefaultWH = 70;
        onePhotoH = 120;
    } else if(iPhone6s) {
        photoDefaultWH = 90;
        onePhotoH = 140;
    } else if(iPhone6SP) {
        photoDefaultWH =105;
        onePhotoH = 160;
    }
}

- (void)photoViewTap:(UITapGestureRecognizer *)tap
{
    LCLog(@"点击了图片");
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    for (NSInteger i = 0; i < self.subviews.count; i++) {
        UIImageView *photoView = self.subviews[i];
        if (i < photos.count) {
            photoView.hidden = NO;
            NSString *imageName = photos[i];
            photoView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", imageName]];
            NSInteger maxColumns = (photos.count == 4) ? 2 : 3;
            NSInteger col = i % maxColumns;
            NSInteger row = i / maxColumns;
            CGFloat photoX = col * (photoDefaultWH + LCPhotoMargin);
            CGFloat photoY = row * (photoDefaultWH + LCPhotoMargin);
            photoView.frame = CGRectMake(photoX, photoY, photoDefaultWH, photoDefaultWH);
            
            if (photos.count == 1) {
                photoView.contentMode = UIViewContentModeScaleAspectFit;
                photoView.frame = CGRectMake(photoX, photoY, onePhotoSize.width, onePhotoSize.height);
                photoView.clipsToBounds = NO;
            } else {
                photoView.contentMode = UIViewContentModeScaleAspectFill;
                photoView.clipsToBounds = YES;
            }
            
        } else {
            photoView.hidden = YES;
        }
    }
}

+ (CGSize)photosViewSizeWithPhotosCount:(NSInteger)count image:(UIImage *)image
{
    if (count == 1) {
        CGFloat onePhotoW = onePhotoH * image.size.height / (CGFloat)image.size.width;
        onePhotoSize = CGSizeMake(onePhotoW, onePhotoH);
        return CGSizeMake(onePhotoW, onePhotoH);
    }
    
    NSInteger maxColumns = (count == 4) ? 2 : 3;
    
    NSInteger rows = (count + maxColumns - 1) / maxColumns;
    
    CGFloat photosH = rows * photoDefaultWH + (rows - 1) * LCPhotoMargin;
    
    NSInteger cols = (count >= maxColumns) ? maxColumns : count;
    
    CGFloat photosW = cols * photoDefaultWH + (cols - 1) * LCPhotoMargin;
    
    if (photosH <= 0) photosH = 0;
    
    return CGSizeMake(photosW, photosH);
}
@end
