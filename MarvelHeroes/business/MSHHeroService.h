//
//  MSHHeroService.h
//  MarvelHeroes
//
//  Created by Leo on 2018/3/22.
//  Copyright © 2018年 leo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MSHThumbnail;

typedef void (^MSHResultHandler)(id responseObject, NSError *error);

@protocol MSHHeroService <NSObject>

- (void)getHeroesOffset:(int)offset
                  limit:(int)limit
         nameStartsWith:(NSString *)startName
          resultHandler:(MSHResultHandler)handler;

- (void)getComicsOfHero:(int)heroId
                 offset:(int)offset
                  limit:(int)limit
          resultHandler:(MSHResultHandler)handler;

- (void)getEventsOfHero:(int)heroId
                 offset:(int)offset
                  limit:(int)limit
          resultHandler:(MSHResultHandler)handler;

- (void)getStoriesOfHero:(int)heroId
                  offset:(int)offset
                   limit:(int)limit
           resultHandler:(MSHResultHandler)handler;

- (void)getSeriesOfHero:(int)heroId
                 offset:(int)offset
                  limit:(int)limit
          resultHandler:(MSHResultHandler)handler;

- (NSString *)getHeroThumbnailURL:(MSHThumbnail *)thumbnail
                       imageParam:(NSDictionary *)imageParam;

- (BOOL)favor:(int)heroId;

- (BOOL)unfavor:(int)heroId;

- (NSArray*)favoredHeros:(NSArray *)heroIds;
@end
