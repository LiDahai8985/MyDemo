//
//  MMCoreTextDispalyView.m
//  MyDemo
//
//  Created by LiDaHai on 17/2/21.
//  Copyright © 2017年 douchuanjiang. All rights reserved.
//

#import "MMCoreTextDispalyView.h"
#import <CoreText/CoreText.h>


@implementation MMCoreTextDispalyView



- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    // 1、获取当前上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 2、context坐标系上下翻转，对于底层绘制引擎来说，屏幕的左下角是（0,0）原点，而对于上层UIKit来说左上角为（0,0）原点，为了按习惯上的UIKit坐标来布局，这里需要将contex坐标系上下翻转（只有y方向是相反的，x方向是相同的不用翻转）
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1, -1);
    
    // 3、创建绘制区域,可以用下面被注释掉的代码替换前一句来测试绘制区域的变化（如无明显变化，可将文本内容多添加一些）
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
    //CGPathAddEllipseInRect(path, NULL, self.bounds);
    
    // 4、文本内容
    NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:@"Hello world!Hello world!Hello world!Hello world!Hello world!Hello world!Hello world!Hello world!Hello world!Hello world!"];
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attribute);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attribute.length), path, NULL);
    
    // 开始绘制渲染
    CTFrameDraw(frame, context);
    
    // 使用Create函数建立的对象引用，必须要使用CFRelease掉
    CFRelease(frame);
    CFRelease(path);
    CFRelease(framesetter); 
    
//    CGFontRef font = CTFontCreateWithName(<#CFStringRef  _Nullable name#>, <#CGFloat size#>, <#const CGAffineTransform * _Nullable matrix#>);
}



@end
