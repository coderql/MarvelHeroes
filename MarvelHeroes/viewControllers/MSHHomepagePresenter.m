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
                               [self.view searchSuccess:responseObject isFirstPage:loadFirstPage noMoreData:(responseObject.offset + responseObject.count >= responseObject.total)];
                           } else {
                               [self.view searchFailure:error isFirstPage:loadFirstPage];
                           }
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

@end
