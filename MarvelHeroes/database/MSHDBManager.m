//
//  MSHDBManager.m
//  MarvelHeroes
//
//  Created by Leo on 2018/3/25.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "MSHDBManager.h"
#import <sqlite3.h>

@interface MSHDBManager ()
{
    sqlite3 *db;
}
@end

@implementation MSHDBManager

+ (nonnull instancetype)manager {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        if ([self open]) {
            [self initTable];
        }
    }
    return self;
}

- (BOOL)open {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *databasePath = [documents stringByAppendingPathComponent:@"heroes"];
    return sqlite3_open([databasePath UTF8String], &db) == SQLITE_OK;
}

- (BOOL)initTable {
    NSString *createSql = @"create table if not exists hero(hero_id integer)";
    return [self execute:createSql];
}

- (BOOL)execute:(NSString *)sql {
    return sqlite3_exec(db, [sql UTF8String], nil, nil, nil) == SQLITE_OK;
}

- (BOOL)close {
    return sqlite3_close(db) == SQLITE_OK;
}

- (BOOL)favorHero:(int)heroId {
    NSString *insertSql = [NSString stringWithFormat:@"insert into hero(hero_id) values(%d)", heroId];
    return [self execute:insertSql];
}

- (BOOL)unfavorHero:(int)heroId {
    NSString *removeSql = [NSString stringWithFormat:@"delete from hero where hero_id = %d", heroId];
    return [self execute:removeSql];
}

- (NSArray *)findFavoredHeroes:(NSArray *)heroIds {
    NSMutableArray *favoredHeroIds = [NSMutableArray new];
    
    sqlite3_stmt *stmt;
    NSString *heroIdsStr = [heroIds componentsJoinedByString:@","];
    NSString *querySql = [NSString stringWithFormat:@"select hero_id from hero where hero_id in (%@)", heroIdsStr];
    if (sqlite3_prepare_v2(db, [querySql UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            int favoredHeroId = sqlite3_column_int(stmt, 0);
            [favoredHeroIds addObject:[NSNumber numberWithInt:favoredHeroId]];
        }
    }
    sqlite3_finalize(stmt);
    return favoredHeroIds;
}

@end
