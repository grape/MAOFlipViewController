//
//  YuSamsungFlipViewController.h
//  Demo
//
//  Created by 余志琴 on 14-6-17.
//  Copyright (c) 2014年 Mao Nishi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YuSamsungFlipViewController;

@protocol YuSamsungFlipViewControllerDelegate <NSObject>
- (UIViewController*)flipViewController:(YuSamsungFlipViewController *)flipViewController contentIndex:(NSUInteger)contentIndex;
- (NSUInteger)numberOfFlipViewControllerContents;
@end

@interface YuSamsungFlipViewController : UIViewController
@property (nonatomic, weak) id<YuSamsungFlipViewControllerDelegate> delegate;
@end
