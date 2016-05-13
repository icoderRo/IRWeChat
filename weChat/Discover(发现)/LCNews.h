//
//  LCNews.h
//  weChat
//
//  Created by Lc on 16/5/6.
//  Copyright © 2016年 LC. All rights reserved.
//

#import <Foundation/Foundation.h>
#define messageDefaultHeight 78

@interface LCNews : NSObject

@property (copy, nonatomic) NSString *nickName;
@property (copy, nonatomic) NSString *time;
@property (copy, nonatomic) NSString *message;
@property (strong, nonatomic) NSArray *images;

@property (assign, nonatomic) CGFloat cellHeight;
@property (assign, nonatomic) CGFloat photoHeight;
@property (assign, nonatomic) CGFloat messageHeight;

@property (assign, nonatomic, getter=isOpened) BOOL open;
@property (assign, nonatomic, getter=isHidden) BOOL hidden;

+ (instancetype)newsWithDict:(NSDictionary *)dict;
@end
