//
//  YuSamsungFlipViewController.m
//  Demo
//
//  Created by 余志琴 on 14-6-17.
//  Copyright (c) 2014年 Mao Nishi. All rights reserved.
//

#import "YuSamsungFlipViewController.h"
#import "YuSamsungFlipTransition.h"
#import "YuSamsungFlipInteraction.h"

@interface YuSamsungFlipViewController ()<UINavigationControllerDelegate, YuSamsungFlipInteactionDelegate, UIViewControllerTransitioningDelegate>
@property(nonatomic) YuSamsungFlipTransition *flipTransition;
@property(nonatomic) YuSamsungFlipInteraction *flipInteraction;
@property(nonatomic) UINavigationController *flipNavigationController;
@end

@implementation YuSamsungFlipViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIViewController *c = [self.delegate flipViewController:self contentIndex:0];
    if (c) {
        self.flipInteraction = YuSamsungFlipInteraction.new;
        self.flipInteraction.delegate = self;
        [self.flipInteraction setView:c.view];
        self.flipNavigationController = [[UINavigationController alloc] initWithRootViewController:c];
        self.flipNavigationController.delegate = self;
        [self.flipNavigationController.navigationBar setHidden:YES];
        
        [self addChildViewController:self.flipNavigationController];
        self.flipNavigationController.view.frame = self.view.frame;
        [self.view addSubview:self.flipNavigationController.view];
        [self.flipNavigationController didMoveToParentViewController:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - FlipInteractionDelegate
//画面遷移開始
- (void)interactionPushBeganAtPoint:(CGPoint)point
{
    UIViewController *c = [self nextViewController];
    if (!c) {
        return;
    }
    [self.flipInteraction setView:c.view];//インタラクション対象viewの設定。遷移先のview
    [self.flipNavigationController pushViewController:c animated:YES];
}
- (void)interactionPopBeganAtPoint:(CGPoint)point
{
    [self.flipNavigationController popViewControllerAnimated:YES];
}

- (UIViewController*)nextViewController
{
    //既に存在している場合は一つ次のviewController取り出し
    NSInteger targetIndex = self.flipNavigationController.viewControllers.count;
    
    //予定枚数を超えている場合はなし
    if ([self.delegate numberOfFlipViewControllerContents] <= targetIndex) {
        return nil;
    }
    
    UIViewController *c = [self.delegate flipViewController:self contentIndex:(targetIndex)];
    return c;
}

- (void)completePopInteraction
{
    //インタラクション対象のviewを設定する
    UIViewController *c = [self.flipNavigationController.viewControllers lastObject];
    [self.flipInteraction setView:c.view];
}

- (void)cancelPushInteraction {
    //[self.flipNavigationController popViewControllerAnimated:YES];
    UIViewController *c = [self.flipNavigationController.viewControllers lastObject];
    [self.flipInteraction setView:c.view];
    NSLog(@"[canclePushInteraction]nav controls = %d", self.flipNavigationController.viewControllers.count);
}


#pragma mark - UINavigationControllerDelegate methods

- (id<UIViewControllerAnimatedTransitioning>) navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
    //choose different animations for push/pop view
    self.flipTransition = [[YuSamsungFlipTransition alloc] init];
    if ( operation == UINavigationControllerOperationPush) {
        self.flipTransition.isPush = YES;
    }else{
        self.flipTransition.isPush = NO;
    }
    return self.flipTransition;
}

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
{
    return self.flipInteraction;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
