//
//  MSHDBManager.h
//  MarvelHeroes
//
//  Created by Leo on 2018/3/25.
//  Copyright © 2018年 leo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSHDBManager : NSObject
+ (nonnull instancetype)manager;
- (NSArray *)findFavoredHeroes:(NSArray *)heroIds;
- (BOOL)unfavorHero:(int)heroId;
- (BOOL)favorHero:(int)heroId;
- (BOOL)close;
@end
