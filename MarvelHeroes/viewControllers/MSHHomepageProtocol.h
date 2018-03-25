//
//  MSHHomepageProtocol.h
//  MarvelHeroes
//
//  Created by Leo on 2018/3/24.
//  Copyright © 2018年 leo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MSHPageInfo;

@protocol MSHHomepageProtocol <NSObject>

- (void)loadSuccess:(MSHPageInfo *)pageInfo
        isFirstPage:(BOOL)isFirstPage
         noMoreData:(BOOL)isNoMoreData;
- (void)loadFailure:(NSError *)error
        isFirstPage:(BOOL)isFirstPage;
- (void)searchSuccess:(MSHPageInfo *)pageInfo
          isFirstPage:(BOOL)isFirstPage
           noMoreData:(BOOL)isNoMoreData;
- (void)searchFailure:(NSError *)error
          isFirstPage:(BOOL)isFirstPage;

@end
