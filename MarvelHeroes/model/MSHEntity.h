//
//  MSHEntity.h
//  MarvelHeroes
//
//  Super class of comic, event, story and series. If they have dedicated fields to display,
//  extends from this super class.
//
//  Created by Leo on 2018/3/24.
//  Copyright © 2018年 leo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSHEntity : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@end
