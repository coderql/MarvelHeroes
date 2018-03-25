//
//  MSHImageCache.h
//  MarvelHeroes
//
//  Created by Leo on 2018/3/24.
//  Copyright © 2018年 leo. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Encapsualte image cache for both memory and disk cache.
 *
 * Potential enhancement:
 * 1. Current implemention enables memory and disk by default, we can add options to control.
 * 2. handle low memory situation.
 */
@interface MSHImageCache : NSObject
+ (nonnull instancetype)sharedInstance;
/**
 * Store image data in memory and disk.
 *
 * @param imageData image data to store.
 * @param key cache key
 */
- (void)storeImage:(nonnull NSData *)imageData key:(nonnull NSString *)key;

/**
 * Fetch image data from cache.
 * First find from memory cache, if memory cache doesn't contain this key,
 * then find from disk.
 *
 * @param key cache key
 *
 * @return cached image data
 */
- (nullable NSData *)getImageForKey:(nonnull NSString *)key;

/**
 * Remove image data from cache.
 *
 * @param key cache key
 */
- (void)removeImageForKey:(nonnull NSString *)key;
@end
