//
//  FirstViewController.m
//  TestProject
//
//  Created by douchuanjiang on 16/5/3.
//  Copyright (c) 2016年 douchuanjiang. All rights reserved.
//

#import "FirstViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "SecondeViewController.h"

@interface FirstViewController ()
{
    UIVisualEffectView *_testVisualView;
    UILabel *bottomLabel;
    UILabel *upLabel;
    BOOL    testFlag;
}

@property (strong, nonatomic) IBOutlet UILabel *testLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *testScrollView;
@property (strong, nonatomic) CALayer *maskLayer;

@end

@implementation FirstViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"FirstViewController";
    
    UIImageView *testImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    testImg.image = [UIImage imageNamed:@"3"];
    [self.testScrollView addSubview:testImg];
    
//    _testVisualView = [[UIVisualEffectView alloc] initWithEffect:[UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]]];
    _testVisualView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    _testVisualView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-64-101);
    _testVisualView.backgroundColor = [UIColor colorWithRed:0.01 green:0.02 blue:0.03 alpha:0.8];
    _testVisualView.alpha = 0.95;
    
    [self.view addSubview:_testVisualView];
    
    UIButton *tmpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tmpBtn.frame = CGRectMake(50, 80, 100, 40);
    [tmpBtn setTitle:@"test" forState:UIControlStateNormal];
    [_testVisualView.contentView addSubview:tmpBtn];
    
    bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 111, 300, 50)];
    bottomLabel.font = [UIFont systemFontOfSize:15];
    bottomLabel.backgroundColor = [UIColor clearColor];
    bottomLabel.numberOfLines = 2;
    bottomLabel.textColor = [UIColor whiteColor];
    bottomLabel.text = @"这是一个测试的label是一个测试的label是一个测试的label是一个测试的label";
    [self.view addSubview:bottomLabel];
    
    upLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 111, 300, 50)];
    upLabel.numberOfLines = 2;
    upLabel.backgroundColor = [UIColor clearColor];
    upLabel.font = [UIFont systemFontOfSize:15];
    upLabel.textColor = [UIColor greenColor];
    upLabel.text = @"这是一个测试的label是一个测试的label是一个测试的label是一个测试的label";
    [self.view addSubview:upLabel];
    
    self.maskLayer = [CALayer layer];
    self.maskLayer.anchorPoint = CGPointZero;
    self.maskLayer.bounds = CGRectMake(0, 0, 0, 25);
    self.maskLayer.backgroundColor = [UIColor whiteColor].CGColor;
    upLabel.layer.mask = self.maskLayer;
    
    self.testScrollView.contentOffset = CGPointMake(self.view.frame.size.width, 0);
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.testScrollView.contentSize = CGSizeMake(self.view.frame.size.width * 3, self.view.frame.size.height);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
}

- (IBAction) next:(id)sender
{
//    SecondeViewController *second = [[SecondeViewController alloc] init];
//    [self.navigationController pushViewController:second animated:YES];
}

- (IBAction) startAnimation:(id)sender
{
    testFlag = NO;
//    CABasicAnimation
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"bounds.size.width"];
    NSMutableArray *keyTimeArray = [NSMutableArray array];
    NSMutableArray *widthArray = [NSMutableArray array];
    //NSMutableArray *widthArray = [NSMutableArray arrayWithObjects:@"30",@"60",@"90",@"120",@"150",@"180", nil];
    for (NSInteger i = 0; i < 11 ; i ++) {
        //此处必须用NSNumber格式
        CGFloat time = i*0.1;
        [keyTimeArray addObject:@(time)];
//        if (i < 6)
        [widthArray addObject:@(time*300)];
    }
    
    animation.values = widthArray;
    animation.keyTimes = keyTimeArray;
    animation.duration = 10;
    animation.calculationMode = kCAAnimationLinear;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.delegate = self;
    [self.maskLayer addAnimation:animation forKey:@"MaskAnimation"];
}

- (void)animationDidStart:(CAAnimation *)anim
{

    NSLog(@"动画开始了");
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"动画结束了要");
    
    self.maskLayer.bounds = CGRectMake(0, 0, 0, 25);
    if (!testFlag) {
        [self startAnimation:nil];
    }
}

- (IBAction)valueChanged:(id)sender
{
    UISlider *tmpSlider = (UISlider *)sender;
    _testVisualView.alpha = tmpSlider.value*0.05+0.95;
}

- (IBAction) removeAnimation:(id)sender
{
    testFlag = YES;
   [self.maskLayer removeAnimationForKey:@"MaskAnimation"];
    
    UIGraphicsBeginImageContextWithOptions([[UIScreen mainScreen] bounds].size, YES, [UIScreen mainScreen].scale);
    [[UIApplication sharedApplication].keyWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *newImgView = [[UIImageView alloc] initWithImage:image];
    newImgView.frame = CGRectMake(200, 200, 200, 200*16/9);
    [self.view addSubview:newImgView];
    
    
}

@end
