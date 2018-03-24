//
//  MSHModel.m
//  MarvelHeroes
//
//  Created by Leo on 2018/3/23.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "MSHModel.h"
#import <objc/runtime.h>

static const char * kClassPropertiesKey;

@implementation MSHModel

- (id) init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
}

@end
