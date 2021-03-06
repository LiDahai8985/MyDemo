//
//  MMNavigationController.m
//  TestProject
//
//  Created by douchuanjiang on 16/5/6.
//  Copyright (c) 2016年 douchuanjiang. All rights reserved.
//

#import "MMNavigationController.h"
#import "MMSuperViewController.h"

@interface MMNavigationController ()

@property (strong, nonatomic) UIPercentDrivenInteractiveTransition *percentDriven;
@property (assign, nonatomic) BOOL isInteractiving;
@property (assign, nonatomic) BOOL isAllowSwipOut;
@property (strong, nonatomic) UIViewController *mmTopViewController;

@end

@implementation MMNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //默认隐藏导航条
    self.navigationBarHidden = NO;
    
    //控制器切换controller到控制对象
    self.percentDriven = [[UIPercentDrivenInteractiveTransition alloc] init];
    self.delegate = self;
    
    //添加滑动手势
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerAction:)]];
    
    // 移除某些子viewController
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(msg_viewControllersChanged)
                                                 name:@"12345"
                                               object:nil];
}

- (void)msg_viewControllersChanged
{
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    [array addObject:self.viewControllers[1]];
    [array addObject:self.viewControllers.lastObject];
    [self setViewControllers:array];
}

- (void )setMmTopViewController:(UIViewController *)mmTopViewController
{
    _mmTopViewController = mmTopViewController;
}

- (BOOL)isAllowSwipOut
{
    return !([self.mmTopViewController isKindOfClass:[MMSuperViewController class]] && !((MMSuperViewController *)self.mmTopViewController).allowSwipOut);
}

/**nav不会将 preferredStatusBarStyle方法调用转给它的子视图,而是由它自己管理状态
 *所以此方法只在nav的子viewController里面写是不行的，要在nav中进行处理
 **/
//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return [self.visibleViewController preferredStatusBarStyle];
//}


#pragma mark-  手势动作处理

- (void)panGestureRecognizerAction:(UIPanGestureRecognizer *)gestureRecognizer
{
    UIView* view = self.view;
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    
    NSLog(@"\n----->panGestureRecognizerAction<-----\n----->mmTopViewController----->:%@\n----->topViewController----->:%@\n----->velocityInView----->:%f\n----->translation----->:%f",NSStringFromClass([self.mmTopViewController class]),NSStringFromClass([self.topViewController class]),[gestureRecognizer velocityInView:view].x,translation.x);
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            self.isInteractiving = YES;
            
            /****  此处设置mmTopViewController来记录当前处于正在滑动退出的页面，
             因为每次手势滑动开始时会立即执行popViewControllerAnimated:方法，此时
             self.topViewController会发生变化   ****/
            self.mmTopViewController = self.topViewController;
            //nav内有子viewController时 允许滑动的状态  向右滑动 三个条件同时满足时才执行pop
            if (self.viewControllers.count > 1 && self.isAllowSwipOut && [gestureRecognizer velocityInView:view].x > 0) {
                [self popViewControllerAnimated:YES];
                NSLog(@"*********************");
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            
            //允许滑动才执行跟随改变的动作
            if (self.isAllowSwipOut) {
                //防止向左滑动返回到边界后继续左滑页面弹起
                if (translation.x < 10) {
                    [self.percentDriven updateInteractiveTransition:0];
                }
                else {
                    CGFloat fraction = fabs(translation.x / view.bounds.size.width);
                    [self.percentDriven updateInteractiveTransition:fraction];
                }
            }
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            self.isInteractiving = NO;
            CGFloat fraction = fabs(translation.x / view.bounds.size.width);
            
            //当滑动很快或者华东距离大于一般屏幕距离时执行pop操作，否则返回原状态
            
            if (self.isAllowSwipOut && (fraction > 0.5 || [gestureRecognizer velocityInView:view].x >180)) {
                [self.percentDriven finishInteractiveTransition];
            } else {
                [self.percentDriven cancelInteractiveTransition];
            }
            self.mmTopViewController = nil;
            break;
        }
        default:
            break;
    }
}


#pragma mark-  UINavigationControllerDelegate

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPop) {
        return [[TransitionPushAnimation alloc] init];
    }
    return nil;
}

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    //没有通过手动交互（如手势滑动）时，要返回空，有交互时，返回当前交互的对象
    return self.isInteractiving ? self.percentDriven:nil;
}

#pragma mark- UIDevice

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    if (self.topViewController) {
        return [self.topViewController supportedInterfaceOrientations];
    }
    else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

@end





@implementation TransitionPushAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.25;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
    //－－－－－－图层效果－－－－－－
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
    
    //－－－－－－－－3D效果－－－－－－－－－－
//    CATransform3D viewFromTransform = CATransform3DMakeRotation(-M_PI/2, 0, 1, 0);
//    CATransform3D viewToTransform = CATransform3DMakeRotation(M_PI/2, 0, 1, 0);
//    viewFromTransform.m34 = -1.0/200;
//    viewToTransform.m34 = -1.0/200;
//    
//    
//    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//    UIView *container = [transitionContext containerView];
//    
//    [toVC.view.layer setAnchorPoint:CGPointMake(1, 0.5)];
//    [fromVC.view.layer setAnchorPoint:CGPointMake(0, 0.5)];
//    
//    toVC.view.layer.transform = viewToTransform;
//    
//    [container addSubview:toVC.view];
//    container.transform = CGAffineTransformMakeTranslation(-container.frame.size.width/2.0,0);
//    
//    
//    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
//        
//        
//        fromVC.view.layer.transform = viewFromTransform;
//        toVC.view.layer.transform = CATransform3DIdentity;
//        [container setTransform:CGAffineTransformMakeTranslation(container.frame.size.width/2.0, 0)];
//        
//        
//    } completion:^(BOOL finished) {
//        
//        
//        fromVC.view.layer.transform = CATransform3DIdentity;
//        toVC.view.layer.transform = CATransform3DIdentity;
//        [fromVC.view.layer setAnchorPoint:CGPointMake(0.5f, 0.5f)];
//        [toVC.view.layer setAnchorPoint:CGPointMake(0.5f, 0.5f)];
//        [container setTransform:CGAffineTransformIdentity];
//        
//        [transitionContext completeTransition:YES];
//    }];
    
    //－－－－－－－正常push pop效果－－－－－－－
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    //给将要pop出的viewcontroller的view添加阴影
    fromVC.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:fromVC.view.frame].CGPath;
    fromVC.view.layer.shadowColor = [UIColor blackColor].CGColor;
    fromVC.view.layer.shadowOffset = CGSizeMake(-3, 0);
    fromVC.view.layer.shadowOpacity = 0.2;
    fromVC.view.layer.shadowRadius = 2.0;
    
    //设置将要出现的viewcontroller的view的起始坐标
    toVC.view.frame = CGRectOffset([transitionContext finalFrameForViewController:toVC], -toVC.view.frame.size.width/3, 0);
    
    [containerView addSubview:toVC.view];
    [containerView addSubview:fromVC.view];
    
    //控制pop出的view的边界阴影淡化
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
//    animation.duration = [self transitionDuration:transitionContext];
//    animation.fromValue = [NSNumber numberWithFloat:0.2];
//    animation.toValue = [NSNumber numberWithFloat:0.0];
//    [fromVC.view.layer addAnimation:animation forKey:@"FromViewAnimation"];

    
    //控制viewController的view的动画移动
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toVC.view.frame  = [transitionContext finalFrameForViewController:toVC];
        fromVC.view.frame = CGRectMake(fromVC.view.frame.size.width, 0, fromVC.view.frame.size.width, fromVC.view.frame.size.height);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];

}


@end
