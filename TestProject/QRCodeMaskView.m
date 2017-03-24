//
//  QRCodeMaskView.m
//  My3DTouchDemo
//
//  Created by LiDaHai on 16/11/7.
//  Copyright © 2016年 Andy. All rights reserved.
//

#import "QRCodeMaskView.h"

@implementation QRCodeMaskView

- (void)drawRect:(CGRect)rect
{
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGFloat pickingFieldWidth = 300;
    CGFloat pickingFieldHeight = 300;
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSaveGState(contextRef);
    CGContextSetRGBFillColor(contextRef, 0, 0, 0, 0.4);
    CGContextSetLineWidth(contextRef, 10);
    
    CGRect pickingFieldRect = CGRectMake((width - pickingFieldWidth)/2, (height - pickingFieldHeight)/2, pickingFieldWidth, pickingFieldHeight);
    
    // 空白方框区域
    UIBezierPath *pickingFieldPath = [UIBezierPath bezierPathWithRect:pickingFieldRect];
    
    // 全部区域
    UIBezierPath *bezierPathRect = [UIBezierPath bezierPathWithRect:rect];
    
    // 关联两个区域
    [bezierPathRect appendPath:pickingFieldPath];
    
    // 黑色半透明填充，使用奇偶法则
    bezierPathRect.usesEvenOddFillRule = YES;
    [bezierPathRect fill];
    
    // 中间空白方框边框颜色
    CGContextSetLineWidth(contextRef, 12);
    CGContextSetRGBStrokeColor(contextRef, 27/255.0, 181/255.0, 254/255.0, 1);
    [pickingFieldPath stroke];
    
    CGContextRestoreGState(contextRef);
    
    self.layer.contentsGravity = kCAGravityCenter;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    
    
}
@end
