//
//  LCAssetGridCell.h
//  weChat
//
//  Created by Lc on 16/3/29.
//  Copyright © 2016年 LC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCAssetGridCell, LCAsset;

@protocol LCAssetGridCellDelegate <NSObject>

@required
- (void)assetGridCell:(LCAssetGridCell *)assetGridCell isSelected:(BOOL)selected isNeedToAdd: (void (^)(BOOL add))add;

@end

@interface LCAssetGridCell : UICollectionViewCell

@property (weak, nonatomic) id<LCAssetGridCellDelegate> delegate;

@property (strong, nonatomic) LCAsset *asset;

@end
