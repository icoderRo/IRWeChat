//
//  LCMoreInputCell.h
//  weChat
//
//  Created by Lc on 16/4/18.
//  Copyright © 2016年 LC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LCMoreInputCell;
@protocol LCMoreInputCellDelegate <NSObject>

@required
- (void)didClickImageViewInMoreInputCell:(LCMoreInputCell *)moreInputCell;
- (void)didClickCameraViewInMoreInputCell:(LCMoreInputCell *)moreInputCell;
- (void)didClickLocationViewInMoreInputCell:(LCMoreInputCell *)moreInputCell;
@end
@interface LCMoreInputCell : UICollectionViewCell
@property (strong, nonatomic) NSArray *moreInputViews;
@property (weak, nonatomic) id<LCMoreInputCellDelegate> delegate;
@end
