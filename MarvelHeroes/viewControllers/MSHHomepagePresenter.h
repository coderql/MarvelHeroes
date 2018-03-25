//
//  MSHHomepagePresenter.h
//  MarvelHeroes
//
//  Created by Leo on 2018/3/24.
//  Copyright © 2018年 leo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSHHomepageProtocol.h"
#import "MSHThumbnail.h"

@interface MSHHomepagePresenter : NSObject
- (instancetype)initWithView:(id<MSHHomepageProtocol>)view;
- (void)loadFirstPage;
- (void)loadNextPageWithOffset:(int)offset;
- (void)searchWithText:(NSString *)searchText;
- (void)searchMoreWithText:(NSString *)searchText offset:(int)offset;
- (NSString *)getImageUrlWithThumbnail:(MSHThumbnail *)thumbnail;
@end
