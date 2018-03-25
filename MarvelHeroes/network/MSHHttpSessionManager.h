//
//  MSHHttpSessionManager.h
//  MarvelHeroes
//
//  Created by Leo on 2018/3/22.
//  Copyright © 2018年 leo. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * This class encapsulates http requests. For simplicity, only support HTTP GET.
 *
 */
@interface MSHHttpSessionManager : NSObject
@property (nonatomic, strong) NSURLSession * _Nonnull session;
@property (readonly, nonatomic, strong, nullable) NSURL *baseURL;

+ (nonnull instancetype)manager;
/**
 * Send HTTP GET request.
 *
 * @param path request path. if baseURL is provided, this can be relative path.
 * @param parameters query parameters that will be appended to url.
 * @param success callback for successful http get request.
 * @param failure callback for failed http get request.
 *
 * @return http get request session task.
 */
- (nullable NSURLSessionDataTask *)httpGet:(nonnull NSString *)path
                       parameters:(nullable NSDictionary *)parameters
                          success:(void (_Nullable ^)(NSURLSessionDataTask * _Nonnull, NSData * _Nonnull))success
                          failure:(void (_Nullable ^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failure;
@end
