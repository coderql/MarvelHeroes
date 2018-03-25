//
//  MSHMacros.h
//  MarvelHeroes
//
//  Created by qian zhao on 2018/3/24.
//  Copyright © 2018年 leo. All rights reserved.
//

#ifndef MSHMacros_h
#define MSHMacros_h

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

// iPhone X
#define MSH_iPhoneX (SCREEN_WIDTH == 375.f && SCREEN_HEIGHT == 812.f ? YES : NO)

#define MSH_TabbarSafeBottomMargin (MSH_iPhoneX ? 34.f : 0.f)
#define MSH_StatusBarHeight  (MSH_iPhoneX ? 44.f : 20.f)
#define MSH_NavigationBarHeight  44.f
#define MSH_StatusBarAndNavigationBarHeight  (MSH_iPhoneX ? 88.f : 64.f)
#define MSH_Bit SCREEN_WIDTH/375.0

//color
#define MSH_RGB(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b) /255.0 alpha:1.0]
#define kBackgroundColor MSH_RGB(245, 245, 245)

#define kHeroImageRatio (2/3.f)

static float const kDefaultHeight = 44.f;
static int const kDataLimit = 20;
static int const kEntityLimit = 3;

#define AbstractMethodNotImplemented() \
@throw [NSException exceptionWithName:NSInternalInconsistencyException \
                               reason:[NSString stringWithFormat:@"You must override %@ in a subclass.", NSStringFromSelector(_cmd)] \
                             userInfo:nil]

#endif /* MSHMacros_h */
