//
//  MSHHttpSessionManager.h
//  MarvelHeroes
//
//  Created by Leo on 2018/3/22.
//  Copyright © 2018年 leo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSHHttpSessionManager : NSObject
@property (nonatomic, strong) NSURLSession * _Nonnull session;
@property (readonly, nonatomic, strong, nullable) NSURL *baseURL;
+ (instancetype)manager;
- (NSURLSessionDataTask *)httpGet:(NSString *)relativePath
                       parameters:(NSDictionary *)parameters
                          success:(void (^)(NSURLSessionDataTask * _Nonnull, NSData *))success
                          failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure;
@end
