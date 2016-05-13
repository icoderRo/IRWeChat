//
//  LCNewsCell.h
//  weChat
//
//  Created by Lc on 16/5/6.
//  Copyright © 2016年 LC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LCNews, LCNewsCell;

@protocol LCNewsCellDelegate <NSObject>

@required
- (void)newsCell:(LCNewsCell *)newsCell didClickMoreTextButtonWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface LCNewsCell : UITableViewCell
@property (strong, nonatomic) LCNews *news;
@property (assign, nonatomic) CGFloat cellHeight;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) id<LCNewsCellDelegate> delegate;
@end
