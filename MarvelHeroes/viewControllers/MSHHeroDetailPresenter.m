//
//  MSHHeroDetailPresenter.m
//  MarvelHeroes
//
//  Created by qian zhao on 2018/3/25.
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
    [self.heroService getComicsOfHero:[heroId intValue] offset:0 limit:kEntityLimit resultHandler:^(MSHPageInfo *responseObject, NSError *error) {
        if (responseObject) {
            [self.view getComicsSuccess:responseObject.data];
        } else {
            [self.view getComicsFailure:error];
        }
    }];
}

- (void)getEventsWithHeroId:(NSNumber *)heroId {
    [self.heroService getEventsOfHero:[heroId intValue] offset:0 limit:kEntityLimit resultHandler:^(MSHPageInfo *responseObject, NSError *error) {
        if (responseObject) {
            [self.view getEventsSuccess:responseObject.data];
        } else {
            [self.view getEventsFailure:error];
        }
    }];
}

- (void)getStoriesWithHeroId:(NSNumber *)heroId {
    [self.heroService getStoriesOfHero:[heroId intValue] offset:0 limit:kEntityLimit resultHandler:^(MSHPageInfo *responseObject, NSError *error) {
        if (responseObject) {
            [self.view getStoriesSuccess:responseObject.data];
        } else {
            [self.view getStoriesFailure:error];
        }
    }];
}

- (void)getSeriesWithHeroId:(NSNumber *)heroId {
    [self.heroService getSeriesOfHero:[heroId intValue] offset:0 limit:kEntityLimit resultHandler:^(MSHPageInfo *responseObject, NSError *error) {
        if (responseObject) {
            [self.view getSeriesSuccess:responseObject.data];
        } else {
            [self.view getSeriesFailure:error];
        }
    }];
}

- (NSString *)getImageUrlWithThumbnail:(MSHThumbnail *)thumbnail {
    return [self.heroService getHeroThumbnailURL:thumbnail];
}

- (void)favorHero:(BOOL)isFavor heroId:(int)heroId {
    if (isFavor) {
        [self.heroService favorHero:heroId resultHandler:^(id responseObject, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^ {
                if ([responseObject boolValue]) {
                    [self.view favorCompleted:nil];
                } else {
                    [self.view favorCompleted:[[NSError alloc] initWithDomain:@"com.MSH" code:-1 userInfo:nil]];
                }
            });
        }];
    } else {
        [self.heroService unfavorHero:heroId resultHandler:^(id responseObject, NSError *error) {
                        dispatch_async(dispatch_get_main_queue(), ^ {
                            if ([responseObject boolValue]) {
                                [self.view favorCompleted:nil];
                            } else {
                                [self.view favorCompleted:[[NSError alloc] initWithDomain:@"com.MSH" code:-1 userInfo:nil]];
                            }
            });
        }];
    }
}

@end
