//
//  MSHMarvelHeroService.m
//  MarvelHeroes
//
//  Created by Leo on 2018/3/22.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "MSHMarvelHeroService.h"
#import "MSHHttpManager.h"
#import "NSString+MD5.h"
#import "MSHPageInfo.h"
#import "MSHHero.h"
#import "MSHEntity.h"

NSString * const MarvelPublicKey = @"7d05b4ede034e8f3531bd645720aab60";
NSString * const MarvelPrivateKey = @"7b198ec313706c17d38f1fb21e0c268572b9cb2c";
NSString * const MarvelBasePath = @"https://gateway.marvel.com/v1/public/";
NSString * const kHeroContextPath = @"characters";
NSString * const kComicsContextPath = @"comics";
NSString * const kEventsContextPath = @"events";
NSString * const kSeriesContextPath = @"series";
NSString * const kStoriesContextPath = @"stories";

@implementation MSHMarvelHeroService

- (NSString *)getHeroThumbnailURL:(MSHThumbnail *)thumbnail {
    return [NSString stringWithFormat:@"%@/%@.%@", thumbnail.path, thumbnail.variant, thumbnail.extension];
}

- (void)getHeroesOffset:(int)offset limit:(int)limit nameStartsWith:(NSString *)startName resultHandler:(MSHResultHandler)handler {
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setObject:[NSNumber numberWithInt:offset] forKey:@"offset"];
    [parameters setObject:[NSNumber numberWithInt:limit] forKey:@"limit"];
    if (startName != nil) {
        [parameters setObject:startName forKey:@"nameStartsWith"];
    }
    [self paginationReqRelativePath:kHeroContextPath extraParam:parameters resultHandler:handler successHandler:^NSArray *(NSArray *results) {
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
    [self getEntities:kComicsContextPath hero:heroId offset:offset limit:limit resultHandler:handler];
}

- (void)getEventsOfHero:(int)heroId offset:(int)offset limit:(int)limit resultHandler:(MSHResultHandler)handler {
    [self getEntities:kEventsContextPath hero:heroId offset:offset limit:limit resultHandler:handler];
}

- (void)getStoriesOfHero:(int)heroId offset:(int)offset limit:(int)limit resultHandler:(MSHResultHandler)handler {
    [self getEntities:kSeriesContextPath hero:heroId offset:offset limit:limit resultHandler:handler];
}

- (void)getSeriesOfHero:(int)heroId offset:(int)offset limit:(int)limit resultHandler:(MSHResultHandler)handler {
    [self getEntities:kStoriesContextPath hero:heroId offset:offset limit:limit resultHandler:handler];
}

/**
 * Common methods for events/stories/comics/stories retrival.
 *
 * @param entityPath entity context path.
 * @param heroId hero id.
 * @param offset from which index to get heroes
 * @param limit number of heroes to get
 * @param handler result callback
 */
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
                             [entity setValuesForKeysWithDictionary:entityDic];
                             [entityArray addObject:entity];
                         }
                         return entityArray;
                     }];
}

/**
 * Common methods for pagination request.
 *
 * @param contextPath request context path
 * @param extraParam extra parameters of different request.
 * @param handler original result handler.
 * @param successHandler handle successful response data.
 */
- (void)paginationReqRelativePath:(NSString *)contextPath extraParam:(NSDictionary *)extraParam resultHandler:(MSHResultHandler)handler successHandler:(NSArray *(^)(NSArray *))successHandler {
    NSMutableDictionary *parameters = [self prepareParameters];
    [parameters addEntriesFromDictionary:extraParam];
    
    NSString *requestPath = [NSString stringWithFormat:@"%@%@", MarvelBasePath, contextPath];
    [[MSHHttpManager manager] httpGet:requestPath parameters:parameters success:^(NSURLSessionDataTask *task, NSData *data) {
        NSDictionary *jsonObject = (NSDictionary *) [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        int code = [[jsonObject objectForKey:@"code"] intValue];
        NSString *status = [jsonObject objectForKey:@"status"];
        if (code != 200) {
            MSHLog(@"%@ code=%d, status=%@", requestPath, code, status);
            if (handler) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler(nil, [NSError errorWithDomain:@"" code:code userInfo:@{@"status": status}]);
                });
            }
        } else {
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
            if (handler) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler(pageInfo, nil);
                });
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (handler) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(nil, error);
            });
        }
    }];
}

/**
 * Prepare http parameters: hash, apikey and ts.
 */
- (NSMutableDictionary *)prepareParameters {
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    // use long in millis value for timestamp
    NSString *ts = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970] * 1000];
    [parameters setObject:[self getHashParam:ts] forKey:@"hash"];
    [parameters setObject:MarvelPublicKey forKey:@"apikey"];
    [parameters setObject:ts forKey:@"ts"];
    return parameters;
}

/**
 * Compute request hash value.
 *
 * @param ts current timestamp.
 * @return request hash value.
 */
- (NSString *)getHashParam:(NSString *)ts {
    return [[NSString stringWithFormat:@"%@%@%@", ts, MarvelPrivateKey, MarvelPublicKey] MD5];
}


@end
