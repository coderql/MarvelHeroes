//
//  MSHCollectionViewCell.m
//  MarvelHeroes
//
//  Created by Leo on 2018/3/24.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "MSHCollectionViewCell.h"
#import "MSHHero.h"

@implementation MSHCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setHero:(MSHHero *)hero {
    _hero = hero;
    if (hero.isFavorite) {
        self.favorImageView.hidden = NO;
        self.favorImageView.image = [UIImage imageNamed:@"favorite_selected"];
    } else {
        self.favorImageView.hidden = YES;
    }
    self.nameLabel.text = hero.name;
}

@end
