//
//  LCNewsViewController.m
//  weChat
//
//  Created by Lc on 16/5/6.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LCNewsViewController.h"
#import "LCNewsCell.h"
#import "LCNews.h"

#define defaultImageH 200
#define refreshViewWH 30
#define refreshViewMaxY 100
@interface LCNewsViewController ()<LCNewsCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHightConstraint;
@property (strong, nonatomic) NSMutableArray *newsSource;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) UIImageView *refreshView;
@property (strong, nonatomic) LCNewsCell *newsCellTool;
@property (assign, nonatomic)  CGFloat refreshViewY;
@property (assign, nonatomic, getter=isRefreshing) BOOL refreshing;
@end

@implementation LCNewsViewController
static NSString * const LCNewsCellID = @"LCNewsCellID";

- (NSMutableArray *)newsSource
{
    if (!_newsSource) {
        _newsSource = [NSMutableArray array];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"news.plist" ofType:nil];
        NSArray *arr = [NSArray arrayWithContentsOfFile:path];
        for (NSDictionary *dict in arr) {
            LCNews *news = [LCNews newsWithDict:dict];
            
            [_newsSource addObject:news];
        }
        
    }
    
    return _newsSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"朋友圈";
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCNewsCell class]) bundle:nil] forCellReuseIdentifier:LCNewsCellID];
    self.tableView.contentInset = UIEdgeInsetsMake(defaultImageH, 0, 0, 0);
    self.newsCellTool = [self.tableView dequeueReusableCellWithIdentifier:LCNewsCellID];
    
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AlbumReflashIcon"]];
    imageV.frame = CGRectMake(10, 0, refreshViewWH, refreshViewWH);
    self.refreshView = imageV;
    [self.headerImageView addSubview:self.refreshView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.newsSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LCNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:LCNewsCellID];
    
    cell.news = self.newsSource[indexPath.row];
    cell.indexPath = indexPath;
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LCNews *news = self.newsSource[indexPath.row];
    return news.cellHeight;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    CGFloat delta = offsetY + defaultImageH;
    
    CGFloat height = defaultImageH - delta;
    
    if (height < 0) height = 0;
    
    self.imageViewHightConstraint.constant = height;
    
    self.refreshViewY = -offsetY - defaultImageH -refreshViewWH;
    if (self.refreshViewY >= refreshViewMaxY) self.refreshViewY = refreshViewMaxY;
    
    if (self.refreshing) return;
    
    CGFloat rotateValue = offsetY / 50.0 * M_PI;
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, 0, self.refreshViewY);
    transform = CGAffineTransformRotate(transform, rotateValue);
    self.refreshView.transform = transform;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    
    if (self.refreshing) return;
    
    if (self.refreshViewY >= refreshViewMaxY) {
        self.refreshing = YES;
    
        CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 10.0 ];
        rotationAnimation.duration = 3.5f;
        [self.refreshView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"news.plist" ofType:nil];
        NSArray *arr = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *tempArr = [NSMutableArray array];
        for (NSDictionary *dict in arr) {
            LCNews *news = [LCNews newsWithDict:dict];
            [tempArr addObject:news];
        }
        
        for (int i = 0; i < 5; i++) {
            [self.newsSource insertObject:tempArr[arc4random_uniform(20)] atIndex:0];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.refreshing = NO;
            [self.refreshView.layer removeAnimationForKey:@"rotationAnimation"];
            [UIView animateWithDuration:0.3 animations:^{
                self.refreshView.transform = CGAffineTransformIdentity;
                [self.tableView reloadData];
            }];
        });
    }
}


#pragma mark - LCNewsCellDelegate
- (void)newsCell:(LCNewsCell *)newsCell didClickMoreTextButtonWithIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}
@end
