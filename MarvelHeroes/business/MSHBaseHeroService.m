//
//  MSHBaseHeroService.m
//  MarvelHeroes
//
//  Created by Leo on 2018/3/24.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "MSHBaseHeroService.h"
#import "MSHDBManager.h"

@implementation MSHBaseHeroService

- (void)favorHero:(int)heroId
    resultHandler:(nullable MSHResultHandler)handler {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL result = [[MSHDBManager manager] favorHero:heroId];
        if (handler)
            handler([NSNumber numberWithBool:result], nil);
    });
}

- (void)unfavorHero:(int)heroId
      resultHandler:(nullable MSHResultHandler)handler {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
        BOOL result = [[MSHDBManager manager] unfavorHero:heroId];
        if (handler)
            handler([NSNumber numberWithBool:result], nil);
    });
}

- (void)favoredHeros:(NSArray * _Nonnull)heroIds
       resultHandler:(nullable MSHResultHandler)handler {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
        if (handler)
            handler([[MSHDBManager manager] findFavoredHeroes:heroIds], nil);
    });
}

- (void)getHeroesOffset:(int)offset
                  limit:(int)limit
         nameStartsWith:(nullable  NSString *)startName
          resultHandler:(nullable MSHResultHandler)handler {
    AbstractMethodNotImplemented();
}

- (void)getComicsOfHero:(int)heroId
                 offset:(int)offset
                  limit:(int)limit
          resultHandler:(nullable MSHResultHandler)handler {
    AbstractMethodNotImplemented();
}

- (void)getEventsOfHero:(int)heroId
                 offset:(int)offset
                  limit:(int)limit
          resultHandler:(nullable MSHResultHandler)handler {
    AbstractMethodNotImplemented();
}

- (void)getStoriesOfHero:(int)heroId
                  offset:(int)offset
                   limit:(int)limit
           resultHandler:(nullable MSHResultHandler)handler {
    AbstractMethodNotImplemented();
}

- (void)getSeriesOfHero:(int)heroId
                 offset:(int)offset
                  limit:(int)limit
          resultHandler:(nullable MSHResultHandler)handler {
    AbstractMethodNotImplemented();
}

- (nonnull NSString *)getHeroThumbnailURL:(nonnull MSHThumbnail *)thumbnail {
    AbstractMethodNotImplemented();
}
@end
