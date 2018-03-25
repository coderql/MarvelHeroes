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
- (instancetype)initWithRequest:(NSURLRequest *)request session:(NSURLSession *)session;
- (void)addCompleteBlock:(ImageDownloadCompleteBlock)completeBlock;
@end
