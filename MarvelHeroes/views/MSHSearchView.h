//
//  MSHSearchView.h
//  MarvelHeroes
//
//  Created by Leo on 2018/3/25.
//  Copyright © 2018年 leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MSHSearchViewDelegate <NSObject>
- (void)searchView:(UIView *)searchView didEndEditing:(NSString *)text;
- (void)searchView:(UIView *)searchView cancelButtonClicked:(UIButton *)button;
@end

@interface MSHSearchView : UIView
@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, weak) id<MSHSearchViewDelegate> searchDelegate;
@property (nonatomic, assign) BOOL searchActive;
- (void)endSearching;
@end
