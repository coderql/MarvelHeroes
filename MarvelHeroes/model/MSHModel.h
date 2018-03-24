//
//  MSHModel.h
//  MarvelHeroes
//
//  Created by Leo on 2018/3/23.
//  Copyright © 2018年 leo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSHModel : NSObject
- (instancetype) initWithData:(NSData *)data error:(NSError *)error;
@end
