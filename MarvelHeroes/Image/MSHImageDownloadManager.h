//
//  MSHImageDownloadManager.h
//  MarvelHeroes
//
//  Created by Leo on 2018/3/24.
//  Copyright © 2018年 leo. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^ImageDownloadCompleteBlock)(NSData * _Nullable data, NSError * _Nullable error);

@interface MSHImageDownloadManager : NSObject
+ (nonnull instancetype)sharedInstance;
- (void)downloadImageWithURL:(nullable NSURL *)url
                   completed:(nullable ImageDownloadCompleteBlock)completeBlock;
- (void)setMaxConcurrentDownloads:(NSInteger)maxDownloads;
@end
