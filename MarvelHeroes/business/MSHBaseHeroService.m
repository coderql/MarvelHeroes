//
//  MSHBaseHeroService.m
//  MarvelHeroes
//
//  Created by Leo on 2018/3/24.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "MSHBaseHeroService.h"
#import "MSHDBManager.h"

@implementation MSHBaseHeroService
- (BOOL)favor:(int)heroId {
    return [[MSHDBManager manager] favorHero:heroId];
}

- (BOOL)unfavor:(int)heroId {
    return [[MSHDBManager manager] unfavorHero:heroId];
}


- (NSArray*)favoredHeros:(NSArray *)heroIds {
    return [[MSHDBManager manager] findFavoredHeroes:heroIds];
}
@end
