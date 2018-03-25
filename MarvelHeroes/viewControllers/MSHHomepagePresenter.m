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
                           dispatch_async(dispatch_get_main_queue(), ^ {
                               if (responseObject) {
                                   [self handleResults:responseObject.data complete:^(NSArray * array) {
                                       responseObject.data = array;
                                       [self.view loadSuccess:responseObject isFirstPage:loadFirstPage noMoreData:(responseObject.offset + responseObject.count >= responseObject.total)];
                                   }];
                               } else {
                                   [self.view loadFailure:error isFirstPage:loadFirstPage];
                               }
                           });
                       }];
}

- (void)searchWithOffset:(int)offset
                destText:(NSString *)text
                  status:(BOOL)loadFirstPage {
    [self.webService getHeroesOffset:offset
                               limit:kDataLimit
                      nameStartsWith:text
                       resultHandler:^(MSHPageInfo *responseObject, NSError *error) {
                           dispatch_async(dispatch_get_main_queue(), ^ {
                               if (responseObject) {
                                   [self handleResults:responseObject.data complete:^(NSArray * array) {
                                       responseObject.data = array;
                                       [self.view searchSuccess:responseObject isFirstPage:loadFirstPage noMoreData:(responseObject.offset + responseObject.count >= responseObject.total)];
                                   }];
                               } else {
                                   [self.view searchFailure:error isFirstPage:loadFirstPage];
                               }
                           });
                       }];
}

- (void)handleResults:(NSArray *)results complete:(void(^)(NSArray *))completeBlock {
    if ((results == nil) || (results.count <= 0)) {
        completeBlock(results);
        return;
    }
    NSMutableArray *heroIds = [[NSMutableArray alloc] initWithCapacity:results.count];
    for(MSHHero *hero in results) {
        [heroIds addObject:@(hero.heroId)];
    }
    [self.webService favoredHeros:[heroIds copy] resultHandler:^(id responseObject, NSError * error) {
        NSArray *favorResult = (NSArray *) responseObject;
        for(MSHHero *hero in results) {
            hero.isFavorite = [favorResult containsObject:@(hero.heroId)];
        }
        completeBlock(results);
    }];
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
    thumbnail.variant = @"portrait_uncanny";
    return [self.webService getHeroThumbnailURL:thumbnail];
}

@end
