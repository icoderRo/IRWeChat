//
//  LCAssetGridTooBar.h
//  weChat
//
//  Created by Lc on 16/3/29.
//  Copyright © 2016年 LC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCAssetGridTooBar;

@protocol LCAssetGridTooBarDelegate <NSObject>

@required

- (void)didClickPreviewInAssetGridToolBar:(LCAssetGridTooBar *)assetGridToolBar;
- (void)didClickSenderButtonInAssetGridToolBar:(LCAssetGridTooBar *)assetGridToolBar;

@end

@interface LCAssetGridTooBar : UIView
@property (strong, nonatomic) NSMutableArray *selectedItems;

@property (weak, nonatomic) id<LCAssetGridTooBarDelegate> delegate;
@end
