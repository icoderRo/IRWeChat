//
//  LCPhotoBrowseCell.h
//  weChat
//
//  Created by Lc on 16/3/29.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LCAssetCell.h"
@class LCSession, LCPhotoBrowseCell;
@protocol LCPhotoBrowseCellDelegate <NSObject>

@required
- (void)photoBrowseCellEndZooming:(LCPhotoBrowseCell *)photoBrowseCell;

@end
@interface LCPhotoBrowseCell : UICollectionViewCell
@property (strong, nonatomic) LCSession *session;
@property (weak, nonatomic) id<LCPhotoBrowseCellDelegate> delegate;
@end
