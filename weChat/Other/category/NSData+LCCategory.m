//
//  NSData+LCCategory.m
//  weChat
//
//  Created by Lc on 16/4/11.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "NSData+LCCategory.h"

@implementation NSData (LCCategory)
+ (NSData *)imageDataWithURL:(NSString *)imageURL
{
    NSData *imageData = nil;
    NSURL *url = [NSURL fileURLWithPath:imageURL];
    if ([imageURL hasPrefix:@"http:"]) {
        url = [NSURL URLWithString:imageURL];
    }
    BOOL isExit = [[SDWebImageManager sharedManager] diskImageExistsForURL:url];
    if (isExit) {
        NSString *cacheImageKey = [[SDWebImageManager sharedManager] cacheKeyForURL:url];
        if (cacheImageKey.length) {
            NSString *cacheImagePath = [[SDImageCache sharedImageCache] defaultCachePathForKey:cacheImageKey];
            if (cacheImagePath.length) {
                imageData = [NSData dataWithContentsOfFile:cacheImagePath];
            }
        }
    }
    return imageData;
}

//- (NSString *)cachesImageDataWithFileName:(NSString *)fileName
//{
//    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
//    cachesPath = [NSString stringWithFormat:@"%@/senderOriginalImages/",cachesPath];
//    cachesPath = [cachesPath stringByAppendingPathComponent:fileName];
//    
//    if(![[NSFileManager defaultManager] fileExistsAtPath:[cachesPath stringByDeletingLastPathComponent]]){
//        [[NSFileManager defaultManager] createDirectoryAtPath:[cachesPath stringByDeletingLastPathComponent]
//                                  withIntermediateDirectories:YES
//                                                   attributes:nil
//                                                        error:nil];
//    }
//    
//    [self writeToFile:cachesPath atomically:YES];
//    
//    return cachesPath;
//}

- (NSData *)compressImage:(UIImage *)image toMaxFileSize:(NSInteger)maxFileSize
{
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > maxFileSize && compression > maxCompression) {
        compression -= 0.2;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    return imageData;

}
@end
