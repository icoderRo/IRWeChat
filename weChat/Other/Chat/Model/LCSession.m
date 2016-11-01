//
//  LCSession.m
//  weChat
//
//  Created by Lc on 16/1/21.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LCSession.h"
#import <objc/runtime.h>

@implementation LCSession

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        unsigned int count = 0;
        Ivar *ivar = class_copyIvarList([self class], &count);
        
        for (int i = 0; i < count; i++) {
            
            Ivar iva = ivar[i];
            
            const char *name = ivar_getName(iva);
            
            NSString *stringName = [NSString stringWithUTF8String:name];
            
            id value = [decoder decodeObjectForKey:stringName];
            
            [self setValue:value forKey:stringName];
        }
        free(ivar);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    unsigned int count;
    Ivar *ivar = class_copyIvarList([self class], &count);
    
    for (int i = 0; i < count; i++) {
        
        Ivar iv = ivar[i];
        
        const char *name = ivar_getName(iv);
        
        NSString *stringName = [NSString stringWithUTF8String:name];
        
        id value = [self valueForKey:stringName];
        
        [encoder encodeObject:value forKey:stringName];
    }
    
    free(ivar);
}
@end