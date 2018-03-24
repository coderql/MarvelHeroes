//
//  MSHMarvelHeroService.m
//  MarvelHeroes
//
//  Created by Leo on 2018/3/22.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "MSHMarvelHeroService.h"
#import "MSHHttpSessionManager.h"
#import "NSString+MD5.h"
#import "MSHPageInfo.h"
#import "MSHHero.h"
#import "MSHEntity.h"

NSString * const MarvelPublicKey = @"7d05b4ede034e8f3531bd645720aab60";
NSString * const MarvelPrivateKey = @"7b198ec313706c17d38f1fb21e0c268572b9cb2c";
NSString * const MarvelBasePath = @"https://gateway.marvel.com/v1/public/";

@implementation MSHMarvelHeroService

- (void)getHeroesOffset:(int)offset limit:(int)limit nameStartsWith:(NSString *)startName resultHandler:(MSHResultHandler)handler {
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setObject:[NSNumber numberWithInt:offset] forKey:@"offset"];
    [parameters setObject:[NSNumber numberWithInt:limit] forKey:@"limit"];
    if (startName != nil) {
        [parameters setObject:startName forKey:@"nameStartsWith"];
    }
    [self paginationReqRelativePath:@"characters" extraParam:parameters resultHandler:handler successHandler:^NSArray *(NSArray *results) {
        NSMutableArray *heroArray = [NSMutableArray new];
        for (NSDictionary *heroDic in results) {
            MSHHero *hero = [MSHHero new];
            hero.heroId = [heroDic[@"id"] intValue];
            hero.name = heroDic[@"name"];
            hero.desc = heroDic[@"description"];
            NSDictionary *thumbnailDic = heroDic[@"thumbnail"];
            MSHThumbnail *thumbnail = [MSHThumbnail new];
            thumbnail.path = thumbnailDic[@"path"];
            thumbnail.extension = thumbnailDic[@"extension"];
            hero.thumbnail = thumbnail;
            [heroArray addObject:hero];
        }
        return heroArray;
    }];
}

- (void)getComicsOfHero:(int)heroId offset:(int)offset limit:(int)limit resultHandler:(MSHResultHandler)handler {
    [self getEntities:@"comics" hero:heroId offset:offset limit:limit resultHandler:handler];
}

- (void)getEventsOfHero:(int)heroId offset:(int)offset limit:(int)limit resultHandler:(MSHResultHandler)handler {
    [self getEntities:@"events" hero:heroId offset:offset limit:limit resultHandler:handler];
}

- (void)getStoriesOfHero:(int)heroId offset:(int)offset limit:(int)limit resultHandler:(MSHResultHandler)handler {
    [self getEntities:@"series" hero:heroId offset:offset limit:limit resultHandler:handler];
}

- (void)getSeriesOfHero:(int)heroId offset:(int)offset limit:(int)limit resultHandler:(MSHResultHandler)handler {
    [self getEntities:@"stories" hero:heroId offset:offset limit:limit resultHandler:handler];
}

- (void)getEntities:(NSString *)entityPath hero:(int)heroId offset:(int)offset limit:(int)limit resultHandler:(MSHResultHandler)handler {
    NSDictionary *parameters = @{
                                 @"offset": [NSNumber numberWithInt:offset],
                                 @"limit": [NSNumber numberWithInt:limit],
                                 @"characterId": [NSNumber numberWithInt:heroId]
                                 };
    [self paginationReqRelativePath:[NSString stringWithFormat:@"characters/%d/%@", heroId, entityPath]
                         extraParam:parameters
                      resultHandler:handler
                     successHandler:^NSArray *(NSArray *results) {
                         NSMutableArray *entityArray = [NSMutableArray new];
                         for (NSDictionary * entityDic in results) {
                             MSHEntity *entity = [MSHEntity new];
                             entity.title = entityDic[@"title"];
                             entity.desc = entityDic[@"description"];
                             [entityArray addObject:entity];
                         }
                         return entityArray;
                     }];
}

- (void)paginationReqRelativePath:(NSString *)contextPath extraParam:(NSDictionary *)extraParam resultHandler:(MSHResultHandler)handler successHandler:(NSArray *(^)(NSArray *))successHandler {
    NSMutableDictionary *parameters = [self prepareParameters];
    [parameters addEntriesFromDictionary:extraParam];
    
    [[MSHHttpSessionManager manager] httpGet:[NSString stringWithFormat:@"%@%@", MarvelBasePath, contextPath] parameters:parameters success:^(NSURLSessionDataTask *task, NSData *data) {
        NSDictionary *jsonObject = (NSDictionary *) [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSDictionary *dataDic = [jsonObject objectForKey:@"data"];
        
        MSHPageInfo *pageInfo = [MSHPageInfo new];
        pageInfo.offset = [dataDic[@"offset"] intValue];
        pageInfo.limit = [dataDic[@"limit"] intValue];
        pageInfo.total = [dataDic[@"total"] intValue];
        pageInfo.count = [dataDic[@"count"] intValue];
        
        NSArray *results = dataDic[@"results"];
        if (results != nil && [results count] > 0) {
            pageInfo.data = successHandler(results);
        }
        handler(pageInfo, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        handler(nil, error);
    }];
}

- (NSMutableDictionary *)prepareParameters {
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    NSString *ts = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970] * 1000];
    [parameters setObject:[self getHashParam:ts] forKey:@"hash"];
    [parameters setObject:MarvelPublicKey forKey:@"apikey"];
    [parameters setObject:ts forKey:@"ts"];
    return parameters;
}

- (NSString *)getHashParam:(NSString *)ts {
    return [[NSString stringWithFormat:@"%@%@%@", ts, MarvelPrivateKey, MarvelPublicKey] MD5];
}
@end
