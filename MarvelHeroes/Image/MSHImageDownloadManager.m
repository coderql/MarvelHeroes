//
//  MSHImageDownloadManager.m
//  MarvelHeroes
//
//  Created by Leo on 2018/3/24.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "MSHImageDownloadManager.h"
#import "MSHImageDownloadOperation.h"

@interface MSHImageDownloadManager ()
@property (strong, nonatomic, nonnull) NSOperationQueue *downloadQueue;
@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic, nonnull) NSMutableDictionary<NSURL *, MSHImageDownloadOperation *> *operations;
@end

@implementation MSHImageDownloadManager
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
        _downloadQueue = [NSOperationQueue new];
        _downloadQueue.maxConcurrentOperationCount = 10;
        _operations = [NSMutableDictionary new];
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    return self;
}

- (void)setMaxConcurrentDownloads:(NSInteger)maxDownloads {
    self.downloadQueue.maxConcurrentOperationCount = maxDownloads;
}

- (NSInteger)maxConcurrentDownloads {
    return self.downloadQueue.maxConcurrentOperationCount;
}

- (void)downloadImageWithURL:(nullable NSURL *)url
                   completed:(nullable ImageDownloadCompleteBlock)completeBlock {
    MSHImageDownloadOperation *operation = [self.operations objectForKey:url];
    if (operation == nil) {
        NSURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
        operation = [[MSHImageDownloadOperation alloc] initWithRequest:request session:self.session];
        __weak typeof(self) wself = self;
        operation.completionBlock = ^ {
            [wself.operations removeObjectForKey:url];
        };
        [self.operations setObject:operation forKey:url];
        [self.downloadQueue addOperation:operation];
    }
    [operation addCompleteBlock:completeBlock];
}
@end
