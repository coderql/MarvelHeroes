//
//  MSHImageDownloadOperation.h
//  MarvelHeroes
//
//  Created by Leo on 2018/3/24.
//  Copyright © 2018年 leo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSHImageDownloadManager.h"

@interface MSHImageDownloadOperation : NSOperation
- (nullable instancetype)initWithRequest:(nonnull NSURLRequest *)request
                                 session:(nonnull NSURLSession *)session;
- (void)addCompleteBlock:(nonnull ImageDownloadCompleteBlock)completeBlock;
@end
