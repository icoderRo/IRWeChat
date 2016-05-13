//
//  LCMoreInputCell.m
//  weChat
//
//  Created by Lc on 16/4/18.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LCMoreInputCell.h"

#define column 4
#define row 2

@implementation LCMoreInputCell
- (void)setMoreInputViews:(NSArray *)moreInputViews
{
    _moreInputViews = moreInputViews;
    
    CGFloat width = 55;
    CGFloat height = width;
    
    CGFloat columnMargin = (self.contentView.width - width * column) / (column + 1);
    CGFloat rowMargin = (self.contentView.height - height * row) / (row + 1);
    
    for (int i = 0; i < self.moreInputViews.count; i++) {
        UIButton *button = [[UIButton alloc] init];
        
        CGFloat x = i % column * (width + columnMargin) + columnMargin;
        CGFloat y = i / column * (height + rowMargin) + rowMargin;
        button.frame = CGRectMake(x, y, width, height);
        
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.contentEdgeInsets = UIEdgeInsetsMake(60, 0, 0, 0);
        button.titleLabel.font = [UIFont systemFontOfSize:10];

        [button addTarget:self action:@selector(clickMoreInputViews:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", moreInputViews[i][@"png"]]] forState:UIControlStateNormal];
        [button setTitle:moreInputViews[i][@"name"] forState:UIControlStateNormal];
        
        [self.contentView addSubview:button];
    }
}

- (void)clickMoreInputViews:(UIButton *)button
{
    if ([button.titleLabel.text isEqualToString:@"照片"]) {
        if ([self.delegate respondsToSelector:@selector(didClickImageViewInMoreInputCell:)]) {
            [self.delegate didClickImageViewInMoreInputCell:self];
        }
    } else if ([button.titleLabel.text isEqualToString:@"拍摄"]){
        if ([self.delegate respondsToSelector:@selector(didClickCameraViewInMoreInputCell:)]) {
            [self.delegate didClickCameraViewInMoreInputCell:self];
        }
       
    } else if ([button.titleLabel.text isEqualToString:@"位置"]){
        if ([self.delegate respondsToSelector:@selector(didClickLocationViewInMoreInputCell:)]) {
            [self.delegate didClickLocationViewInMoreInputCell:self];
        }
    } else {
         LCLog(@"敬请期待");
    }
}

@end
