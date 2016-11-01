//
//  LCPhotoBrowseView.h
//  weChat
//
//  Created by Lc on 16/3/30.
//  Copyright © 2016年 LC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCPhotoBrowseView : UIView
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) NSArray *datasource;

- (void)show;

@end
