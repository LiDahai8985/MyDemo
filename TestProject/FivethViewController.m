//
//  FivethViewController.m
//  MyDemo
//
//  Created by LiDaHai on 16/10/18.
//  Copyright © 2016年 douchuanjiang. All rights reserved.
//

#import "FivethViewController.h"

@interface FivethViewController ()

@property (nonatomic, strong) IBOutlet UIImageView *imageView;

@end

@implementation FivethViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImage *image = [self addImage:[UIImage imageNamed:@"default-5"] toImage:[UIImage imageNamed:@"scratch_tip"]];
    
    [self.imageView setImage:image];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 {
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    UIGraphicsBeginImageContext(screenSize);
    
    // Draw image1
    [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
    
    CGFloat imageWidth = image2.size.width;
    CGFloat imageHeight = image2.size.height;
    // Draw image2
    [image2 drawInRect:CGRectMake(screenSize.width/2 - imageWidth/2.0, screenSize.height - imageHeight - 100, imageWidth, imageHeight)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

@end
