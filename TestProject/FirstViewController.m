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


@interface FirstViewController ()<UIScrollViewDelegate>
{
    UIVisualEffectView *_testVisualView;
    UILabel *bottomLabel;
    UILabel *upLabel;
    BOOL    testFlag;
}

@property (strong, nonatomic) IBOutlet UIView *testView;
@property (strong, nonatomic) IBOutlet UIView *testMaskView;
@property (strong, nonatomic) IBOutlet UIScrollView *testScrollView;
@property (strong, nonatomic) CALayer *maskLayer;
@property (strong, nonatomic) CALayer *testViewMaskLayer;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation FirstViewController

- (void)timeUp
{
    NSLog(@"timeUp");
//    [self.timer invalidate];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"FirstViewController";
    
    // 注意与scheduledTimerWithTimeInterval区别，scheduledTimerWithTimeInterval无需手动添加到当前运行循环下
    /* 通过timerwithTimeInterval:invocation :repeats
     timerWithTimeInterval:taeget:selector:userInfo:repeats
     initWithFireDate:interval:target:selector:userInfo:repeats:
     类方法创建的timer对象没有安排在一个运行循环中，你必须通过运行时对象对应的方法addTimer:forMode:人为的把这个timer添加进那个运行时。
    */
    self.timer = [NSTimer timerWithTimeInterval:0.3 target:self selector:@selector(timeUp) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    UIImageView *testImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    testImg.image = [UIImage imageNamed:@"3"];
    [self.testScrollView addSubview:testImg];
    
//    _testVisualView = [[UIVisualEffectView alloc] initWithEffect:[UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]]];
    _testVisualView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    _testVisualView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-64-101);
    _testVisualView.backgroundColor = [UIColor colorWithRed:0.01 green:0.02 blue:0.03 alpha:0.8];
    _testVisualView.alpha = 0.95;
    
    [self.view insertSubview:_testVisualView aboveSubview:_testScrollView];
    
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
    self.maskLayer.bounds = CGRectMake(0, 0, 0, 35);
    self.maskLayer.backgroundColor = [UIColor whiteColor].CGColor;
    upLabel.layer.mask = self.maskLayer;
    
    self.testScrollView.contentOffset = CGPointMake(self.view.frame.size.width, 0);
    
//    self.testMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 450, 100)];
//    self.testMaskView.backgroundColor = [UIColor redColor];
//    self.testView.maskView = self.testMaskView;
    
    self.testViewMaskLayer = [CALayer layer];
    self.testViewMaskLayer.frame = CGRectMake(0, 0, 50, 130);
    self.testViewMaskLayer.backgroundColor = [UIColor redColor].CGColor;
    self.testView.layer.mask = self.testViewMaskLayer;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandler:)];
    [self.testView addGestureRecognizer:pan];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.testScrollView.contentSize = CGSizeMake(self.view.frame.size.width * 3, self.view.frame.size.height);
}

- (void)panGestureHandler:(UIPanGestureRecognizer *)pan
{
    CGPoint point = [pan locationInView:self.testView];
    self.testViewMaskLayer.frame = CGRectMake(point.x, 0, 50, 130);
}

- (IBAction) next:(id)sender
{
//    SecondeViewController *second = [[SecondeViewController alloc] init];
//    [self.navigationController pushViewController:second animated:YES];
    
    
    // 调用系统视频编辑功能
    NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"9_16" ofType:@"mp4"];
    if ([UIVideoEditorController canEditVideoAtPath:videoPath])
    {
        UIVideoEditorController *vc = [[UIVideoEditorController alloc] init];
        vc.videoPath = videoPath;
        [self.navigationController presentViewController:vc animated:YES completion:^{
            
        }];
    }
}

- (IBAction) startAnimation:(id)sender
{
    
    UIButton *btn = (UIButton *)sender;
    [btn setTitle:@"测试" forState:UIControlStateNormal];
    
    
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
    
    // 截图
    UIGraphicsBeginImageContextWithOptions([[UIScreen mainScreen] bounds].size, YES, [UIScreen mainScreen].scale);
    [[UIApplication sharedApplication].keyWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *newImgView = [[UIImageView alloc] initWithImage:[self pixellateImageWithImage:image]];
    newImgView.frame = CGRectMake(200, 200, 200, 200*16/9);
    [self.view addSubview:newImgView];
    
    
}

- (UIImage *)pixellateImageWithImage:(UIImage *)image
{
    CIImage *ciImage = [[CIImage alloc]initWithImage:[UIImage imageNamed:@"3"]];   // 这里特别注意的是  必须要用.png格式的图片  否则加载不出来。
    
    //创建filter 滤镜 马赛克效果
    CIFilter *fileter = [CIFilter filterWithName:@"CIPixellate"];
    [fileter setValue:ciImage forKey:kCIInputImageKey];
    [fileter setDefaults];
    
    //导出图片
    CIImage *outPutImage = [fileter valueForKey:kCIOutputImageKey];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef cgImage = [context createCGImage:outPutImage fromRect:[outPutImage extent]];
    
    UIImage *finalImage = [UIImage imageWithCGImage:cgImage];
    
    // CGImage 并不支持ARC  需要手动释放
    CGImageRelease(cgImage);
    
    return finalImage;
}

#pragma mark- UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < -30) {
        scrollView.contentOffset = CGPointMake(0, -30);
    } else if (scrollView.contentOffset.y > 30) {
        scrollView.contentOffset = CGPointMake(0, 30);
    }
}

@end
