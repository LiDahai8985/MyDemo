//
//  MMNavDelegateObject.m
//  TestProject
//
//  Created by douchuanjiang on 16/5/6.
//  Copyright (c) 2016年 douchuanjiang. All rights reserved.
//

#import "MMNavDelegateObject.h"

@implementation MMNavDelegateObject

//- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
//                                   animationControllerForOperation:(UINavigationControllerOperation)operation
//                                                fromViewController:(UIViewController *)fromVC
//                                                  toViewController:(UIViewController *)toVC
//{
//    return [[TransitionPushAnimation alloc] init];
//}

@end




//@implementation TransitionPushAnimation
//
//- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
//{
//    return 0.5;
//}
//
//- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
//{
//    //通过键值UITransitionContextToViewControllerKey获得需要呈现的试图控制器
//    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//    
//    //通过键值UITransitionContextFromViewControllerKey获得需要退出的试图控制器
//    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//    
//    [[transitionContext containerView] addSubview:toVC.view];
//    [transitionContext containerView].backgroundColor = [UIColor redColor];
//    
//    //设置需要呈现的试图控制器透明
//    [toVC.view setAlpha:0];
//    //设置需要呈现的试图控制器位于左侧屏幕外，且大小为0.1倍，这样才有从左侧推入屏幕，且逐渐变大的动画效果
//    toVC.view.transform = CGAffineTransformScale(CGAffineTransformMakeTranslation(-[UIScreen mainScreen].bounds.size.width, 0), 0.1, 0.1);
//    
//    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
//        //将需要退出的试图控制器移出右侧屏幕外，且大小为原来的0.1倍
//        fromVC.view.transform = CGAffineTransformScale(CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width, 0), 0.1, 0.1);
//        fromVC.view.alpha = 0;
//        
//        toVC.view.transform = CGAffineTransformIdentity;
//        toVC.view.alpha = 1;
//        
//    } completion:^(BOOL finished) {
//        //动画结束后属性设为初始值
//        fromVC.view.transform = CGAffineTransformIdentity;
//        fromVC.view.alpha = 1;
//        
//        //通知系统动画切换成功
//        [transitionContext completeTransition:YES];
//    }];
//}
//
//
//@end


