//
//  LCAssetViewController.h
//  weChat
//
//  Created by Lc on 16/3/29.
//  Copyright © 2016年 LC. All rights reserved.
//

#import <UIKit/UIKit.h>
#define maxSelectedImageCount 5
@class LCAssetViewController;

@protocol LCAssetViewControllerDelegate <NSObject>

@required
// 点击返回后执行
- (void)assetViewController:(LCAssetViewController *)assetViewController selectedItemsInAssetViewController:(NSMutableArray *)selectedItems;

// 点击发送按钮
- (void)assetViewController:(LCAssetViewController *)assetViewController didClickSenderButton:(NSMutableArray *)selectedItems;

@end

@interface LCAssetViewController : UIViewController
/**
 *  显示第一张图片的索引
 */
@property (assign, nonatomic) NSInteger index;

/**
 *  显示图片的数组
 */
@property (strong, nonatomic) NSMutableArray *assetArray;

/**
 *  选中图片的数组
 */
@property (strong, nonatomic) NSMutableArray *selectedItems;

@property (weak, nonatomic) id<LCAssetViewControllerDelegate> delegate;

@end
