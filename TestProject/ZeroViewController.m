//
//  ViewController.m
//  TestProject
//
//  Created by douchuanjiang on 16/4/18.
//  Copyright © 2016年 douchuanjiang. All rights reserved.
//

#import "ZeroViewController.h"
#import "FirstViewController.h"
#import "MMNavigationController.h"
#import "CustomeView.h"
#import "MusicPlayingAnimationView.h"
#import "LoadingHUD.h"
#import "NSDate+InternetDateTime.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManager.h>
#import <sys/sysctl.h>

@interface ZeroViewController ()<CAAnimationDelegate,CLLocationManagerDelegate,CALayerDelegate>
{
    MusicPlayingAnimationView *pathView;
    BOOL showAnimation;
}

@property (weak, nonatomic) IBOutlet UIView *testViewLeft;
@property (weak, nonatomic) IBOutlet UIView *testViewMid;
@property (weak, nonatomic) IBOutlet UIView *testViewRight;
@property (weak, nonatomic) IBOutlet CustomeView *customeView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;

@end

@implementation ZeroViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"Home";
    // Do any additional setup after loading the view, typically from a nib.

    
    [self.locationManager requestWhenInUseAuthorization];
    // 线程锁死
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
    pathView = [[MusicPlayingAnimationView alloc] initWithFrame:CGRectMake(0, 200, 100, 100)];
    pathView.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:pathView];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(systemClockDidChange:) name:NSSystemClockDidChangeNotification object:nil];
    
    // 自定义加载动画
    //[LoadingHUD showHUD];
}

- (void)systemClockDidChange:(NSNotification *)notification
{
    NSLog(@"--->%@",notification);
}


- (time_t)uptime
{
//    struct timeval boottime;
//    int mib[2] = {CTL_KERN, KERN_BOOTTIME};
//    size_t size = sizeof(boottime);
//    time_t now;
//    time_t uptime = -1;
//    
//    (void)time(&now);
//    
//    if (sysctl(mib, 2, &boottime, &size, NULL, 0) != -1 && boottime.tv_sec != 0)
//    {
//        uptime = now - boottime.tv_sec;
//    }
//    return uptime;
    
    
    // [NSProcessInfo processInfo].systemUptime
    // UIApplicationSignificantTimeChangeNotification
    // http://stackoverflow.com/questions/1444456/is-it-possible-to-get-the-atomic-clock-timestamp-from-the-iphone-gps
    // http://stackoverflow.com/questions/9564823/internal-clock-in-iphone-background-mode/9744686#9744686
    // http://stackoverflow.com/questions/12488481/getting-ios-system-uptime-that-doesnt-pause-when-asleep/12490414#12490414
    // http://stackoverflow.com/questions/10331020/get-the-boot-time-in-objective-c/10331716#10331716
    struct timeval boottime;
    size_t size = sizeof(boottime);
    int ret = sysctlbyname("kern.boottime", &boottime, &size, NULL, 0);
    assert(ret == 0);
    return boottime.tv_sec;
    
}

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return  _locationManager;
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    if (locations && locations.count > 0) {
        self.currentLocation = locations[0];
        NSLog(@"-----定位成功---");
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"------定位失败-------%@",error);
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    // 执行动画
    [self performSelector:@selector(startCRoundLoadingAnimation) withObject:nil afterDelay:1];
    [self performSelector:@selector(startPaperclipLoadingAnimation) withObject:nil afterDelay:1];
}


// 回形 loading动画
- (void)startPaperclipLoadingAnimation
{
    //    if (self.testViewLeft.frame.size.height < 110) {
    //        self.testViewLeft.bounds = CGRectMake(0, 0, 110, 110);
    //    }
    
    
    // 清除上次添加的子视图视图
    [self.testViewLeft.layer.sublayers makeObjectsPerformSelector:@selector(removeAllAnimations)];
    [self.testViewLeft.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    // 方形动画变换到圆形
    if (self.testViewLeft.bounds.size.height != 100) {
        CABasicAnimation *cornerAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
        cornerAnimation.toValue = [NSNumber numberWithFloat:50.0];
        cornerAnimation.duration = 0.3;
        cornerAnimation.removedOnCompletion = NO;
        cornerAnimation.fillMode = kCAFillModeForwards;
        cornerAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [self.testViewLeft.layer addAnimation:cornerAnimation forKey:@"cornerAnimation"];
        [self.testViewRight.layer addAnimation:cornerAnimation forKey:@"cornerAnimation"];
    }

    
    //usingSpringWithDamping 阻尼 阻碍越大弹性变化范围越小反之变化越大
    //initialSpringVelocity  弹簧动画的速率（动力），越大弹簧拉或压的幅度（形变）越大
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.01 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.testViewLeft.bounds = CGRectMake(0, 0, 100, 100);
        self.testViewRight.bounds = CGRectMake(0, 0, 100, 100);
        [self.testViewLeft layoutIfNeeded];
    } completion:^(BOOL finished) {
        
        
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.fromValue = @(1);
        opacityAnimation.toValue = @(0);
        opacityAnimation.removedOnCompletion = NO;
        opacityAnimation.fillMode = kCAFillModeForwards;
        opacityAnimation.duration = 1.5;
        opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [self.testViewRight.layer addAnimation:opacityAnimation forKey:@"opacityAnimation"];
        
        // 线条动画
        
        // 绘制路径
        UIBezierPath *linePath1 = [UIBezierPath bezierPath];
        //            [linePath1 moveToPoint:CGPointMake(40, 50)];
        //            [linePath1 addLineToPoint:CGPointMake(50, 180)];
        //            [linePath1 addLineToPoint:CGPointMake(200, 180)];
        //            [linePath1 addLineToPoint:CGPointMake(210, 50)];
        //
        //            [linePath1 addLineToPoint:CGPointMake(50, 50)];
        //            [linePath1 addLineToPoint:CGPointMake(60, 170)];
        //            [linePath1 addLineToPoint:CGPointMake(190, 170)];
        //            [linePath1 addLineToPoint:CGPointMake(200, 60)];
        //
        //            [linePath1 addLineToPoint:CGPointMake(60, 60)];
        //            [linePath1 addLineToPoint:CGPointMake(70, 160)];
        //            [linePath1 addLineToPoint:CGPointMake(180, 160)];
        //            [linePath1 addLineToPoint:CGPointMake(190, 70)];
        //
        //            [linePath1 addLineToPoint:CGPointMake(70, 70)];
        //            [linePath1 addLineToPoint:CGPointMake(80, 150)];
        //            [linePath1 addLineToPoint:CGPointMake(170, 150)];
        //            [linePath1 addLineToPoint:CGPointMake(180, 80)];
        //
        //            [linePath1 addLineToPoint:CGPointMake(80, 80)];
        //            [linePath1 addLineToPoint:CGPointMake(90, 140)];
        //            [linePath1 addLineToPoint:CGPointMake(160, 140)];
        //            [linePath1 addLineToPoint:CGPointMake(170, 90)];
        //
        //            [linePath1 addLineToPoint:CGPointMake(90, 90)];
        //            [linePath1 addLineToPoint:CGPointMake(100, 130)];
        //            [linePath1 addLineToPoint:CGPointMake(150, 130)];
        //            [linePath1 addLineToPoint:CGPointMake(160, 100)];
        //
        //            [linePath1 addLineToPoint:CGPointMake(100, 100)];
        //            [linePath1 addLineToPoint:CGPointMake(110, 120)];
        //            [linePath1 addLineToPoint:CGPointMake(140, 120)];
        //            [linePath1 addLineToPoint:CGPointMake(150, 110)];
        //
        //            [linePath1 addLineToPoint:CGPointMake(130, 110)];
        //            [linePath1 addLineToPoint:CGPointMake(130, 300)];
        
        
        // 绘制路径
        [linePath1 moveToPoint:CGPointMake(67, 150)];
        [linePath1 addLineToPoint:CGPointMake(67, 30)];
        [linePath1 addArcWithCenter:CGPointMake(52, 30) radius:15 startAngle:0 endAngle:(180*M_PI/180.0) clockwise:NO];
        [linePath1 addLineToPoint:CGPointMake(37, 70)];
        [linePath1 addArcWithCenter:CGPointMake(47, 70) radius:10 startAngle:(-180*M_PI/180.0) endAngle:0 clockwise:NO];
        [linePath1 addLineToPoint:CGPointMake(57, 40)];
        [linePath1 addArcWithCenter:CGPointMake(52, 40) radius:5 startAngle:0 endAngle:(-180*M_PI/180.0) clockwise:NO];
        [linePath1 addLineToPoint:CGPointMake(47, 100)];
        
        // 绘制线
        CAShapeLayer *lineLayer = [CAShapeLayer layer];
        lineLayer.path = linePath1.CGPath;
        lineLayer.strokeColor = [UIColor whiteColor].CGColor;
        [lineLayer setFillColor:[UIColor clearColor].CGColor];
        lineLayer.lineCap = kCALineCapRound; // 线头形状
        lineLayer.lineWidth = 3; // 线宽
        lineLayer.lineJoin = kCALineJoinBevel; // 线段拐点形状
        [self.testViewLeft.layer addSublayer:lineLayer];
        
        
        // 线终点的位置变化
        CABasicAnimation *lineAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        lineAnimation.fromValue = @(0.0f);
        lineAnimation.toValue = @(0.8);
        lineAnimation.duration = 0.6;
        lineAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        lineAnimation.removedOnCompletion = NO;
        lineAnimation.repeatCount = INFINITY;
        lineAnimation.delegate = self;
        lineAnimation.fillMode = kCAFillModeForwards;
        [lineAnimation setValue:@"lineAnimation1" forKey:@"lineAnimation1"];
        [lineLayer addAnimation:lineAnimation forKey:@"lineAnimation1"];
        
        // 线的起点位置变化
        CABasicAnimation *lineAnimation2 = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
        lineAnimation2.fromValue = @(0.0);
        lineAnimation2.toValue = @(0.25f);
        lineAnimation2.duration = 0.65;
        lineAnimation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        lineAnimation2.removedOnCompletion = NO;
        lineAnimation2.fillMode = kCAFillModeForwards;
        [lineLayer addAnimation:lineAnimation2 forKey:@"lineAnimation2"];
        
    }];

}

// 追赶形 "C"形圆loading
- (void)startCRoundLoadingAnimation
{
    [self.testViewMid.layer.sublayers makeObjectsPerformSelector:@selector(removeAllAnimations)];
    [self.testViewMid.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self.testViewMid.layer removeAllAnimations];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.testViewMid.bounds = CGRectMake(0, 0, 100, 100);
        self.testViewMid.layer.cornerRadius = 50;
        
        // 线条动画
        CAShapeLayer *loadingLayer = [CAShapeLayer layer];
        loadingLayer.lineCap = kCALineJoinRound;
        loadingLayer.lineWidth = 4;
        loadingLayer.strokeColor = [UIColor whiteColor].CGColor;
        loadingLayer.fillColor = [UIColor clearColor].CGColor;
        
        [self.testViewMid.layer addSublayer:loadingLayer];
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(20, 50)];
        [path addArcWithCenter:CGPointMake(50, 50) radius:30 startAngle:(180*M_PI/180.0) endAngle:-(181*M_PI/180.0) clockwise:YES];
        
        loadingLayer.path = path.CGPath;
        
        CABasicAnimation *startAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
        startAnimation.fromValue = @(0.0);
        startAnimation.toValue = @(0.1);
        startAnimation.duration = 0.7;
        startAnimation.removedOnCompletion = NO;
        startAnimation.fillMode = kCAFillModeForwards;
//        startAnimation.repeatCount = INFINITY;
        startAnimation.delegate = self;
        startAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [startAnimation setValue:@"startAnimation" forKey:@"startAnimation"];
        [loadingLayer addAnimation:startAnimation forKey:@"startAnimation"];
        
        
        CABasicAnimation *endAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        endAnimation.fromValue = @(0.05);
        endAnimation.toValue = @(1.0);
        endAnimation.duration = 0.7;
        endAnimation.removedOnCompletion = NO;
        endAnimation.fillMode = kCAFillModeForwards;
        endAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [loadingLayer addAnimation:endAnimation forKey:@"endAnimation"];
        
        
        CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        transformAnimation.fromValue = @(0);
        transformAnimation.toValue = @(2*M_PI);
        transformAnimation.duration = 1.46;
        transformAnimation.removedOnCompletion = NO;
        transformAnimation.fillMode = kCAFillModeForwards;
        transformAnimation.repeatCount = INFINITY;
        transformAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [self.testViewMid.layer addAnimation:transformAnimation forKey:@"transformAnimation"];
        
    });
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([[anim valueForKey:@"lineAnimation1"] isEqualToString:@"lineAnimation1"]) {
        for (CALayer *lineLayer in self.testViewLeft.layer.sublayers) {
            if (lineLayer) {
                
                CABasicAnimation *lineAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
                lineAnimation.fromValue = @(0.8f);
                lineAnimation.toValue = @(1.0);
                lineAnimation.duration = 0.5;
                lineAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                lineAnimation.removedOnCompletion = NO;
                lineAnimation.delegate = self;
                lineAnimation.fillMode = kCAFillModeForwards;
                [lineLayer addAnimation:lineAnimation forKey:@"lineAnimation11"];
                
                CABasicAnimation *lineAnimation22 = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
                lineAnimation22.fromValue = @(0.25);
                lineAnimation22.toValue = @(1.0f);
                lineAnimation22.duration = 0.7;
                lineAnimation22.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                lineAnimation22.removedOnCompletion = NO;
                lineAnimation22.fillMode = kCAFillModeForwards;
                lineAnimation22.delegate = self;
                [lineAnimation22 setValue:@"lineAnimation22" forKey:@"lineAnimation22"];
                [lineLayer addAnimation:lineAnimation22 forKey:@"lineAnimation22"];
            }
        }
    } else if ([[anim valueForKey:@"lineAnimation22"] isEqualToString:@"lineAnimation22"]) {
        [self startPaperclipLoadingAnimation];
    } else if ([[anim valueForKey:@"startAnimation"] isEqualToString:@"startAnimation"]) {
        for (CALayer *lineLayer in self.testViewMid.layer.sublayers) {
            if (lineLayer) {
                
                CABasicAnimation *startAnimation1 = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
                startAnimation1.fromValue = @(0.1);
                startAnimation1.toValue = @(0.95f);
                startAnimation1.duration = 0.8;
                startAnimation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                startAnimation1.removedOnCompletion = NO;
                startAnimation1.fillMode = kCAFillModeForwards;
                startAnimation1.delegate = self;
                [startAnimation1 setValue:@"strokeStart1" forKey:@"strokeStart1"];
                [lineLayer addAnimation:startAnimation1 forKey:@"strokeStart1"];
            }
        }
    } else if ([[anim valueForKey:@"strokeStart1"] isEqualToString:@"strokeStart1"]) {
        [self startCRoundLoadingAnimation];
    }
}

- (IBAction)btnTapped:(id)sender
{
    // 围绕x轴旋转
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.fromValue = @(0);
    animation.toValue = @(M_PI);
    animation.duration = 1;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [self.testViewLeft.layer addAnimation:animation forKey:@"testLeft"];
    return;
    
    /********/
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
    
    [self.customeView startAnimation];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    NSDate *bootDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:[self uptime]/1000];
    
//    CLLocation *location = [[CLLocation alloc] initWithLatitude:self.currentLocation.coordinate.latitude longitude:self.currentLocation.coordinate.longitude];
    NSLog(@"--------->>>>>>>\nlocationDate:%@\n直接获取的Date:%@\nbootTime:%ld",self.currentLocation.timestamp,[formatter stringFromDate:[NSDate date]],[self uptime]);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    [self.locationManager requestLocation];
    NSLog(@"----->%@",segue.identifier);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
