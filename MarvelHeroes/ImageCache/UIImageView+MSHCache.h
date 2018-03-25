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
/**
 * set image for this UIImageView with cached solution.
 *
 * @param url image download url
 * @param placeholderImage image to set before load real image.
 */
- (void)setImageUrl:(NSURL *)url placeholder:(UIImage *)placeholderImage;
@end
