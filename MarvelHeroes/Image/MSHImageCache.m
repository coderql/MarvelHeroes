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

- (void)storeImage:(nullable NSData *)imageData key:(nonnull NSString *)key {
    [self.memCache setObject:imageData forKey:key];
    
    [self storeImageToDisk:imageData key:key];
}

- (NSData *)getImageForKey:(nonnull NSString *)key {
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
    [self.fileManager removeItemAtPath:[self cacheDiskPathForKey:key] error:nil];
}

#pragma disk cache
- (nullable NSString *)cachedDiskNameForKey:(nullable NSString *)cacheKey {
    return [cacheKey MD5];
}

- (nullable NSString *)cacheDiskPathForKey:(nullable NSString *)cacheKey {
    NSString *filename = [self cachedDiskNameForKey:cacheKey];
    return [self.diskCachePath stringByAppendingPathComponent:filename];
}

- (void)storeImageToDisk:(nullable NSData *)imageData key:(nullable NSString *)key {
    if (![self.fileManager fileExistsAtPath:self.diskCachePath]) {
        [self.fileManager createDirectoryAtPath:self.diskCachePath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    NSString *cachePath = [self cacheDiskPathForKey:key];
    NSURL *cacheFileUrl = [NSURL fileURLWithPath:cachePath];
    [imageData writeToURL:cacheFileUrl atomically:YES];
}

- (BOOL)isDiskExistsForKey:(nonnull NSString *)key {
    NSString *cachePath = [self cacheDiskPathForKey:key];
    return [self.fileManager fileExistsAtPath:cachePath];
}

- (nullable NSData *)diskImageForKey:(nonnull NSString *)key {
    NSString *defaultPath = [self cacheDiskPathForKey:key];
    return [NSData dataWithContentsOfFile:defaultPath options:0 error:nil];
}

#pragma memory cache
- (nullable NSData *)memImageForKey:(nonnull NSString *)key {
    return [self.memCache objectForKey:key];
}
@end
