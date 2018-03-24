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
+ (instancetype)manager {
    return [[[self class] alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.session = [NSURLSession sharedSession];
    return self;
}

- (NSURLSessionDataTask *)httpGet:(NSString *)path
                   parameters:(NSDictionary *)parameters
                      success:(void (^)(NSURLSessionDataTask * _Nonnull, NSData *))success
                          failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    NSString *urlString = nil;
    if (self.baseURL != nil) {
        urlString = [[NSURL URLWithString:path relativeToURL:self.baseURL] absoluteString];
    } else {
        urlString = path;
    }
    NSString *queryString = [MSHHttpSessionManager queryStringFromDic:parameters];
    if (queryString != nil) {
        urlString = [urlString stringByAppendingFormat:@"?%@", queryString];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    [request setHTTPMethod:@"GET"];
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            failure(dataTask, error);
        } else {
            success(dataTask, data);
        }
    }];
    [dataTask resume];
    return dataTask;
}

+ (NSString *)queryStringFromDic:(NSDictionary *)parameters {
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
