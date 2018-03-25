//
//  MSHPageInfo.h
//  MarvelHeroes
//
//  Created by Leo on 2018/3/23.
//  Copyright © 2018年 leo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSHPageInfo : NSObject
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) NSInteger limit;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSArray *data;

@end
