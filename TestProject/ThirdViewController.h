//
//  ThirdViewController.h
//  TestProject
//
//  Created by LiDaHai on 16/5/16.
//  Copyright © 2016年 douchuanjiang. All rights reserved.
//

#import "MMSuperViewController.h"

@protocol ThirdSelectTimeDelegate <NSObject>

- (void)didSelectTime:(NSInteger)time;

@end



@interface ThirdViewController : MMSuperViewController

@property (weak, nonatomic) id<ThirdSelectTimeDelegate> t_delegate;

@end
