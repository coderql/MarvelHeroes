//
//  MSHHomepagePresenter.m
//  MarvelHeroes
//
//  Created by qian zhao on 2018/3/24.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "MSHHomepagePresenter.h"
#import "MSHMarvelHeroService.h"
#import "MSHPageInfo.h"
#import "MSHHero.h"

@interface MSHHomepagePresenter()
@property (nonatomic, weak) id<MSHHomepageProtocol> view;
@property (nonatomic, strong) MSHMarvelHeroService *webService;
@end

@implementation MSHHomepagePresenter

- (instancetype)initWithView:(id<MSHHomepageProtocol>)view {
    if (self = [super init]) {
        _view = view;
        _webService = [[MSHMarvelHeroService alloc] init];
    }
    return self;
}

- (void)loadDataWithOffset:(int)offset
                    status:(BOOL)loadFirstPage {
    [self.webService getHeroesOffset:offset
                               limit:kDataLimit
                      nameStartsWith:nil
                       resultHandler:^(MSHPageInfo *responseObject, NSError *error) {
                           if (responseObject) {
                               responseObject.data = [self handleResults:responseObject.data];
                               [self.view loadSuccess:responseObject isFirstPage:loadFirstPage noMoreData:(responseObject.offset + responseObject.count >= responseObject.total)];
                           } else {
                               [self.view loadFailure:error isFirstPage:loadFirstPage];
                           }
                       }];
}

- (void)searchWithOffset:(int)offset
                destText:(NSString *)text
                  status:(BOOL)loadFirstPage {
    [self.webService getHeroesOffset:offset
                               limit:kDataLimit
                      nameStartsWith:text
                       resultHandler:^(MSHPageInfo *responseObject, NSError *error) {
                           if (responseObject) {
                               responseObject.data = [self handleResults:responseObject.data];
                               [self.view searchSuccess:responseObject isFirstPage:loadFirstPage noMoreData:(responseObject.offset + responseObject.count >= responseObject.total)];
                           } else {
                               [self.view searchFailure:error isFirstPage:loadFirstPage];
                           }
                       }];
}

- (NSArray *)handleResults:(NSArray *)results {
    if ((results == nil) || (results.count <= 0)) {
        return results;
    }
    NSMutableArray *heroIds = [[NSMutableArray alloc] initWithCapacity:results.count];
    for(MSHHero *hero in results) {
        [heroIds addObject:@(hero.heroId)];
    }
    NSArray *favorResult = [self.webService favoredHeros:[heroIds copy]];
    for(MSHHero *hero in results) {
        hero.isFavorite = [favorResult containsObject:@(hero.heroId)];
    }
//    [favorResult enumerateObjectsUsingBlock:^(NSNumber   * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        ((MSHHero *)results[idx]).isFavorite = [obj intValue];
//        results indexOfObject:<#(nonnull id)#>
//    }];
    return results;
}

- (void)loadFirstPage {
    [self loadDataWithOffset:0 status:YES];
}

- (void)loadNextPageWithOffset:(int)offset {
    [self loadDataWithOffset:offset status:NO];
}

- (void)searchWithText:(NSString *)searchText {
    [self searchWithOffset:0 destText:searchText status:YES];
}

- (void)searchMoreWithText:(NSString *)searchText offset:(int)offset {
    [self searchWithOffset:offset destText:searchText status:NO];
}

- (NSString *)getImageUrlWithThumbnail:(MSHThumbnail *)thumbnail {
    return [self.webService getHeroThumbnailURL:thumbnail imageParam:@{@"variant": @"portrait_uncanny"}];
}

@end
