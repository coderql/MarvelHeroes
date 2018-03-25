//
//  MSHImageManager.m
//  MarvelHeroes
//
//  Created by Leo on 2018/3/24.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "MSHImageManager.h"
@interface MSHImageManager ()
@property (strong, nonatomic, readonly, nullable) MSHImageCache *imageCache;
@property (strong, nonatomic, readonly, nullable) MSHImageDownloadManager *downloadManager;
@end

@implementation MSHImageManager
+ (nullable instancetype)manager {
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
        _imageCache = [MSHImageCache sharedInstance];
        _downloadManager = [MSHImageDownloadManager sharedInstance];
    }
    return self;
}

- (void)loadImageURL:(nonnull NSURL *)url completion:(nonnull ImageLoadCompletionBlock)completionBlock {
    NSString *key = [self keyForUrl:url];
    NSData *imageData = [self.imageCache getImageForKey:key];
    if (imageData != nil) {
        completionBlock(imageData, nil);
    } else {
        __weak __typeof(self) weakSelf = self;
        // if image is not stored in local cache(both memory and disk), download from server side.
        [self.downloadManager downloadImageWithURL:url completed:^(NSData * _Nullable data, NSError * _Nullable error) {
            // cache newly downloaded image data.
            [weakSelf.imageCache storeImage:data key:key];
            completionBlock(data, error);
        }];
    }
}

/**
 * Get cache key for url.
 * Since image url is fixed in Marvel api, absolute path is enough. For some other apis,
 * if there is changing path for a same image, we can add more logic to remove the changing part.
 */
- (NSString *)keyForUrl:(NSURL *)url {
    return [url absoluteString];
}
@end
