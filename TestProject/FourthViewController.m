//
//  FourthViewController.m
//  TestProject
//
//  Created by LiDaHai on 16/5/23.
//  Copyright © 2016年 douchuanjiang. All rights reserved.
//

#import "FourthViewController.h"
#import "MMPlayerView.h"


@interface FourthViewController ()
{
    BOOL isFullScreen;
}

@property (strong, nonatomic) MMPlayerView *playerView;
@property (strong, nonatomic) NSLayoutConstraint *playerViewHeightConstraint;

@end

@implementation FourthViewController


- (void)dealloc {
    [self.playerView clear];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    [self.imageView addGestureRecognizer:panGesture];
    
    self.playerView = [MMPlayerView sharePlayer];
    self.playerView.contentMode = MMPlayerContentMode_video;
    [self.view addSubview:self.playerView];
    
    self.playerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    self.playerViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.playerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.view.frame.size.width*9/16];
    
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.playerView
                                                                attribute:NSLayoutAttributeLeft
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.view
                                                                attribute:NSLayoutAttributeLeft
                                                               multiplier:1
                                                                 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.playerView
                                                                attribute:NSLayoutAttributeRight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.view
                                                                attribute:NSLayoutAttributeRight
                                                               multiplier:1
                                                                 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.playerView
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.view
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1
                                                                 constant:0]];
    [self.view addConstraint:self.playerViewHeightConstraint];
    
    
    self.playerView.heightConstraint = self.playerViewHeightConstraint;
    
    [self.playerView setMediaURL:[NSURL URLWithString:@"http://baobab.wdjcdn.com/14562919706254.mp4"]];
    
//    NSString *url = @"https://www.baidu.com?q=北京";
//    //url中带中文字符的转意方法下列方法中urL返回为空，urL1为编码后地址
//    NSURL *urL = [NSURL URLWithString:url];
//    NSURL *urL1 = [NSURL URLWithString:[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
//    NSLog(@"---->urL:%@  ---->urL1:%@",urL,urL1);
    
    [self.view systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
//    //1通过边界编剧约束，确定空间尺寸
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [button setTitle:@"测试按钮" forState:UIControlStateNormal];
//    [button sizeToFit];
//    [button setBackgroundColor:[UIColor yellowColor]];
//    button.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.view addSubview:button];
//    
//    
//    //上边距
//    [self.view addConstraint:[NSLayoutConstraint
//                              constraintWithItem:button
//                              attribute:NSLayoutAttributeTop
//                              relatedBy:NSLayoutRelationEqual
//                              toItem:self.view
//                              attribute:NSLayoutAttributeTop
//                              multiplier:1.0f
//                              constant:50.0f]];
//    
//    //左边距
//    [self.view addConstraint:[NSLayoutConstraint
//                              constraintWithItem:button
//                              attribute:NSLayoutAttributeLeading
//                              relatedBy:NSLayoutRelationEqual
//                              toItem:self.view
//                              attribute:NSLayoutAttributeLeading
//                              multiplier:1.0f
//                              constant:100.0f]];
//    
//    //右边距
//    [self.view addConstraint:[NSLayoutConstraint
//                              constraintWithItem:button
//                              attribute:NSLayoutAttributeTrailing
//                              relatedBy:NSLayoutRelationEqual
//                              toItem:self.view
//                              attribute:NSLayoutAttributeTrailing
//                              multiplier:1.0f
//                              constant:-100.0f]];
//    
//    //下边距
//    [self.view addConstraint:[NSLayoutConstraint
//                              constraintWithItem:button
//                              attribute:NSLayoutAttributeBottom
//                              relatedBy:NSLayoutRelationEqual
//                              toItem:self.view
//                              attribute:NSLayoutAttributeBottom
//                              multiplier:1.0f
//                              constant:-350.0f]];
    
    
    
}

- (IBAction)changeHeight:(id)sender {
    
//    self.playerViewHeightConstraint.constant = isFullScreen?[[UIApplication sharedApplication] keyWindow].bounds.size.width:100;
//    isFullScreen = !isFullScreen;
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-

- (void)panGestureRecognizer:(UIPanGestureRecognizer *)pan {
    if (pan.state == UIGestureRecognizerStateBegan) {
        canEarse = YES;
    }
    else if (pan.state == UIGestureRecognizerStateChanged) {
        if(canEarse)
        {
            
            CGPoint currentPoint = [pan locationInView:_imageView];
            UIGraphicsBeginImageContext(self.imageView.frame.size);
            [_imageView.image drawInRect:_imageView.bounds];
            
            //关键是这个地方。如何才能做成不规则的图形 －－－－－－－－－－－－－－－－－－－－－－－－－
            CGContextRef context = UIGraphicsGetCurrentContext();
            
            CGRect cirleRect = CGRectMake(currentPoint.x-40, currentPoint.y-40,80, 80);
            
            //下面是一句画出圆形的
            CGContextAddArc(context,currentPoint.x, currentPoint.y,40, 0, 2*M_PI, 0);
            
            
            //下面我绘制了一个三角形
//            CGContextMoveToPoint(context, currentPoint.x, currentPoint.y);
//            CGContextAddLineToPoint(context, currentPoint.x+20, currentPoint.y+20);
//            CGContextAddLineToPoint(context,currentPoint.x-20, currentPoint.y+20);
//            CGContextAddLineToPoint(context,currentPoint.x-20, currentPoint.y+20);
//            CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
            
            //向例子图片那样的不规则手指形状该怎么弄。都用CGContextAddLineToPoint绘制出来？？？
            
            CGContextClosePath(context);
            CGContextClip(context);
            //关键是这个地方。如何才能做成不规则的图形 －－－－－－－－－－－－－－－－－－－－－－－－－
            
            CGContextClearRect(context,cirleRect);
            _imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
    }
    else {
        canEarse = NO;
    }
}

#pragma mark-

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

#pragma mark -
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

@interface xiaohui : NSObject
{
    
}
+(int)staticFun;
@end

static int b;
@implementation xiaohui
+(int)staticFun
{
    return b;
}


@end
