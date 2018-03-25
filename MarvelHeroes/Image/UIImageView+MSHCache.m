//
//  UIImageView+MSHCache.m
//  MarvelHeroes
//
//  Created by Leo on 2018/3/24.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "UIImageView+MSHCache.h"
#import "MSHImageManager.h"

@implementation UIImageView (MSHCache)
- (void)setImageUrl:(NSURL *)url placeholder:(UIImage *)placeholderImage {
    // set placeholder image first.
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self setImage:placeholderImage];
    });
    
    // replace with loaded image.
    [[MSHImageManager manager] loadImageURL:url completion:^(NSData *data, NSError *error) {
        UIImage *image = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self setImage:image];
        });
    }];
}

@end
