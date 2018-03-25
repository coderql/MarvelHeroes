//
//  MSHDetailHeaderView.h
//  MarvelHeroes
//
//  Created by qian zhao on 2018/3/24.
//  Copyright © 2018年 leo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MSHHero;

@interface MSHDetailHeaderView : UIView
@property (nonatomic, strong) UIImageView *heroImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *favorImageView;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) MSHHero *hero;
@end