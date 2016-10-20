//
//  TodayViewController.m
//  MyTodayExtension
//
//  Created by LiDaHai on 16/10/19.
//  Copyright © 2016年 douchuanjiang. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 300);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // iOS10 以后展开折叠
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 10.0) {
        self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
    }
}

- (IBAction)btnClicked:(id)sender{
    
    // 打开主客户端（注：Extension只能以Scheme方式打开主客户端）
    NSString *urlString = [NSString stringWithFormat:@"MyDemo://action=%ld",[sender tag]];
    [self.extensionContext openURL:[NSURL URLWithString:urlString]
                 completionHandler:^(BOOL success) {
                     NSLog(@"open url result:%d",success);
                 }];
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
{
    // 避免在iOS10之前会出现偏移的现象
    return UIEdgeInsetsZero;
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    NSLog(@"-----------Extension更新-----------");
    completionHandler(NCUpdateResultNewData);
}


#pragma mark- NCWidgetProviding(iOS10以后)

- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize
{
    if (activeDisplayMode == NCWidgetDisplayModeCompact) {
        // 折叠起来
        self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 100);
    } else if (activeDisplayMode == NCWidgetDisplayModeExpanded) {
        // 展开
        self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 800);
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
