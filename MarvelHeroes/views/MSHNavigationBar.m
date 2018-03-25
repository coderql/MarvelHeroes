//
//  MSHNavigationBar.m
//  MarvelHeroes
//
//  Created by qian zhao on 2018/3/25.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "MSHNavigationBar.h"

@implementation MSHNavigationBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back"]];
    backImageView.frame = CGRectMake(0, 0, kDefaultHeight, kDefaultHeight);
    backImageView.contentMode = UIViewContentModeCenter;
    backImageView.userInteractionEnabled = YES;
    [backImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)]];
    [self addSubview:backImageView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(backImageView.frame), 0, SCREEN_WIDTH - 2 * kDefaultHeight, kDefaultHeight)];
    _titleLabel.font = [UIFont boldSystemFontOfSize:17.f];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
}

- (void)dismiss:(UITapGestureRecognizer *)gesture {
    if (self.backHandler) {
        self.backHandler();
    }
}

@end
