//
//  CustomeView.m
//  TestProject
//
//  Created by LiDaHai on 16/5/31.
//  Copyright © 2016年 douchuanjiang. All rights reserved.
//

#import "CustomeView.h"

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
    
}

@end
