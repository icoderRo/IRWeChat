//
//  LCPhotoBrowseView.m
//  weChat
//
//  Created by Lc on 16/3/30.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LCPhotoBrowseView.h"
#import "LCPhotoBrowseCell.h"
#import "LCSession.h"
@interface LCPhotoBrowseView () <UICollectionViewDataSource, UICollectionViewDelegate, LCPhotoBrowseCellDelegate>
@property (nonatomic, weak) UIButton *saveButton;
@property (assign, nonatomic) NSInteger lastItem;
@property (assign, nonatomic) NSInteger currentItem;
@end

static NSString *const LCPhotoBrowseViewCellId = @"LCPhotoBrowseViewCellId";

@implementation LCPhotoBrowseView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        [self setupCollectionView];
    }
    
    return self;
}

- (void)setupCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(self.width, self.height);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height) collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    
    [collectionView registerClass:[LCPhotoBrowseCell class] forCellWithReuseIdentifier:LCPhotoBrowseViewCellId];
    [self addSubview:collectionView];
    
    UIButton *sBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sBtn setTitle:@"保存" forState:UIControlStateNormal];
    [sBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    sBtn.layer.cornerRadius = 5;
    sBtn.backgroundColor = [[UIColor darkGrayColor]colorWithAlphaComponent:0.3];
    [sBtn addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    self.saveButton = sBtn;
    [self addSubview:self.saveButton];
    
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.bottom.equalTo(self).offset(-40);
        make.size.equalTo(@(40));
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // 显示当前的图片
    [collectionView setContentOffset:CGPointMake(self.width * self.index, 0)];
    self.currentItem = self.index;
    return self.datasource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LCPhotoBrowseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LCPhotoBrowseViewCellId forIndexPath:indexPath];
    
    cell.session = self.datasource[indexPath.item];
    cell.delegate = self;
    self.lastItem = indexPath.item;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == self.lastItem) return;
    self.currentItem = self.lastItem;
}

- (void)saveImage
{
    LCSession *session = self.datasource[self.currentItem];
    
    if ([session.imageOriginalPath hasPrefix:@"http:"]) {
        NSData *data = [NSData imageDataWithURL:session.imageOriginalPath];
        UIImage *image = [UIImage imageWithData:data];
        
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
    } else {
        UIImage *image = [UIImage imageWithContentsOfFile:[NSString imageCachesPathWithImageName:session.imageFileName]];
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [MBProgressHUD showError:@"保存图片失败"];
    } else {
        [MBProgressHUD showSuccess:@"保存图片成功"];
    }
}

- (void)photoBrowseCellEndZooming:(LCPhotoBrowseCell *)photoBrowseCell
{
    [self removeFromSuperview];
}

- (void)show
{
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    window.windowLevel = 2000;
    [window addSubview:self];
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.15;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.3, 0.3, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.6, 0.6, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [self.layer addAnimation:animation forKey:nil];
}

@end

