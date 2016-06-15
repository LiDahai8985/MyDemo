//
//  MMNavigationController.h
//  TestProject
//
//  Created by douchuanjiang on 16/5/6.
//  Copyright (c) 2016年 douchuanjiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMNavigationController : UINavigationController<UINavigationControllerDelegate>


@end


//push动画
@interface TransitionPushAnimation : NSObject<UIViewControllerAnimatedTransitioning>

@end