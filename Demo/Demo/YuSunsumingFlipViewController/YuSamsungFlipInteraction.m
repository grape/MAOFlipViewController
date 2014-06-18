//
//  YuSamsungFlipInteraction.m
//  Demo
//
//  Created by 余志琴 on 14-6-17.
//  Copyright (c) 2014年 Mao Nishi. All rights reserved.
//

//this class inherients *UIPercentDrivenInteractiveTransition*, mainly to create the interaction animation during the process of exchanging view

//need to implement handlePan method to handle the PanGesture


#import "YuSamsungFlipInteraction.h"
#import "YuPanGestureRecognizer.h"

@implementation YuSamsungFlipInteraction

- (void)setView:(UIView *)view
{
    _view = view;
    for (UIPanGestureRecognizer *r in view.gestureRecognizers) {
        if ([r isKindOfClass:[YuPanGestureRecognizer class]]) {
            [view removeGestureRecognizer:r];  //after using we should set all interactionController nil
        }
    }
    UIPanGestureRecognizer *gesture = [[YuPanGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(handlePan:)];
    [self.view addGestureRecognizer:gesture];
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture
{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            CGPoint translation = [gesture translationInView:self.view];
            CGPoint nowPoint = [gesture locationInView:self.view];
            NSLog(@"gesture began: %f", translation.y);
            if (translation.y < 0) {
                self.isPushMode = YES;
                [self.delegate interactionPushBeganAtPoint:nowPoint];
            }else if(translation.y > 0){
                self.isPushMode = NO;
                [self.delegate interactionPopBeganAtPoint:nowPoint];
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            CGPoint lastV = [gesture velocityInView:self.view];
            NSLog(@"gesture ended, pushMode: %d, currentVe: %f", self.isPushMode, lastV.y);
            if (self.isPushMode) {
                //if (nowPoint.y < boundary) {
                if (lastV.y < 0){
                    [self finishInteractiveTransition];
                }else{
                    [self.delegate cancelPushInteraction];
                    [self cancelInteractiveTransition];
                }
            }else{
                //if (nowPoint.y < boundary) {
                if (lastV.y < 0){
                    [self cancelInteractiveTransition];
                }else{
                    [self finishInteractiveTransition];
                    [self.delegate completePopInteraction];
                }
            }
            
             break;
        }
        case UIGestureRecognizerStateChanged:
        {
            CGRect viewRect = self.view.bounds;
            CGPoint translation = [gesture translationInView:self.view];
            CGPoint currentVelocity = [gesture velocityInView:self.view];
            /*if (translation.y > 0) {
                self.isPushMode = NO;
            }else if (translation.y < 0){
                self.isPushMode = YES;
            }*/
            /*if (currentVelocity.y > 0) {
                self.isPushMode = NO;
            }else if (currentVelocity.y < 0){
                self.isPushMode = YES;
            }*/
            NSLog(@"gesture changed, pushMode: %d, velocity: %f", self.isPushMode, currentVelocity.y);
            CGFloat percent = translation.y / viewRect.size.height;
            percent = fabsf(percent);
            percent = MIN(1.0, MAX(0.0, percent));
            [self updateInteractiveTransition:percent];
            break;
        }
        case UIGestureRecognizerStateCancelled:
            break;
        default:
            break;
    }
}

@end
