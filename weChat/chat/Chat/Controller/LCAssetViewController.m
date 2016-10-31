//
//  LCAssetViewController.m
//  weChat
//
//  Created by Lc on 16/3/29.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LCAssetViewController.h"
#import "LCAssetCell.h"
#import "LCAsset.h"

#define toolbarHeight 44

@interface LCAssetViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) LCAsset *asset;
@property (weak, nonatomic) UIButton *originalButton;
@property (weak, nonatomic) UIButton *senderButton;

// 当前图片索引
@property (assign, nonatomic) NSInteger lastItem;

@end

@implementation LCAssetViewController

static NSString * const LCAssetViewCellId = @"LCAssetViewCellId";
static UIButton *selectedButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNav];
    [self setupCollectionView];
    [self setupToolbar];
    [self updateSenderButtonStatus];
    
    LCAsset *asset = self.assetArray[self.index];
    selectedButton.selected = asset.isSelected;
}

- (void)setupNav
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_back"] style:UIBarButtonItemStyleDone target:self action:@selector(clickBackButton)];
    
    selectedButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [selectedButton setBackgroundImage:[UIImage imageNamed:@"photo_def_photoPickerVc"] forState:UIControlStateNormal];
    [selectedButton setBackgroundImage:[UIImage imageNamed:@"photo_sel_photoPickerVc"] forState:UIControlStateSelected];
    [selectedButton addTarget:self action:@selector(clickSelectedButton:) forControlEvents:UIControlEventTouchDown
     ];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:selectedButton];
}

- (void)setupToolbar
{
    // 底部工具条
    UIView *toolbar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - toolbarHeight, self.view.width, toolbarHeight)];
    toolbar.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
    [self.view addSubview:toolbar];
    
    // 原图按钮
    UIButton *originalButton = [[UIButton alloc] init];
    [originalButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [originalButton setTitle:@"原图" forState:UIControlStateNormal];
    [originalButton setTitleColor:LCColor(93, 93, 93) forState:UIControlStateNormal];
    [originalButton setTitleColor:LCColor(224, 224, 224) forState:UIControlStateSelected];
    [originalButton setImage:[UIImage imageNamed:@"preview_original_def"] forState:UIControlStateNormal];
    [originalButton setImage:[UIImage imageNamed:@"photo_original_sel"] forState:UIControlStateSelected];
    [originalButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 7, 0, 0)];
    [originalButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [originalButton addTarget:self action:@selector(clickOriginalButton:) forControlEvents:UIControlEventTouchUpInside];
    _originalButton = originalButton;
    [toolbar addSubview:_originalButton];
    [_originalButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(toolbar).offset(10);
        make.width.equalTo(@(120));
        make.centerY.equalTo(toolbar);
    }];
    
    // 发送按钮
    UIButton *senderButton = [[UIButton alloc] init];
    [senderButton setTitle:@"发送" forState:UIControlStateDisabled];
    [senderButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [senderButton setTitleColor:LCColor(93, 93, 93) forState:UIControlStateDisabled];
    [senderButton setTitleColor:LCColor(224, 224, 224) forState:UIControlStateNormal];
    [senderButton setEnabled:NO];
    [senderButton addTarget:self action:@selector(clickSenderButton) forControlEvents:UIControlEventTouchUpInside];
    _senderButton = senderButton;
    [toolbar addSubview:_senderButton];
    [_senderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(toolbar).offset(-10);
        make.centerY.equalTo(toolbar);
    }];
}

- (void)setupCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(self.view.width, self.view.height - CGRectGetMaxY(self.navigationController.navigationBar.frame) - toolbarHeight);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - toolbarHeight) collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.backgroundColor = [UIColor blackColor];
    
    [collectionView registerClass:[LCAssetCell class] forCellWithReuseIdentifier:LCAssetViewCellId];
    [self.view addSubview:collectionView];
    
    // 进入当前控制器后,显示的图片
    [collectionView setContentOffset:CGPointMake(self.view.width * self.index, 0)];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.assetArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LCAssetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LCAssetViewCellId forIndexPath:indexPath];
    LCAsset *asset = self.assetArray[indexPath.item];
    
    CGFloat photoWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat multiple = [UIScreen mainScreen].scale;
    
    CGFloat aspectRatio = asset.phAsset.pixelWidth / (CGFloat)asset.phAsset.pixelHeight;
    CGFloat pixelWidth = photoWidth * multiple;
    CGFloat pixelHeight = pixelWidth / aspectRatio;
    
    [[PHImageManager defaultManager] requestImageForAsset:asset.phAsset targetSize:CGSizeMake(pixelWidth, pixelHeight) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        cell.imageView.image = result;
    }];
    
    // 存储当前显示的图片和索引
    self.asset = asset;
    self.lastItem = indexPath.item;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 如果相等,代表cell没有更换
    if (indexPath.item == self.lastItem) return;
    LCAsset *asset = self.assetArray[self.lastItem];
    selectedButton.selected = asset.isSelected;
    
    // 滚动后,计算当前图片的大小
    if (self.originalButton.selected == YES) {
        [self.originalButton setTitle:[NSString stringWithFormat:@"原图(%@)", self.asset.bytes]forState:UIControlStateSelected];
    }
}

#pragma mark - AllButtonAction
- (void)clickOriginalButton:(UIButton *)button
{
    button.selected = !button.isSelected;
    
    // 点击后,计算当前图片的大小
    if (button.isSelected == YES) {
        [button setTitle:[NSString stringWithFormat:@"原图(%@)", self.asset.bytes]forState:UIControlStateSelected];
    }
}

- (void)clickBackButton
{
    if ([self.delegate respondsToSelector:@selector(assetViewController:selectedItemsInAssetViewController:)]) {
        [self.delegate assetViewController:self selectedItemsInAssetViewController:self.selectedItems];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickSenderButton
{
    if ([self.delegate respondsToSelector:@selector(assetViewController:didClickSenderButton:)]) {
        [self.delegate assetViewController:self didClickSenderButton:self.selectedItems];
    }
}

- (void)clickSelectedButton:(UIButton *)selectedButton
{
    BOOL selected = !selectedButton.isSelected;
    if (selected == YES) {
        if (self.selectedItems.count >= maxSelectedImageCount) {
            [MBProgressHUD showError:@"图片最多选择5张"];
            return;
        }
    }
    
    selectedButton.selected = !selectedButton.isSelected;
    
    // 当前显示的图片
    LCAsset *asset = self.assetArray[self.lastItem];
    asset.selected = selectedButton.isSelected;
    
    // 添加/删除
    if (asset.isSelected) {
        [self.selectedItems addObject:asset];
    } else {
        [self.selectedItems removeObject:asset];
    }
    
    [self updateSenderButtonStatus];
    
}
// 更新按钮的状态
- (void)updateSenderButtonStatus
{
    if (self.selectedItems.count == 0) {
        self.senderButton.enabled = NO;
    } else {
        self.senderButton.enabled = YES;
        [self.senderButton setTitle:[NSString stringWithFormat:@"(%ld)发送", self.selectedItems.count] forState:UIControlStateNormal];
    }
}
@end
