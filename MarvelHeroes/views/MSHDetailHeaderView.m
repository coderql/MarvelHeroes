//
//  MSHDetailHeaderView.m
//  MarvelHeroes
//
//  Created by qian zhao on 2018/3/24.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "MSHDetailHeaderView.h"
#import "MSHHero.h"

static CGFloat const kPadding = 16.f;
static CGFloat const kFavorIconWidth = 44.f;

@implementation MSHDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _heroImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/kHeroImageRatio)];
    [self addSubview:self.heroImageView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadding, CGRectGetMaxY(self.heroImageView.frame) + kPadding, SCREEN_WIDTH - 2 * kPadding, 0)];
    _nameLabel.font = [UIFont boldSystemFontOfSize:15.f];
    _nameLabel.numberOfLines = 0;
    [self addSubview:self.nameLabel];
    
    _favorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kFavorIconWidth, kFavorIconWidth)];
//     _favorImageView.center = CGPointMake(SCREEN_WIDTH - kPadding - kFavorIconWidth / 2, self.nameLabel.center.y);
    _favorImageView.contentMode = UIViewContentModeCenter;
    _favorImageView.userInteractionEnabled = YES;
    [_favorImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFavorImageView:)]];
    [self addSubview:self.favorImageView];
    
    _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadding, CGRectGetMaxY(self.nameLabel.frame), SCREEN_WIDTH - 2 * kPadding, 0)];
    _descLabel.font = [UIFont systemFontOfSize:14.f];
    _descLabel.numberOfLines = 0;
    [self addSubview:self.descLabel];
}

- (void)setHero:(MSHHero *)hero {
    _hero = hero;
    self.nameLabel.text = hero.name;
    CGRect finalFrame = self.nameLabel.frame;
    finalFrame.size.height = [MSHUtils heightOfText:self.nameLabel.text containerWidth:finalFrame.size.width fontSize:15.f] + 20;
    self.nameLabel.frame = finalFrame;
    
    _favorImageView.center = CGPointMake(SCREEN_WIDTH - kPadding - kFavorIconWidth / 2, self.nameLabel.center.y);
    _favorImageView.image = hero.isFavorite? [UIImage imageNamed:@"favorite_selected"]: [UIImage imageNamed:@"favorite"];
    
    self.descLabel.text = hero.desc;
    finalFrame = self.descLabel.frame;
    finalFrame.origin.y = CGRectGetMaxY(self.nameLabel.frame);
    finalFrame.size.height = [MSHUtils heightOfText:self.descLabel.text containerWidth:finalFrame.size.width fontSize:14.f];
    self.descLabel.frame = finalFrame;
    
    finalFrame = self.frame;
    finalFrame.size.height = CGRectGetMaxY(self.descLabel.frame) + kPadding;
    self.frame = finalFrame;
}

- (void)tapFavorImageView:(UITapGestureRecognizer *)gesture {
    if (self.favorHandler) {
        self.favorHandler(self.hero.heroId, !self.hero.isFavorite);
    }
}

- (void)updateFavorImageView{
//    self.favorImageView.highlighted = !self.favorImageView.highlighted;
    self.favorImageView.image = self.hero.isFavorite? [UIImage imageNamed:@"favorite_selected"]: [UIImage imageNamed:@"favorite"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
