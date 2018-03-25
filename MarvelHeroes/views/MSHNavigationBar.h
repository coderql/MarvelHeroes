//
//  MSHNavigationBar.h
//  MarvelHeroes
//
//  Created by Leo on 2018/3/25.
//  Copyright © 2018年 leo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NavigationBarBackHandler)(void);

@interface MSHNavigationBar : UIView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, copy) NavigationBarBackHandler backHandler;
@end
