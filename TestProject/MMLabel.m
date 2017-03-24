//
//  MMLabel.m
//  MyDemo
//
//  Created by LiDaHai on 17/2/28.
//  Copyright © 2017年 douchuanjiang. All rights reserved.
//

#import "MMLabel.h"

@implementation MMLabel


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self becomeFirstResponder];
        
        UIMenuController *menu = [UIMenuController sharedMenuController];
        UIMenuItem *item0 = [[UIMenuItem alloc] initWithTitle:@"选择" action:@selector(search:)];
//        UIMenuItem *item1 = [[UIMenuItem alloc] initWithTitle:@"选全部" action:@selector(searchall:)];
        UIMenuItem *item2 = [[UIMenuItem alloc] initWithTitle:@"打印选中文字" action:@selector(logSelectedText:)];
        
        [menu setMenuItems:@[
                             item0,
//                             item1,
                             item2]];
    }
    return self;
}

- (void)logSelectedText:(id)sender
{
    NSLog(@"logSelectedText");
}

- (void)search:(id)sender
{
    
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)becomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(nullable id)sender
{
    if (action == @selector(search:) || action == @selector(logSelectedText:) || action == @selector(copy:)) {
        [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
        return YES;
    }
    return NO;
}


@end
