//
//  LCAsset.h
//  weChat
//
//  Created by Lc on 16/2/19.
//  Copyright © 2016年 LC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface LCAsset : NSObject
@property (strong, nonatomic) PHAsset *phAsset;
@property (assign, nonatomic, getter=isSelected) BOOL selected;
@property (assign, nonatomic) CGSize assetGridThumbnailSize;
@property (assign, nonatomic) NSInteger dataLength;
@property (copy, nonatomic) NSString *bytes;

+ (instancetype)assetWith:(PHAsset *)phAsset;

@end
