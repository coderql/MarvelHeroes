//
//  MSHImageManager.h
//  MarvelHeroes
//
//  Created by Leo on 2018/3/24.
//  Copyright © 2018年 leo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSHImageCache.h"
#import "MSHImageDownloadManager.h"
#import "MSHImageDownloadOperation.h"

/** callback block for loaded image */
typedef void(^ImageLoadCompletionBlock)(NSData * _Nullable data, NSError * _Nullable error);

/**
 * Image manager handles image load process from memory, disk and network.
 */
@interface MSHImageManager : NSObject
@property (strong, nonatomic, readonly, nullable) MSHImageCache *imageCache;
@property (strong, nonatomic, readonly, nullable) MSHImageDownloadManager *downloadManager;

+ (nonnull instancetype)manager;
/**
 * load image.
 *
 * @param url image url.
 * @param completionBlock load complete block.
 */
- (void)loadImageURL:(nonnull NSURL *)url completion:(nonnull ImageLoadCompletionBlock)completionBlock;
@end
