//
//  HalfPageScrollView.m
//  MyDemo
//
//  Created by LiDaHai on 16/11/23.
//  Copyright © 2016年 douchuanjiang. All rights reserved.
//

#import "HalfPageScrollView.h"

// 半屏滑动效果的“scrollView”
@interface HalfPageScrollView ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation HalfPageScrollView

// 重写响应事件
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    
    if ([view isEqual:self]) {
        for (UIView *subView in self.scrollView.subviews) {
            CGPoint offset = CGPointMake(point.x - self.scrollView.frame.origin.x + self.scrollView.contentOffset.x - subView.frame.origin.x, point.y - self.scrollView.frame.origin.y + self.scrollView.contentOffset.y - subView.frame.origin.y);
            
            if ((view = [subView hitTest:offset withEvent:event])) {
                return view;
            }
        }
        return self.scrollView;
    }
    
    return view;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/4, 0, CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame))];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.pagingEnabled = YES;
        _scrollView.clipsToBounds = NO;
        [self addSubview:_scrollView];
    }
    
    return _scrollView;
}

- (void)addImages:(NSArray <UIImage *> *)imageArray
{
    // 清除之前的view
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 添加图片
    [imageArray enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imageView  = [[UIImageView alloc] initWithImage:obj];
        imageView.frame = CGRectMake(idx * CGRectGetWidth(self.frame)/2.0, 0, CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame));
        imageView.backgroundColor = [UIColor clearColor];
        [self.scrollView addSubview:imageView];
    }];
    
    // 改变scrollView的contentSize
    self.scrollView.contentSize = CGSizeMake(imageArray.count*(CGRectGetWidth(self.frame)/2.0), 0);
}

@end
