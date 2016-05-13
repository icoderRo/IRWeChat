//
//  LCAssetGridViewController.h
//  weChat
//
//  Created by Lc on 16/3/29.
//  Copyright © 2016年 LC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCAssetGridViewController;

@protocol LCAssetGridViewControllerDelegate <NSObject>

@required
// 点击发送按钮
- (void)assetGridViewController:(LCAssetGridViewController *)assetGridViewController didSenderImages:(NSMutableArray *)imageArray;

@end

@interface LCAssetGridViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *allPhotos;

@property (weak, nonatomic) id<LCAssetGridViewControllerDelegate> delegate;

@end
