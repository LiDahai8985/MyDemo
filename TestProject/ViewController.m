//
//  ViewController.m
//  TestProject
//
//  Created by douchuanjiang on 16/4/18.
//  Copyright © 2016年 douchuanjiang. All rights reserved.
//

#import "ViewController.h"
#import "FirstViewController.h"
#import "MMNavigationController.h"
#import "CustomeView.h"
#import "MusicPlayingAnimationView.h"

@interface ViewController ()
{
    MusicPlayingAnimationView *pathView;
    BOOL showAnimation;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"Home";
    // Do any additional setup after loading the view, typically from a nib.
//    
//    NSLog(@"---------->1");
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"------------>2");
//        dispatch_sync(dispatch_get_main_queue(), ^{
//                        NSLog(@"=================2"); });
//    });
//    NSLog(@"------------->3");



//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSLog(@"=================1");
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            NSLog(@"=================2"); });
//        NSLog(@"=================3"); });
    
//    dispatch_group_t group = dispatch_group_create();
//    
//    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
//        NSLog(@"---------------1");
//    });
//    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
//        NSLog(@"---------------2");
//    });
//    
//    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        
//        NSLog(@"------------->3");
//        
//        dispatch_group_t group1 = dispatch_group_create();
//        
//        dispatch_group_async(group1, dispatch_get_global_queue(0, 0), ^{
//            NSLog(@"------------->4");
//        });
//        
//        dispatch_group_async(group1, dispatch_get_global_queue(0, 0), ^{
//            NSLog(@"----------->5");
//        });
//    });
    
    
    //bezierPath
    pathView = [[MusicPlayingAnimationView alloc] initWithFrame:CGRectMake(50, 200, 200, 200)];
    pathView.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:pathView];
    
}


- (IBAction)btnTapped:(id)sender
{
    showAnimation = !showAnimation;
    [pathView showWithAnimation:showAnimation];
    UIView *statusBarView = [[UIApplication sharedApplication] valueForKey:@"statusBar"];
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:statusBarView.bounds];
    tipLabel.backgroundColor = [UIColor blackColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.text = @"点击这里，快速回到顶部";
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.font = [UIFont systemFontOfSize:13];
    tipLabel.alpha = 0.0f;
    
    [statusBarView addSubview:tipLabel];
    
    [UIView animateWithDuration:0.3 animations:^{
        tipLabel.alpha = 1.0;
    } completion:^(BOOL finished) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                tipLabel.alpha = 0.0;
            }];
        });
        
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSLog(@"----->%@",segue.identifier);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
