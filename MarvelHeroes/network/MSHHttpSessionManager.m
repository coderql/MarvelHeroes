//
//  MSHHttpSessionManager.m
//  MarvelHeroes
//
//  Created by Leo on 2018/3/22.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "MSHHttpSessionManager.h"

@interface MSHHttpSessionManager ()
@property (readwrite, nonatomic, strong, nullable) NSURL *baseURL;
@end

@implementation MSHHttpSessionManager
+ (nonnull instancetype)manager {
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
        _session = [NSURLSession sharedSession];
    }
    return self;
}

- (NSURLSessionDataTask *)httpGet:(NSString *)path
                   parameters:(NSDictionary *)parameters
                      success:(void (^)(NSURLSessionDataTask * _Nonnull, NSData * _Nonnull))success
                          failure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failure {
    NSString *urlString = nil;
    if (self.baseURL != nil) {
        // if base URL is provided, the given path parameter is relative path.
        urlString = [[NSURL URLWithString:path relativeToURL:self.baseURL] absoluteString];
    } else {
        urlString = path;
    }
    
    NSString *queryString = [self queryStringFromDic:parameters];
    if (queryString != nil) {
        urlString = [urlString stringByAppendingFormat:@"?%@", queryString];
    }
    
    // since Marval API supports ETag,
    // use NSURLRequestUseProtocolCachePolicy cache policy to support etag automatically.
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    [request setHTTPMethod:@"GET"];
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self.session dataTaskWithRequest:request
                               completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            failure(dataTask, error);
        } else {
            success(dataTask, data);
        }
    }];
    [dataTask resume];
    return dataTask;
}

/**
 * convert query parameter in dictionary to key=value pair strings.
 *
 * @param parameters key/value pairs in query parameters.
 *
 * @return query string in url
 */
- (NSString *)queryStringFromDic:(NSDictionary *)parameters {
    if (parameters != nil && [parameters count] > 0) {
        NSMutableArray *queryArr = [NSMutableArray new];
        for (NSString *key in parameters) {
            [queryArr addObject:[NSString stringWithFormat:@"%@=%@", key, parameters[key]]];
        }
        return [queryArr componentsJoinedByString:@"&"];
    } else {
        return nil;
    }
}
@end
