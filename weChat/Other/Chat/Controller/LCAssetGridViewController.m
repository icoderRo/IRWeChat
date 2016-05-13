//
//  LCAssetGridViewController.m
//  weChat
//
//  Created by Lc on 16/3/29.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LCAssetGridViewController.h"
#import "LCAssetGridCell.h"
#import "LCAsset.h"
#import "LCAssetViewController.h"
#import "LCAssetGridTooBar.h"

#define margin 3
#define col 3
#define toolBarHeight 55

@interface LCAssetGridViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, LCAssetGridCellDelegate, LCAssetViewControllerDelegate, LCAssetGridTooBarDelegate>

@property (weak, nonatomic) LCAssetGridTooBar *assetGridToolBar;
@property (weak, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *selectedItems;
@property (strong, nonatomic) NSMutableArray *assetArray;
@property (assign, nonatomic) NSInteger selectedImageCount;
@end

@implementation LCAssetGridViewController
static NSString *const LCAssetGridViewCellId = @"LCAssetGridViewCellId";
// 缩略图
static CGSize AssetGridThumbnailSize;

#pragma mark - lazy
- (NSMutableArray *)selectedItems
{
    if (!_selectedItems) {
        _selectedItems = [NSMutableArray array];
    }
    
    return _selectedItems;
}

- (NSMutableArray *)assetArray
{
    if (!_assetArray) {
        _assetArray = [NSMutableArray array];
        
        for (PHAsset *phAsset in self.allPhotos) {
            LCAsset *asset = [LCAsset assetWith:phAsset];
            [_assetArray addObject:asset];
        }
    }
    
    return _assetArray;
}

#pragma mark - init
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNav];
    [self setupCollectionView];
    [self setupToolbar];
    
}

- (void)setupNav
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:self action:@selector(clickReturnButton)];
}

- (void)clickReturnButton
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupCollectionView
{
    CGFloat WH = (self.view.width - (margin * (col + 1))) / col;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(WH, WH);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = margin;
    flowLayout.minimumInteritemSpacing = margin;
    flowLayout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - toolBarHeight) collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor lightGrayColor];
    
    collectionView.alwaysBounceVertical = YES;
    [collectionView registerClass:[LCAssetGridCell class] forCellWithReuseIdentifier:LCAssetGridViewCellId];
    self.collectionView = collectionView;
    [self.view addSubview:self.collectionView];
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize cellSize = flowLayout.itemSize;
    AssetGridThumbnailSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale);
}

- (void)setupToolbar
{
    LCAssetGridTooBar *toolbar = [[LCAssetGridTooBar alloc] initWithFrame:CGRectMake(0, self.view.height - toolBarHeight, self.view.width, toolBarHeight)];
    toolbar.delegate = self;
    _assetGridToolBar = toolbar;
    [self.view addSubview:_assetGridToolBar];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assetArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LCAssetGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LCAssetGridViewCellId forIndexPath:indexPath];
    
    LCAsset *asset = self.assetArray[indexPath.item];
    asset.assetGridThumbnailSize = AssetGridThumbnailSize;
    cell.asset = asset;
    cell.delegate = self;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LCAssetViewController *assetVc = [[LCAssetViewController alloc] init];
    assetVc.assetArray = self.assetArray;
    assetVc.selectedItems = self.selectedItems;
    assetVc.index = indexPath.item;
    assetVc.delegate = self;
    [self.navigationController pushViewController:assetVc animated:YES];
}

#pragma mark - LCInternalAssetGridToolBarDelegate
// 点击了预览
- (void)didClickPreviewInAssetGridToolBar:(LCAssetGridTooBar *)assetGridToolBar
{
    LCAssetViewController *assetVc = [[LCAssetViewController alloc] init];
    assetVc.delegate = self;
    assetVc.assetArray = self.selectedItems;
    // 深拷贝不可少
    assetVc.selectedItems = [self.selectedItems mutableCopy];
    [self.navigationController pushViewController:assetVc animated:YES];
}

// 监听assetGridToolBar发送按钮
- (void)didClickSenderButtonInAssetGridToolBar:(LCAssetGridTooBar *)assetGridToolBar
{
    if ([self.delegate respondsToSelector:@selector(assetGridViewController:didSenderImages:)]) {
        [self.delegate assetGridViewController:self didSenderImages:self.selectedItems];
    }
}

#pragma mark - LCInternalAssetViewControllerDelegate
// 监听assetView中选中的图片
- (void)assetViewController:(LCAssetViewController *)assetViewController selectedItemsInAssetViewController:(NSMutableArray *)selectedItems
{
    for (LCAsset *asset in self.assetArray) {
        for (LCAsset *selectedAsset in selectedItems) {
            if ([[asset class]isMemberOfClass:[selectedAsset class]]) {
                asset.selected = YES;
            }
        }
    }
    
    self.selectedItems = selectedItems;
    self.assetGridToolBar.selectedItems = self.selectedItems;
    [self.collectionView reloadData];
}

// 监听assetView中发送按钮
- (void)assetViewController:(LCAssetViewController *)assetViewController didClickSenderButton:(NSMutableArray *)selectedItems
{
    self.selectedItems = selectedItems;
    
    if ([self.delegate respondsToSelector:@selector(assetGridViewController:didSenderImages:)]) {
        [self.delegate assetGridViewController:self didSenderImages:self.selectedItems];
    }
}

// 监听assetGridCell中选中的图片
#pragma mark - LCInternalAssetGridCellDelegate
- (void)assetGridCell:(LCAssetGridCell *)assetGridCell isSelected:(BOOL)selected isNeedToAdd:(void (^)(BOOL))add
{
    if (selected) {
        self.selectedImageCount += 1;
        if (self.selectedImageCount > maxSelectedImageCount) {
            self.selectedImageCount = maxSelectedImageCount;
            [MBProgressHUD showError:@"图片最多选择5张"];
            if (add) add(NO);
            return;
        }
        [self.selectedItems addObject:assetGridCell.asset];
    } else {
        self.selectedImageCount -= 1;
        [self.selectedItems removeObject:assetGridCell.asset];
    }
    
    if (add) add(YES);
    self.assetGridToolBar.selectedItems = self.selectedItems;
}
@end
