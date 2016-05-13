//
//  LCNews.m
//  weChat
//
//  Created by Lc on 16/5/6.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LCNews.h"
#import "LCPhotosView.h"

#define LCCommentMargin 10

static CGFloat width;
@implementation LCNews
+ (instancetype)newsWithDict:(NSDictionary *)dict
{
    LCNews *news = [[LCNews alloc] init];
    news.message = dict[@"message"];
    news.nickName = dict[@"nickName"];
    news.time = dict[@"time"];
    news.images = dict[@"images"];
    
    if (iPhone5 || iPhone4S) {
        width = 225;
    } else if(iPhone6s) {
        width = 280;
    } else if(iPhone6SP) {
        width = 330;
    }
    
    return news;
    
}

- (CGFloat)cellHeight
{
    if (!_cellHeight) {
        
        CGFloat nickNameH = [self.nickName boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]} context:nil].size.height;
        _cellHeight += LCCommentMargin + nickNameH;
        
        CGFloat messageH = [self.message boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.1]} context:nil].size.height;
        self.hidden = YES;
        if (messageH >= messageDefaultHeight) {
            self.hidden = NO;
            _cellHeight += 30;
            
            if (self.isOpened == NO) {
                 messageH = messageDefaultHeight;
            }
        }
        
        self.messageHeight = messageH;
        _cellHeight += LCCommentMargin + messageH;
        
        UIImage *image = nil;
        if (self.images.count == 1) {
           image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", self.images[0]]];
        }
        CGFloat photoH = [LCPhotosView photosViewSizeWithPhotosCount:self.images.count image:image].height;
        self.photoHeight = photoH;
        
        _cellHeight += LCCommentMargin + photoH;
        
         CGFloat timeH = [self.time boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil].size.height;
        _cellHeight += LCCommentMargin + timeH + 3 * LCCommentMargin;
        
    }
    
    return _cellHeight;
}
@end
