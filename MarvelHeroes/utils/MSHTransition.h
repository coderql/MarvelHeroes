//
//  MSHTransition.h
//  MarvelHeroes
//
//  Created by Leo on 2018/3/25.
//  Copyright © 2018年 leo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^CompletionBlock)(void);

@interface MSHTransition : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) BOOL presenting;
@property (nonatomic, assign) CGRect originFrame;
@property (nonatomic, copy) CompletionBlock dismissCompletion;
@end
