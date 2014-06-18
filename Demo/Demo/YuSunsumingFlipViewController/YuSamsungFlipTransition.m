//
//  YuSamsungFlipTransition.m
//  Demo
//
//  Created by 余志琴 on 14-6-17.
//  Copyright (c) 2014年 Mao Nishi. All rights reserved.
//

#import "YuSamsungFlipTransition.h"

@implementation YuSamsungFlipTransition

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 1.0;
}

//we assume that fromView and toView has the same size.
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *fromView = fromVC.view;
    UIView *toView = toVC.view;
    
    UIView *container = [transitionContext containerView];
    
    CGFloat width = CGRectGetWidth(fromView.frame);
    CGFloat height = CGRectGetHeight(fromView.frame);
    
    if (self.isPush) {
        [toView setFrame:CGRectMake(0, 0, width, height)];
        [toView setAlpha:0.5];
        
        [container insertSubview:toView belowSubview:fromView];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                                       delay:0
                                     options:0
                                  animations:^{
                                        [fromView setFrame:CGRectMake(0, -height, width, height)];
                                        [toView setAlpha:1.0];
                                  }
                                  completion:^(BOOL finished){
                                      //[fromView removeFromSuperview];
                                      BOOL completed = ![transitionContext transitionWasCancelled];
                                      [transitionContext completeTransition:completed];
                                      NSLog(@"pushAnimationFinished");
                                  }];
        
    }else{
        [toView setFrame:CGRectMake(0, -height, width, height)];
        [container insertSubview:toView belowSubview:fromView];
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                                       delay:0
                                     options:0
                                  animations:^{
                                      [toView setFrame:CGRectMake(0, 0, width, height)];
                                      [fromView setAlpha:0.0];
                                  }
                                  completion:^(BOOL finished){
                                     // [fromView removeFromSuperview];
                                      BOOL completed = ![transitionContext transitionWasCancelled];
                                      [transitionContext completeTransition:completed];
                                      NSLog(@"popAnimationFinished");
                                  }];
    }
    NSLog(@"animation called, isPushMode = %d", self.isPush);
    
}


@end
