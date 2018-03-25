//
//  MSHCollectionViewCell.h
//  MarvelHeroes
//
//  Created by qian zhao on 2018/3/24.
//  Copyright © 2018年 leo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MSHHero;

@interface MSHCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *favorImageView;
@property (nonatomic, strong) MSHHero *hero;
@end
