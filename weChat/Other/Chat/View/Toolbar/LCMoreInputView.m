//
//  LCMoreInputView.m
//  weChat
//
//  Created by Lc on 16/3/29.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LCMoreInputView.h"
#import "LCAssetGridViewController.h"
#import "LCAsset.h"
#import "LCMoreInputCell.h"
#import "LCAddressMapViewController.h"
#import "LCNavigationController.h"

@interface LCMoreInputView ()<UICollectionViewDelegate, UICollectionViewDataSource, LCAssetGridViewControllerDelegate, LCMoreInputCellDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, LCAddressMapViewControllerDelegate>
@property (weak, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *moreInputViews;
@property (weak, nonatomic) UIPageControl *pageControl;
@property (assign, nonatomic) NSInteger lastItem;
@end

@implementation LCMoreInputView
static NSString *const LCMoreInputViewCellId = @"LCMoreInputViewCellId";
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];;
        
        [self collecView];
        [self pageControl];
    }
    
    return self;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.frame = CGRectMake(0, CGRectGetMaxY(self.collectionView.frame) + 10 , 0, 10);
        pageControl.centerX = self.centerX;
        pageControl.numberOfPages = self.moreInputViews.count;
        pageControl.currentPage = 0;
        pageControl.pageIndicatorTintColor = [UIColor grayColor];
        pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        
        [self addSubview:pageControl];
        _pageControl = pageControl;
    }
    
    return _pageControl;
}

- (NSArray *)moreInputViews
{
    if (!_moreInputViews) {
        _moreInputViews = [NSArray array];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"moreInputView" ofType:@"plist"];
        _moreInputViews = [NSArray arrayWithContentsOfFile:path];
    }
    
    return _moreInputViews;
}

- (UICollectionView *)collecView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(self.width, self.height - 45);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 0;
        
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height - 45) collectionViewLayout:flowLayout];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.pagingEnabled = YES;
        collectionView.showsHorizontalScrollIndicator = NO;
        
        [collectionView registerClass:[LCMoreInputCell class] forCellWithReuseIdentifier:LCMoreInputViewCellId];
        _collectionView = collectionView;
        [self addSubview:_collectionView];
    }
    
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.moreInputViews.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LCMoreInputCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LCMoreInputViewCellId forIndexPath:indexPath];
    self.lastItem = indexPath.item;
    cell.moreInputViews = self.moreInputViews[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == self.lastItem) return;
    self.pageControl.currentPage = self.lastItem;
}

#pragma mark - LCMoreInputCellDelegate
- (void)didClickImageViewInMoreInputCell:(LCMoreInputCell *)moreInputCell
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusDenied) { //相册权限未开启
        [self showAlertView];
        
    }else if(status == PHAuthorizationStatusNotDetermined){ // 第一次安装程序
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
            //授权后直接打开照片库
            if (status == PHAuthorizationStatusAuthorized){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showAssetGridView];
                });
            }
        }];
    }else if (status == PHAuthorizationStatusAuthorized){
        [self showAssetGridView];
    }
}
// 显示图片
- (void)showAssetGridView
{
    PHFetchResult *allPhotos = [PHAsset fetchAssetsWithOptions:[[PHFetchOptions alloc] init]];
    
    LCAssetGridViewController *assetGridViewController = [[LCAssetGridViewController alloc] init];
    assetGridViewController.delegate = self;
    assetGridViewController.allPhotos = (NSMutableArray *)allPhotos;
    LCNavigationController *nav = [[LCNavigationController alloc] initWithRootViewController:assetGridViewController];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
}

-(void)showAlertView
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:[NSString stringWithFormat:@"请在iPhone的“设置->隐私->照片”开启%@访问你的手机相册",app_Name] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action =  [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:action];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

#pragma mark - LCAssetGridViewControllerDelegate
// 监听发送图片的按钮
- (void)assetGridViewController:(LCAssetGridViewController *)assetGridViewController didSenderImages:(NSMutableArray *)imageArray
{
    for (LCAsset *asset in imageArray) {
        
        PHAsset *phAsset = asset.phAsset;
        
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg",phAsset.localIdentifier];
         NSString *cachesPath = [NSString imageCachesPathWithImageName:fileName];
        
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.synchronous = YES;
        [[PHImageManager defaultManager] requestImageDataForAsset:phAsset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            NSData *tumbnailImageData = nil;
            if (asset.dataLength > 1024 * 1024) { // 大于1M,压缩
                UIImage *image = [UIImage imageWithData:imageData];
                tumbnailImageData = [imageData compressImage:image toMaxFileSize:1024 *1024];
                
                [tumbnailImageData writeToFile:cachesPath atomically:YES];

            } else {
                tumbnailImageData = imageData;
                [tumbnailImageData writeToFile:cachesPath atomically:YES];
            }
             UIImage * tumbnailImage = [UIImage imageWithData:tumbnailImageData];
             CGSize size = [tumbnailImage fixSizeWithImageSize:tumbnailImage.size rate:60];
            if ([self.delegate respondsToSelector:@selector(moreInputView:didFinishChooseImageThumbnailFrame:fileName:)]) {
                [self.delegate moreInputView:self didFinishChooseImageThumbnailFrame:size fileName:fileName];
            }
            
        }];
    }
    
    [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

// 拍摄
- (void)didClickCameraViewInMoreInputCell:(LCMoreInputCell *)moreInputCell
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImagePNGRepresentation(image);
    
    NSData *tumbnailImageData = nil;
    if (imageData.length > 1024 * 1024) { // 大于1M 压缩
        tumbnailImageData = [imageData compressImage:image toMaxFileSize:1024 *1024];
    } else {
        tumbnailImageData = imageData;
    }
    UIImage * tumbnailImage = [UIImage imageWithData:tumbnailImageData];
    CGSize size = [tumbnailImage fixSizeWithImageSize:tumbnailImage.size rate:60];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg",[NSString recordFileName]];
    NSString *cachesPath = [NSString imageCachesPathWithImageName:fileName];
    [tumbnailImageData writeToFile:cachesPath atomically:YES];
    if ([self.delegate respondsToSelector:@selector(moreInputView:didFinishChooseImageThumbnailFrame:fileName:)]) {
        [self.delegate moreInputView:self didFinishChooseImageThumbnailFrame:size fileName:fileName];
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    });
    
    [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

// 定位
- (void)didClickLocationViewInMoreInputCell:(LCMoreInputCell *)moreInputCell
{
    LCAddressMapViewController *amVc = [[LCAddressMapViewController alloc] init];
    amVc.delegate = self;
    LCNavigationController *nav = [[LCNavigationController alloc] initWithRootViewController:amVc];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
}

#pragma mark - LCAddressMapViewControllerDelegate
- (void)addressMapViewController:(LCAddressMapViewController *)ddressMapViewController didClickSenderWithMapView:(UIImage *)MapView locationName:(NSString *)locationName
{
    CGSize size = [MapView fixSizeWithImageSize:MapView.size rate:5];
    NSData *imageData = UIImageJPEGRepresentation(MapView, 0.0001);
    
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg",[NSString recordFileName]];
    NSString *cachesPath = [NSString imageCachesPathWithImageName:fileName];
    [imageData writeToFile:cachesPath atomically:YES];
    
    if ([self.delegate respondsToSelector:@selector(moreInputView:didFinishLocatingMapViewName:locationName:mapViewFrame:)]) {
        [self.delegate moreInputView:self didFinishLocatingMapViewName:fileName locationName:locationName mapViewFrame:size];
    }
    
    [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
