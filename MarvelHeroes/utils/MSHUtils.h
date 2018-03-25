//
//  MSHUtils.h
//  MarvelHeroes
//
//  Created by qian zhao on 2018/3/24.
//  Copyright © 2018年 leo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h> 

@interface MSHUtils : NSObject

+ (CGFloat)heightOfText:(NSString *)text
        containderWidth:(CGFloat)containderWidth
               fontSize:(CGFloat)fontSize;

+ (BOOL)isEmptyString:(NSString *)string;

@end