//
//  MSHImageManager.m
//  MarvelHeroes
//
//  Created by Leo on 2018/3/24.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "MSHImageManager.h"

@implementation MSHImageManager
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
        _imageCache = [MSHImageCache sharedInstance];
        _downloadManager = [MSHImageDownloadManager sharedInstance];
    }
    return self;
}

- (void)loadImageURL:(nonnull NSURL *)url completion:(nonnull ImageLoadCompletionBlock)completionBlock {
    NSString *key = [url absoluteString];
    NSData *imageData = [self.imageCache getImageForKey:key];
    if (imageData != nil) {
        completionBlock(imageData, nil);
    } else {
        [self.downloadManager downloadImageWithURL:url completed:^(NSData * _Nullable data, NSError * _Nullable error) {
            completionBlock(data, error);
        }];
    }
}
@end
