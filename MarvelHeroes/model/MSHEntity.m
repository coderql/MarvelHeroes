//
//  MSHEntity.m
//  MarvelHeroes
//
//  Created by Leo on 2018/3/24.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "MSHEntity.h"

@implementation MSHEntity

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"description"]) {
        self.desc = value;
    }
//    [super setValue:value forUndefinedKey:key];
}

- (void)setNilValueForKey:(NSString *)key {
    MSHLog(@"key = %@", key);
}

@end
