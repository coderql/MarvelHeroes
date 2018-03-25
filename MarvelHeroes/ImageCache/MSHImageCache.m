//
//  MSHImageCache.m
//  MarvelHeroes
//
//  Created by Leo on 2018/3/24.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "MSHImageCache.h"
#import "NSString+MD5.h"
#import <UIKit/UIKit.h>

@interface MSHImageCache ()
@property (strong, nonatomic, nonnull) NSCache *memCache;
@property (strong, nonatomic, nonnull) NSString *diskCachePath;
@property (strong, nonatomic, nonnull) NSFileManager *fileManager;
@end

@implementation MSHImageCache
#pragma initialization
+ (nonnull instancetype)sharedInstance {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSArray<NSString *> *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        _diskCachePath = [paths[0] stringByAppendingPathComponent:@"mshcache"];
        MSHLog(@"disk cache path: %@", _diskCachePath);
        _fileManager = [NSFileManager new];
        
        _memCache = [NSCache new];
    }
    return self;
}

#pragma interface implementation
- (void)storeImage:(nonnull NSData *)imageData key:(nonnull NSString *)key {
    MSHLog(@"store image data to memory for key: %@", key);
    [self.memCache setObject:imageData forKey:key];
    MSHLog(@"store image data to disk for key: %@", key);
    [self storeImageToDisk:imageData key:key];
}

- (nullable NSData *)getImageForKey:(nonnull NSString *)key {
    NSData *data = [self memImageForKey:key];
    if (data != nil) {
        MSHLog(@"hit memory cache for key: %@", key);
        return data;
    }
    
    data = [self diskImageForKey:key];
    if (data != nil) {
        [self.memCache setObject:data forKey:key];
        MSHLog(@"hit disk cache for key: %@", key);
    } else {
        MSHLog(@"hit cache miss for key: %@", key);
    }
    return data;
}

- (void)removeImageForKey:(nonnull NSString *)key {
    [self.memCache removeObjectForKey:key];
    NSString *diskPath = [self cacheDiskPathForKey:key];
    if ([self.fileManager removeItemAtPath:diskPath error:nil]) {
        MSHLog(@"remove disk cache(key=%@) succeed.", key);
    } else {
        MSHLog(@"remove disk cache(key=%@) failed.", key);
    }
}

#pragma disk cache
/**
 * Generate file name for the given cache key.
 *
 * @param cacheKey cache key
 */
- (nonnull NSString *)cachedDiskNameForKey:(nonnull NSString *)cacheKey {
    return [cacheKey MD5];
}

/**
 * Get disk path for the given key.
 *
 * @param cacheKey cache key.
 * @return full file path for the given key.
 */
- (nonnull NSString *)cacheDiskPathForKey:(nonnull NSString *)cacheKey {
    NSString *filename = [self cachedDiskNameForKey:cacheKey];
    return [self.diskCachePath stringByAppendingPathComponent:filename];
}

/**
 * store image data to disk. ignore failure condition, try next time.
 *
 * @param imageData data to store.
 * @param key cache key
 */
- (void)storeImageToDisk:(nonnull NSData *)imageData key:(nonnull NSString *)key {
    if (![self.fileManager fileExistsAtPath:self.diskCachePath]) {
        if (![self.fileManager createDirectoryAtPath:self.diskCachePath withIntermediateDirectories:YES attributes:nil error:NULL]) {
            MSHLog(@"create directory(%@) failed.", self.diskCachePath);
            return;
        }
    }
    NSString *cachePath = [self cacheDiskPathForKey:key];
    NSURL *cacheFileUrl = [NSURL fileURLWithPath:cachePath];
    if ([imageData writeToURL:cacheFileUrl atomically:YES]) {
        MSHLog(@"store key(%@)'s data to %@ succeeed.", key, cachePath);
    } else {
        MSHLog(@"store key(%@)'s data to %@ succeeed.", key, cachePath);
    }
}

/**
 * Is data stored on disk for the given key.
 *
 * @param key cache key
 * @return is data stored.
 */
- (BOOL)isDiskExistsForKey:(nonnull NSString *)key {
    NSString *cachePath = [self cacheDiskPathForKey:key];
    return [self.fileManager fileExistsAtPath:cachePath];
}

/**
 * Get image data on disk for the given key.
 *
 * @param key cache key
 * @return data on disk for the key.
 */
- (nullable NSData *)diskImageForKey:(nonnull NSString *)key {
    NSString *defaultPath = [self cacheDiskPathForKey:key];
    return [NSData dataWithContentsOfFile:defaultPath options:0 error:nil];
}

#pragma memory cache
/**
 * Get image data from memory for the given key.
 *
 * @param key cache key
 * @return data stored in memory for the key.
 */
- (nullable NSData *)memImageForKey:(nonnull NSString *)key {
    return [self.memCache objectForKey:key];
}
@end
