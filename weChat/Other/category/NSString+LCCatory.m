//
//  NSString+LCCatory.m
//  weChat
//
//  Created by Lc on 16/3/29.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "NSString+LCCatory.h"
#import "LCTextAttachment.h"
#import "LCEmotion.h"

@implementation NSString (LCCatory)
+ (NSString *)imageCachesPathWithImageName:(NSString *)imageName
{
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    cachesPath = [NSString stringWithFormat:@"%@/senderOriginalImages/",cachesPath];
    cachesPath = [cachesPath stringByAppendingPathComponent:imageName];
    if(![[NSFileManager defaultManager] fileExistsAtPath:[cachesPath stringByDeletingLastPathComponent]]){
        [[NSFileManager defaultManager] createDirectoryAtPath:[cachesPath stringByDeletingLastPathComponent]
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    return cachesPath;
}
+ (NSString *)recordPathWithfileName:(NSString *)fileName
{
    NSString *recordPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    recordPath = [NSString stringWithFormat:@"%@/records/",recordPath];
    recordPath = [recordPath stringByAppendingPathComponent:fileName];
    if(![[NSFileManager defaultManager] fileExistsAtPath:[recordPath stringByDeletingLastPathComponent]]){
        [[NSFileManager defaultManager] createDirectoryAtPath:[recordPath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return recordPath;
}

+ (NSString *)recordFileName
{
    int x = arc4random() % 100000;
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *fileName = [NSString stringWithFormat:@"%d%d",(int)time,x];
    return fileName;
}

- (NSAttributedString *)emotionStringWithWH:(CGFloat)WH
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"emotions" ofType:@"plist"];
    NSMutableArray *emotions = [NSMutableArray array];
    for (NSArray *arr in [[NSArray alloc] initWithContentsOfFile:path]) {
        for (NSDictionary *dict in arr) {
            LCEmotion *emotion = [LCEmotion emotionWithDict:dict];
            [emotions addObject:emotion];
        }
    }
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self];
    NSString * pattern = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    NSError *error = nil;
    NSRegularExpression * re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *resultArray = [re matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:resultArray.count];
    
    for(NSTextCheckingResult *match in resultArray) {
        NSRange range = [match range];
        NSString *subStr = [self substringWithRange:range];
        
        for (int i = 0; i < emotions.count; i ++)
        {
            LCEmotion *emotion = emotions[i];
            if ([emotion.chs isEqualToString:subStr])
            {
                LCTextAttachment *textAttachment = [[LCTextAttachment alloc] init];
                textAttachment.bounds = CGRectMake(0, -4, WH, WH);
                textAttachment.emotion = emotion;
                
                NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
                
                NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithCapacity:2];
                [imageDic setObject:imageStr forKey:@"image"];
                [imageDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
                
                [imageArray addObject:imageDic];
                
            }
        }
    }
    
    for (NSInteger i = imageArray.count -1; i >= 0; i--)
    {
        NSRange range;
        [imageArray[i][@"range"] getValue:&range];
        [attributeString replaceCharactersInRange:range withAttributedString:imageArray[i][@"image"]];
        
    }
    
    return attributeString;
    
}

- (NSString *)timeString
{
    NSDate *currentDate = [NSDate date];
    NSDateComponents *currentComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
    
    NSDate *messageDate = [NSDate dateWithTimeIntervalSince1970:[self longLongValue]/1000.0];
    NSDateComponents * messageComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:messageDate];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    if (currentComponents.year == messageComponents.year
        && currentComponents.month == messageComponents.month
        && currentComponents.day == messageComponents.day) {
        
        dateFormatter.dateFormat= @"HH:mm";
        
    }else if(currentComponents.year == messageComponents.year
             && currentComponents.month == messageComponents.month
             && currentComponents.day - 1 == messageComponents.day){
        
        dateFormatter.dateFormat= @"昨天 HH:mm";
        
    }else{
        
        dateFormatter.dateFormat= @"yyy-MM-dd HH:mm";
    }
    
    return [dateFormatter stringFromDate:messageDate];
}
@end
