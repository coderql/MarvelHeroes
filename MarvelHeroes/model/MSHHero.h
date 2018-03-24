//
//  MSHHero.h
//  MarvelHeroes
//
//  Created by Leo on 2018/3/22.
//  Copyright © 2018年 leo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSHThumbnail.h"

@interface MSHHero : NSObject
@property (nonatomic, assign) int heroId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, strong) MSHThumbnail *thumbnail;
@end
