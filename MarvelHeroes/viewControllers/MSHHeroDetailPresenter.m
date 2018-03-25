//
//  MSHHeroDetailPresenter.m
//  MarvelHeroes
//
//  Created by Leo on 2018/3/25.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "MSHHeroDetailPresenter.h"
#import "MSHMarvelHeroService.h"
#import "MSHPageInfo.h"

@interface MSHHeroDetailPresenter()
@property (nonatomic, weak) id<MSHHeroDetailProtocol> view;
@property (nonatomic, strong) MSHMarvelHeroService *heroService;
@end

@implementation MSHHeroDetailPresenter

- (instancetype)initWithView:(id<MSHHeroDetailProtocol>)view {
    if (self = [super init]) {
        _view = view;
        _heroService = [[MSHMarvelHeroService alloc] init];
    }
    return self;
}

- (void)getComicsWithHeroId:(NSNumber *)heroId {
    __weak __typeof(self) weakSelf = self;
    [self.heroService getComicsOfHero:[heroId intValue] offset:0 limit:kEntityLimit resultHandler:^(MSHPageInfo *responseObject, NSError *error) {
        if (responseObject) {
            [weakSelf.view getComicsSuccess:responseObject.data];
        } else {
            [weakSelf.view getComicsFailure:error];
        }
    }];
}

- (void)getEventsWithHeroId:(NSNumber *)heroId {
    __weak __typeof(self) weakSelf = self;
    [self.heroService getEventsOfHero:[heroId intValue] offset:0 limit:kEntityLimit resultHandler:^(MSHPageInfo *responseObject, NSError *error) {
        if (responseObject) {
            [weakSelf.view getEventsSuccess:responseObject.data];
        } else {
            [weakSelf.view getEventsFailure:error];
        }
    }];
}

- (void)getStoriesWithHeroId:(NSNumber *)heroId {
    __weak __typeof(self) weakSelf = self;
    [self.heroService getStoriesOfHero:[heroId intValue] offset:0 limit:kEntityLimit resultHandler:^(MSHPageInfo *responseObject, NSError *error) {
        if (responseObject) {
            [weakSelf.view getStoriesSuccess:responseObject.data];
        } else {
            [weakSelf.view getStoriesFailure:error];
        }
    }];
}

- (void)getSeriesWithHeroId:(NSNumber *)heroId {
    __weak __typeof(self) weakSelf = self;
    [self.heroService getSeriesOfHero:[heroId intValue] offset:0 limit:kEntityLimit resultHandler:^(MSHPageInfo *responseObject, NSError *error) {
        if (responseObject) {
            [weakSelf.view getSeriesSuccess:responseObject.data];
        } else {
            [weakSelf.view getSeriesFailure:error];
        }
    }];
}

- (NSString *)getImageUrlWithThumbnail:(MSHThumbnail *)thumbnail {
    return [self.heroService getHeroThumbnailURL:thumbnail];
}

- (void)favorHero:(BOOL)isFavor heroId:(int)heroId {
    __weak __typeof(self) weakSelf = self;
    if (isFavor) {
        [self.heroService favorHero:heroId resultHandler:^(id responseObject, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^ {
                if ([responseObject boolValue]) {
                    [weakSelf.view favorCompleted:nil];
                } else {
                    [weakSelf.view favorCompleted:[[NSError alloc] initWithDomain:@"com.MSH" code:-1 userInfo:nil]];
                }
            });
        }];
    } else {
        [self.heroService unfavorHero:heroId resultHandler:^(id responseObject, NSError *error) {
                        dispatch_async(dispatch_get_main_queue(), ^ {
                            if ([responseObject boolValue]) {
                                [weakSelf.view favorCompleted:nil];
                            } else {
                                [weakSelf.view favorCompleted:[[NSError alloc] initWithDomain:@"com.MSH" code:-1 userInfo:nil]];
                            }
            });
        }];
    }
}

@end
