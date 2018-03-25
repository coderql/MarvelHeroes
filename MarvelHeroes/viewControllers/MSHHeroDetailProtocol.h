//
//  MSHHeroDetailProtocol.h
//  MarvelHeroes
//
//  Created by qian zhao on 2018/3/25.
//  Copyright © 2018年 leo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MSHHeroDetailProtocol <NSObject>

- (void)getComicsSuccess:(NSArray *)comics;
- (void)getComicsFailure:(NSError *)error;

- (void)getEventsSuccess:(NSArray *)events;
- (void)getEventsFailure:(NSError *)error;

- (void)getStoriesSuccess:(NSArray *)stories;
- (void)getStoriesFailure:(NSError *)error;

- (void)getSeriesSuccess:(NSArray *)series;
- (void)getSeriesFailure:(NSError *)error;

@end
