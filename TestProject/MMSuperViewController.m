//
//  MMSuperViewController.m
//  TestProject
//
//  Created by LiDaHai on 16/5/12.
//  Copyright © 2016年 douchuanjiang. All rights reserved.
//

#import "MMSuperViewController.h"

@interface MMSuperViewController ()

@end

@implementation MMSuperViewController

- (void)dealloc
{
    NSLog(@"------%@释放了------",NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //默认允许滑动退出当前页面
    self.allowSwipOut = YES;
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

#pragma mark- 

- (BOOL)shouldAutorotate {
    return YES;
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
