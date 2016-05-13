//
//  LCEmotionView.m
//  weChat
//
//  Created by Lc on 16/3/29.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LCEmotionView.h"
#import "LCEmotionCell.h"
#import "LCEmotion.h"

@interface LCEmotionView ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *emotionArray;
@property (weak, nonatomic) UIView *emotionsBar;
@property (weak, nonatomic) UIPageControl *pageControl;
@property (assign, nonatomic) NSInteger lastItem;
@end

@implementation LCEmotionView
static NSString *const LCEmotionCellId = @"LCEmotionCellId";

#pragma mark - lazy

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.frame = CGRectMake(0, CGRectGetMaxY(self.collectionView.frame) - 5 , 0, 10);
        pageControl.centerX = self.centerX;
        pageControl.numberOfPages = self.emotionArray.count;
        pageControl.currentPage = 0;
        pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        
        [self addSubview:pageControl];
        _pageControl = pageControl;
    }
    
    return _pageControl;
}

- (UICollectionView *)collecView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(self.width, self.height - 45);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 0;
        
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height - 45) collectionViewLayout:flowLayout];
        
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.pagingEnabled = YES;
        collectionView.backgroundColor = colorf0fGrey;
        collectionView.showsHorizontalScrollIndicator = NO;
        
        [collectionView registerClass:[LCEmotionCell class] forCellWithReuseIdentifier:LCEmotionCellId];
        _collectionView = collectionView;
        [self addSubview:_collectionView];
    }
    
    return _collectionView;
}

- (UIView *)emotionsBar
{
    if (!_emotionsBar) {
        UIView *emotionBar = [[UIView alloc] init];
        emotionBar.frame = CGRectMake(0, CGRectGetMaxY(self.pageControl.frame) + 5, self.width, 40);
        emotionBar.backgroundColor = [UIColor whiteColor];
        _emotionsBar = emotionBar;
        [self addSubview:_emotionsBar];
        
        UIButton *senderButtom = [[UIButton alloc] init];
        senderButtom.frame = CGRectMake(self.emotionsBar.width - 50, 0, 50, self.emotionsBar.height);
        [senderButtom setTitleColor:LCColor(150, 150, 150) forState:UIControlStateNormal];
        [senderButtom.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [senderButtom setTitle:@"发送" forState:UIControlStateNormal];
        [senderButtom addTarget:self action:@selector(clickSenderButtom) forControlEvents:UIControlEventTouchUpInside];
        [self.emotionsBar addSubview:senderButtom];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(senderButtom.x - 1, 5, 1, self.emotionsBar.height - 13);
        lineView.backgroundColor = LCColor(188, 188, 188);
        [self.emotionsBar addSubview:lineView];
    }
    return _emotionsBar;
}

- (NSMutableArray *)emotionArray
{
    if (!_emotionArray) {
        _emotionArray = [NSMutableArray array];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"emotions" ofType:@"plist"];
        _emotionArray = [LCEmotion mj_objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    return _emotionArray;
}

- (void)clickSenderButtom
{
    if (self.didclickSenderEmotion) {
        self.didclickSenderEmotion();
    }
}

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = colorf0fGrey;
        [self collecView];
        [self pageControl];
        [self emotionsBar];
        
    }
    
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.emotionArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LCEmotionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LCEmotionCellId forIndexPath:indexPath];
    self.lastItem = indexPath.item;
    cell.emotions = self.emotionArray[indexPath.item];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == self.lastItem) return;
    self.pageControl.currentPage = self.lastItem;
}

// 阻止事件往上传,防止点击后键盘退出
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {}
@end
