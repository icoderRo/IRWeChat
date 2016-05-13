//
//  LCCachesTool.m
//  weChat
//
//  Created by Lc on 16/4/12.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LCCachesTool.h"
#import "FMDB.h"
#import "LCSession.h"

@implementation LCCachesTool
static FMDatabaseQueue *_queue;
+ (void)setup
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"session.sqlite"];
    
    _queue = [FMDatabaseQueue databaseQueueWithPath:path];
    
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"create table if not exists t_session (messageIndex INTEGER primary key not null, session blob, messageType INTEGER);"];
    }];
}

+ (void)addSessions:(NSArray *)sessionArray
{
    for (LCSession *session in sessionArray) {
        [self addSession:session];
    }
}

+ (void)addSession:(LCSession *)session
{
    [self setup];
    
    [_queue inDatabase:^(FMDatabase *db) {
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:session];
        
        [db executeUpdate:@"insert or replace into t_session (messageIndex,session,messageType) values(?, ?, ?)", @(session.messageIndex),data,@(session.messageType)];
    }];
    
    [_queue close];
}

+ (NSArray *)selectSessionWithIndexParam:(NSDictionary *)param
{
    [self setup];
    
    __block NSMutableArray *sessionArray = nil;
    
    [_queue inDatabase:^(FMDatabase *db) {
        sessionArray = [NSMutableArray array];
        
        FMResultSet *rs = [db executeQuery:@"select * from t_session where messageIndex <= ? and messageIndex > ? order by messageIndex desc;", param[@"maxIndex"], param[@"minIndex"]];
        while (rs.next) {
            NSData *data = [rs dataForColumn:@"session"];
            LCSession *session = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [sessionArray addObject:session];
        }
    }];
    [_queue close];
    
    return sessionArray;
}

+ (NSArray *)selectSessionWithNumberParams:(NSDictionary *)param
{
    [self setup];
    
    __block NSMutableArray *sessionArray = nil;
    
    [_queue inDatabase:^(FMDatabase *db) {
        sessionArray = [NSMutableArray array];
        FMResultSet *rs = [db executeQuery:@"select * from sessionTable_%@ where messageIndex <= ? order by messageIndex desc limit 0,?;", param[@"maxIndex"], param[@"num"]];
        while (rs.next) {
            NSData *data = [rs dataForColumn:@"session"];
            LCSession *session = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [sessionArray addObject:session];
        }
    }];
    
    [_queue close];
    
    return [sessionArray copy];
}

@end
