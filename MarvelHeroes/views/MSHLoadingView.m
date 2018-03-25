//
//  MSHLoadingView.m
//  MarvelHeroes
//
//  Created by qian zhao on 2018/3/24.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "MSHLoadingView.h"

static CGFloat const kLoadingViewWidth = 130.f;

@interface MSHLoadingView()
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@end

@implementation MSHLoadingView

- (instancetype)init {
    if (self = [super init]) {
        self.layer.cornerRadius = 5.0f;
        self.layer.masksToBounds = YES;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.frame = CGRectMake(0, 0, kLoadingViewWidth, kLoadingViewWidth);
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _indicatorView.center = CGPointMake(kLoadingViewWidth / 2, kLoadingViewWidth / 2);
    [self addSubview:self.indicatorView];
}

- (void)startLoading {
    [self.indicatorView startAnimating];
}

- (void)stopLoading {
    [self.indicatorView stopAnimating];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
