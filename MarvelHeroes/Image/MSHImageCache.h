//
//  MSHImageCache.h
//  MarvelHeroes
//
//  Created by Leo on 2018/3/24.
//  Copyright © 2018年 leo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSHImageCache : NSObject
+ (nonnull instancetype)sharedInstance;
- (void)storeImage:(nullable NSData *)imageData key:(nonnull NSString *)key;
- (nullable NSData *)getImageForKey:(nonnull NSString *)key;
@end
