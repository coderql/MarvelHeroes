//
//  MSHHeroDetailPresenter.h
//  MarvelHeroes
//
//  Created by qian zhao on 2018/3/25.
//  Copyright © 2018年 leo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSHHeroDetailProtocol.h"

@interface MSHHeroDetailPresenter : NSObject
- (instancetype)initWithView:(id<MSHHeroDetailProtocol>)view;
- (void)getComicsWithHeroId:(NSNumber *)heroId;
- (void)getEventsWithHeroId:(NSNumber *)heroId;
- (void)getStoriesWithHeroId:(NSNumber *)heroId;
- (void)getSeriesWithHeroId:(NSNumber *)heroId;
- (void)favorHero:(BOOL)isFavor heroId:(int)heroId;
@end
