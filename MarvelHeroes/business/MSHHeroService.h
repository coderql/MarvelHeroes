//
//  MSHHeroService.h
//  MarvelHeroes
//
//  Created by Leo on 2018/3/22.
//  Copyright © 2018年 leo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MSHThumbnail;

typedef void (^MSHResultHandler)(_Nullable id responseObject, NSError * _Nullable error);

/**
 * All hero services should conform to this protocol.
 * This protocol is designed for other hero implemention other than Marvel in the future.
 */
@protocol MSHHeroService <NSObject>
/**
 * Get hero list by page.
 *
 * @param offset from which index to get heroes
 * @param limit number of heroes to get
 * @param startName if provided, will find heroes whose name starts with the given one
 * @param handler result callback
 */
- (void)getHeroesOffset:(int)offset
                  limit:(int)limit
         nameStartsWith:(nullable  NSString *)startName
          resultHandler:(nullable MSHResultHandler)handler;

/**
 * Get comics list in which the given hero takes part in.
 *
 * @param heroId hero id
 * @param offset from which index to get heroes
 * @param limit number of heroes to get
 * @param handler result callback
 */
- (void)getComicsOfHero:(int)heroId
                 offset:(int)offset
                  limit:(int)limit
          resultHandler:(nullable MSHResultHandler)handler;

/**
 * Get events list in which the given hero takes part in.
 *
 * @param heroId hero id
 * @param offset from which index to get heroes
 * @param limit number of heroes to get
 * @param handler result callback
 */
- (void)getEventsOfHero:(int)heroId
                 offset:(int)offset
                  limit:(int)limit
          resultHandler:(nullable MSHResultHandler)handler;

/**
 * Get stories list in which the given hero takes part in.
 *
 * @param heroId hero id
 * @param offset from which index to get heroes
 * @param limit number of heroes to get
 * @param handler result callback
 */
- (void)getStoriesOfHero:(int)heroId
                  offset:(int)offset
                   limit:(int)limit
           resultHandler:(nullable MSHResultHandler)handler;

/**
 * Get series list in which the given hero takes part in.
 *
 * @param heroId hero id
 * @param offset from which index to get heroes
 * @param limit number of heroes to get
 * @param handler result callback
 */
- (void)getSeriesOfHero:(int)heroId
                 offset:(int)offset
                  limit:(int)limit
          resultHandler:(nullable MSHResultHandler)handler;

/**
 * Return hero thumbnail download url.
 * NOTE: download url should not be processed in view controller layer, it may be different
 * for different hero service implementation.
 *
 * @param thumbnail thumbnail information
 * @return image download url.
 */
- (nonnull NSString *)getHeroThumbnailURL:(nonnull MSHThumbnail *)thumbnail;

- (void)favorHero:(int)heroId
    resultHandler:(nullable MSHResultHandler)handler;

- (void)unfavorHero:(int)heroId
      resultHandler:(nullable MSHResultHandler)handler;

- (void)favoredHeros:(NSArray * _Nonnull)heroIds
       resultHandler:(nullable MSHResultHandler)handler;

@end
