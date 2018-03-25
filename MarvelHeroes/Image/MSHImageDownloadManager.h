//
//  MSHImageDownloadManager.h
//  MarvelHeroes
//
//  Created by Leo on 2018/3/24.
//  Copyright © 2018年 leo. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Callback block for image download completion */
typedef void(^ImageDownloadCompleteBlock)(NSData * _Nullable data, NSError * _Nullable error);

/**
 * Handles concurrent image download.
 */
@interface MSHImageDownloadManager : NSObject
+ (nonnull instancetype)sharedInstance;
/**
 * Enqueue image download operation.
 *
 * @param url image download url
 * @param completeBlock image download completion block
 */
- (void)downloadImageWithURL:(nullable NSURL *)url
                   completed:(nullable ImageDownloadCompleteBlock)completeBlock;
@end
