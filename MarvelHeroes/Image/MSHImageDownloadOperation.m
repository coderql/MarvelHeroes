//
//  MSHImageDownloadOperation.m
//  MarvelHeroes
//
//  Created by Leo on 2018/3/24.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "MSHImageDownloadOperation.h"

@interface MSHImageDownloadOperation ()
@property (assign, nonatomic, getter = isExecuting) BOOL executing;
@property (assign, nonatomic, getter = isFinished) BOOL finished;
@property (strong, nonatomic, readwrite, nullable) NSURLSessionTask *dataTask;
@property (weak, nonatomic, nullable) NSURLSession *session;
@property (strong, nonatomic, readonly, nullable) NSURLRequest *request;
@property (strong, nonatomic, nonnull) NSMutableArray<ImageDownloadCompleteBlock> *completeBlockArray;
@end

@implementation MSHImageDownloadOperation
@synthesize executing = _executing;
@synthesize finished = _finished;

- (instancetype)initWithRequest:(NSURLRequest *)request session:(NSURLSession *)session {
    self = [super init];
    if (self) {
        _request = [request copy];
        _executing = NO;
        _finished = NO;
    }
    return self;
}

- (void)start {
    if (self.isCancelled) {
        self.finished = YES;
        return;
    }
    
    __weak __typeof__ (self) wself = self;
    self.dataTask = [self.session dataTaskWithRequest:_request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        for (ImageDownloadCompleteBlock completeBlock in wself.completeBlockArray) {
            completeBlock(data, error);
        }
    }];
    [self.dataTask resume];
    self.executing = YES;
}

- (BOOL)isConcurrent {
    return YES;
}

- (void)cancel {
    if (self.isFinished) return;
    [super cancel];
    [self.dataTask cancel];
    [self done];
}

- (void)done {
    self.finished = YES;
    self.executing = NO;
}

- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)addCompleteBlock:(ImageDownloadCompleteBlock)completeBlock {
    [self.completeBlockArray addObject:completeBlock];
}
@end
