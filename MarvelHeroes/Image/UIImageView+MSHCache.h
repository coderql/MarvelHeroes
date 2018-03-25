//
//  UIImageView+MSHCache.h
//  MarvelHeroes
//
//  Created by Leo on 2018/3/24.
//  Copyright © 2018年 leo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImageView (MSHCache)
- (void)setImageUrl:(NSURL *)url placeholder:(UIImage *)placeholderImage;
@end
