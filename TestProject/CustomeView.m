//
//  CustomeView.m
//  TestProject
//
//  Created by LiDaHai on 16/5/31.
//  Copyright © 2016年 douchuanjiang. All rights reserved.
//

#import "CustomeView.h"

@interface CustomeView ()

@property (strong, nonatomic) CALayer *redLayer;
@property (strong, nonatomic) UILabel *testLabel;

@end

@implementation CustomeView



- (void)drawRect:(CGRect)rect {
    
    //*****画矩形*****
    //******以（100，200）为左上角原点，10为宽 50为高的矩形******
    //UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(100, 200, 10, 50)];
    //*********end********
    
    
    //***画椭圆或者圆
    //******在以（0，0）为左上角原点，200为长 100为高的矩形区域画内切椭圆（矩形为正方形的话即画圆了）******
    //UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 200, 100)];
    //*********end********
    
    
    //******画四个角均为指定弧度的圆角矩形*****
    //******在以（10，10）为左上角原点，画四个角均为指定弧度的圆角的长为200高为100的矩形******
    //UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(10, 10, 200, 100) cornerRadius:20];
    //*********end********
    
    
    //********画指定某一角为圆角的矩形*******
    //******在以（20，20）为左上角原点，画左上和右下角为指定弧度的圆角的长为200高为100的矩形******
    //UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(20, 20, 200, 100) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(50, 0)];
    //*********end********
    
    
    //********画弧形*******
    //****在以（140，300）为原心，141为半径，从零度开始顺时针方向偏移M_PI角度画弧（弧的起始零度为圆心的x轴正方向）****
//    UIBezierPath *path1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(140, 300) radius:141 startAngle:0 endAngle:M_PI*2 clockwise:YES];
//    [path1 stroke];
    //*********end********
    
    
    //********画二次曲线*******
    //****在以（50，200）为起始点，(200, 200)为结束点，(125, 125)为控制点画二次曲线****
    //UIBezierPath *path = [UIBezierPath bezierPath];
    //[path moveToPoint:CGPointMake(50, 200)];
    //[path addQuadCurveToPoint:CGPointMake(200, 200) controlPoint:CGPointMake(125, 125)];
    //*********end********
    
    
    //********画三次曲线(以1/4圆弧为例)*******
    //****在以（40，200）为起始点，(240, 200)为结束点，(98, 142)和（182，142）为控制点画三次曲线****
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path moveToPoint:CGPointMake(40, 200)];
//    [path addCurveToPoint:CGPointMake(240, 200) controlPoint1:CGPointMake(98, 142) controlPoint2:CGPointMake(182, 142)];
    //*********end********
    
    //*******以（200，100）为起始点的五边形绘制******
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path moveToPoint:CGPointMake(150, 100)];
//    
//    [path addLineToPoint:CGPointMake(250, 140)];
//    [path addLineToPoint:CGPointMake(210, 240)];
//    [path addLineToPoint:CGPointMake(90, 240)];
//    [path addLineToPoint:CGPointMake(50, 140)];
//    [path closePath];
    //********end***********
    
    //*********改变椭圆位置************
    //UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 200, 100)];
    
    //改变椭圆位置
    //CGContextRef ref = UIGraphicsGetCurrentContext();
    //CGContextTranslateCTM(ref, 10, 10);
    //******************end**************
    
    /*
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(20, 150)];
    [path addLineToPoint:CGPointMake(50, 233)];
    [path addCurveToPoint:CGPointMake(270, 210) controlPoint1:CGPointMake(120, 200) controlPoint2:CGPointMake(240, 200)];
    [path addLineToPoint:CGPointMake(200, 30)];
    
    [path addCurveToPoint:CGPointMake(20, 150) controlPoint1:CGPointMake(80, 130) controlPoint2:CGPointMake(140, 120)];

    
    //UIColor 的set方法，设置当前环境（current drawing context）下的path颜色
    //UIColor *pathColor = [UIColor redColor];
    //[pathColor set];
    [[UIColor blackColor] setStroke];
    [[UIColor redColor] setFill];
    
    //路径边界宽度，转折点样式
    path.lineWidth = 1;
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    
    //所画路径填充
    [path fill];
    
    //所画路径不填充
    [path stroke];
    
    */
    
    
    
    CGFloat  lengths[2] = {2,3.5};
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextBeginPath(ref);
    CGContextSetLineWidth(ref, 20); // 线宽（线宽是由线起点往两边延伸的，不是从起点开始往一边延伸的）
    CGContextSetStrokeColorWithColor(ref, [UIColor redColor].CGColor); // 线条颜色
    CGContextSetLineDash(ref, 0, lengths, 2); // 虚线规格
    CGContextMoveToPoint(ref, self.frame.size.width/2, self.frame.size.height); // 起始点
    CGContextAddLineToPoint(ref, self.frame.size.width/2, 0); // 线段终点
    CGContextStrokePath(ref);
    CGContextClosePath(ref);
    
//    CGContextSetLineWidth(ref, 6.0);
//    CGContextSetStrokeColorWithColor(ref, [UIColor redColor].CGColor);
//    CGContextSetLineDash(ref, 0, lengths, 2);
//    CGContextMoveToPoint(ref, 120, 300);
//    CGContextAddLineToPoint(ref, 120, 276);
//    CGContextStrokePath(ref);
//    CGContextClosePath(ref);
//    
//    CGContextSetLineWidth(ref, 6.0);
//    CGContextSetStrokeColorWithColor(ref, [UIColor redColor].CGColor);
//    CGContextSetLineDash(ref, 0, lengths, 2);
//    CGContextMoveToPoint(ref, 130, 300);
//    CGContextAddLineToPoint(ref, 130, 292.5);
//    CGContextStrokePath(ref);
//    CGContextClosePath(ref);
//    
//    CAReplicatorLayer *layer = [CAReplicatorLayer layer];
//    
//    layer.frame = CGRectMake(50, 250, 200, 200);
//    
//    layer.backgroundColor = [UIColor lightGrayColor].CGColor;
//    
//    [self.layer addSublayer:layer];
//    
//    CALayer *bar = [CALayer layer];
//    
//    bar.backgroundColor = [UIColor redColor].CGColor;
//    
//    bar.bounds = CGRectMake(0, 0, 30, 100);
//    
//    bar.position = CGPointMake(15, 200);
//    
//    bar.anchorPoint = CGPointMake(0.5, 1);
//    
//    [layer addSublayer:bar];
//    
//    CABasicAnimation *anim = [CABasicAnimation animation];
//    
//    anim.keyPath = @"transform.scale.y";
//    
//    anim.toValue = @(0.1);
//    
//    anim.autoreverses = YES;
//    
//    anim.repeatCount = MAXFLOAT;
//    
//    [bar addAnimation:anim forKey:nil];
//    
//    // 设置4个子层，3个复制层
//    layer.instanceCount = 4;
//
//    // 设置复制子层的相对位置，每个x轴相差40
//    layer.instanceTransform = CATransform3DMakeTranslation(40, 0, 0);
//    
//    // 设置复制子层的延迟动画时长
//    layer.instanceDelay = 0.3;
    
   // UIBezierPath *aPath = [UIBezierPath bezierPath];
   // [aPath moveToPoint:CGPointMake(120, 200)];
   // [aPath addArcWithCenter:CGPointMake(60, 200) radius:50 startAngle:0 endAngle:360*(M_PI/180.0) clockwise:YES];
    
    
    CAGradientLayer *colorLayer = [CAGradientLayer layer];
    colorLayer.colors = @[(id)[UIColor redColor].CGColor,(id)[UIColor whiteColor].CGColor,(id)[UIColor yellowColor].CGColor];
    colorLayer.frame = CGRectMake(50, 50, 200, 100);
    colorLayer.locations = @[@0.1,@0.6,@1.0]; // 颜色分布区域 取值均为0~1
    colorLayer.startPoint = CGPointMake(0, 0);
    colorLayer.endPoint = CGPointMake(1, 1); // startPoint和endPoint决定颜色渐变方向，取值类似锚点取值，两点连线的方向即是颜色渐变方向
    [self.layer addSublayer:colorLayer];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 50, 200, 100)];
    imageView.image = [UIImage imageNamed:@"mm10.png"];
    //[self addSubview:imageView];
    
    colorLayer.mask = self.testLabel.layer;
}

- (UILabel *)testLabel
{
    if (!_testLabel) {
        _testLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
        _testLabel.numberOfLines = 0;
        _testLabel.text = @"阿里看见啊；的咖啡机啊；独守空房就集成显卡V加上地方； 安抚加速度了。地方阿里疯狂， 爱上邓丽君。 法律的阿萨德";
        [self addSubview:_testLabel];
    }
    
    return _testLabel;
}

- (void)moveLabel:(UIPanGestureRecognizer *)pan
{
    
    CGPoint point = [pan locationInView:self];
    self.testLabel.center = point;
    
    
}

- (void)startAnimation {
    if (!self.redLayer) {
        self.redLayer = [CALayer layer];
        self.redLayer.bounds = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        self.redLayer.position = CGPointMake(self.frame.size.width/2, self.frame.size.height);
        self.redLayer.backgroundColor = [UIColor redColor].CGColor;
        [self.redLayer setNeedsDisplay];
        self.redLayer.anchorPoint = CGPointMake(0.5, 1);
        
        self.layer.mask = self.redLayer;
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveLabel:)];
        [self.testLabel addGestureRecognizer:pan];
    }
    
     //已经有动画则先移除
    [self.layer.mask removeAllAnimations];
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"bounds.size.height"];
    anim.toValue = @(1);
    anim.autoreverses = YES;
    anim.repeatCount = MAXFLOAT;
    [self.layer.mask addAnimation:anim forKey:nil];
    
}

@end



@implementation DashLine

- (void)drawInContext:(CGContextRef)ctx {
    
    CGFloat  lengths[2] = {2,0};
    CGContextBeginPath(ctx);
    
    CGContextSetLineWidth(ctx, self.frame.size.width);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextSetLineDash(ctx, 0, lengths, 2);
    CGContextMoveToPoint(ctx, self.frame.size.width/2, self.frame.size.height);
    CGContextAddLineToPoint(ctx, self.frame.size.width/2, 0);
    CGContextStrokePath(ctx);
    CGContextClosePath(ctx);
    
}

@end
