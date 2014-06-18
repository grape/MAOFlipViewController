//
//  YuSamsungFlipInteraction.h
//  Demo
//
//  Created by 余志琴 on 14-6-17.
//  Copyright (c) 2014年 Mao Nishi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YuSamsungFlipInteactionDelegate <NSObject>
- (void)interactionPushBeganAtPoint:(CGPoint)point;
- (void)interactionPopBeganAtPoint:(CGPoint)point;
- (void)completePopInteraction;
- (void)cancelPushInteraction;
@end

@interface YuSamsungFlipInteraction : UIPercentDrivenInteractiveTransition
@property(nonatomic) UIView *view;
@property(nonatomic) id<YuSamsungFlipInteactionDelegate> delegate;
@property(nonatomic, assign) BOOL isPushMode;
@end
