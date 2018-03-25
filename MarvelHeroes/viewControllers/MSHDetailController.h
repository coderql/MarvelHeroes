//
//  MSHDetailController.h
//  MarvelHeroes
//
//  Created by qian zhao on 2018/3/24.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "MSHBaseViewController.h"
@class MSHHero;

@protocol MSHDetailControllerDelegate <NSObject>
- (void)heroChanged:(MSHHero *)hero;
@end

@interface MSHDetailController : MSHBaseViewController
@property (nonatomic, strong) MSHHero *selectedHero;
@property (nonatomic, strong) UIImage *heroImage;
@property (nonatomic, weak) id<MSHDetailControllerDelegate> detailVCDelegate;
@end
