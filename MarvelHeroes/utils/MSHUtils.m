//
//  MSHUtils.m
//  MarvelHeroes
//
//  Created by qian zhao on 2018/3/24.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "MSHUtils.h"

@implementation MSHUtils

+ (CGFloat)heightOfText:(NSString *)text
        containderWidth:(CGFloat)containderWidth
               fontSize:(CGFloat)fontSize {
    if ([self isEmptyString:text]) {
        return 0.f;
    }
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    CGRect frame = [text boundingRectWithSize:CGSizeMake(containderWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin  | NSStringDrawingUsesFontLeading  attributes:dict context:nil];
    return frame.size.height;
}

+ (BOOL)isEmptyString:(NSString *)string {
    return ((string == nil) || string.length <= 0);
}

@end