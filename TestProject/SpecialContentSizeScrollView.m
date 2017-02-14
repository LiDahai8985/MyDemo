//
//  SpecialContentSizeScrollView.m
//  MyDemo
//
//  Created by LiDaHai on 16/11/23.
//  Copyright © 2016年 douchuanjiang. All rights reserved.
//

#import "SpecialContentSizeScrollView.h"

@implementation SpecialContentSizeScrollView

- (BOOL)touchesShouldBegin:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
    return YES;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.contentOffset.y < -150) {
        return;
    }
    [super touchesMoved:touches withEvent:event];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}
@end
