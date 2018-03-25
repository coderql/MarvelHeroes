//
//  MSHTransition.m
//  MarvelHeroes
//
//  Created by Leo on 2018/3/25.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "MSHTransition.h"

@implementation MSHTransition

- (instancetype)init {
    if (self = [super init]) {
        _duration = 1.0;
        _presenting = YES;
        _originFrame = CGRectZero;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = transitionContext.containerView;
    UIView *topView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *herbView = self.presenting? topView: [transitionContext viewForKey:UITransitionContextFromViewKey];
//    herbView.frame = CGRectMake(0, MSH_StatusBarAndNavigationBarHeight, CGRectGetWidth(herbView.frame), CGRectGetWidth(herbView.frame) / kHeroImageRatio);
    
    CGRect initialFrame = self.presenting? self.originFrame: herbView.frame;
    CGRect finalFrame = self.presenting? herbView.frame: self.originFrame;
    
    CGFloat xScaleFactor = self.presenting? initialFrame.size.width / finalFrame.size.width : finalFrame.size.width / initialFrame.size.width;
    CGFloat yScaleFactor = self.presenting? initialFrame.size.height / finalFrame.size.height: finalFrame.size.height / initialFrame.size.height;
    
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(xScaleFactor, yScaleFactor);
    
    if (self.presenting) {
        herbView.transform = scaleTransform;
        herbView.center = CGPointMake(CGRectGetMidX(initialFrame), CGRectGetMidY(initialFrame));
        herbView.clipsToBounds = YES;
    }
    
    [containerView addSubview:topView];
    [containerView bringSubviewToFront:herbView];
    
    [UIView animateWithDuration:self.duration delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        herbView.transform = self.presenting? CGAffineTransformIdentity: scaleTransform;
        herbView.center = CGPointMake(CGRectGetMidX(finalFrame), CGRectGetMidY(finalFrame));
    } completion:^(BOOL finished) {
        if (!self.presenting && self.dismissCompletion) {
            self.dismissCompletion();
        }
        [transitionContext completeTransition:YES];
    }];
}

@end
