//
//  TenthViewController.m
//  MyDemo
//
//  Created by LiDaHai on 17/2/21.
//  Copyright © 2017年 douchuanjiang. All rights reserved.
//

#import "TenthViewController.h"
#import "MMCoreTextDispalyView.h"
#import "MMLabel.h"
#import "EighthViewController.h"
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>

@interface TenthViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

@property (nonatomic, strong) MMLabel *testLabel;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *pageContent;
@end

@implementation TenthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [UIPasteboard generalPasteboard];
//
//    MMCoreTextDispalyView *coretextView = [[MMCoreTextDispalyView alloc] initWithFrame:CGRectMake(50, 60, 200, 100)];
//    coretextView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:coretextView];
//    
//    self.testLabel = [[MMLabel alloc] init];
//    self.testLabel.frame = CGRectMake(10, 180, 300, 400);
//    self.testLabel.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
//    self.testLabel.text = @"阿里肯德基阿迪是打飞机流口水就发四六级辣豆腐啊是对方立即辣豆腐拉肯德基发大水了空间啊但是楼开发了就是块豆腐机啊来得及发了上课打飞机离开撒旦法就拉酸辣粉拉看似简单啊了圣诞节饭埃里克到静安寺；了打扣几分类似；打扣几分；就发； ；啊啥快递费；看时间；撒娇分；啊；是； ";
//    self.testLabel.numberOfLines = 0;
//    [self.view addSubview:self.testLabel];
    
//    //    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:<#(nullable NSDictionary<NSString *,id> *)#>];
//    self.pageViewController = [[UIPageViewController alloc] init];
//    self.pageViewController.delegate = self;
//    self.pageViewController.dataSource = self;
////    [self.pageViewController setViewControllers:<#(nullable NSArray<UIViewController *> *)#> direction:<#(UIPageViewControllerNavigationDirection)#> animated:<#(BOOL)#> completion:<#^(BOOL finished)completion#>]
//    [self addChildViewController:self.pageViewController];

    
    [self creatContentPages];
    
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:UIPageViewControllerSpineLocationMin] forKey:UIPageViewControllerOptionSpineLocationKey];
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    
    CGRect rect = [UIScreen mainScreen].bounds;
    self.pageViewController.view.backgroundColor = [UIColor redColor];
    [self.pageViewController.view setFrame:rect];
    
    EighthViewController *first = [self viewControllerAtIndex:0];
//    PageContentViewController *second = [self viewControllerAtIndex:1];
    
    NSArray *viewControllers = [NSArray arrayWithObjects:first,nil];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
}

- (EighthViewController *)viewControllerAtIndex:(NSInteger)index
{
    if (self.pageContent.count== 0 || index >= self.pageContent.count) {
        return nil;
    }
    
    EighthViewController *content = [[EighthViewController alloc] init];
    content.view.backgroundColor = [UIColor blueColor];
    content.dataObject = [self.pageContent objectAtIndex:index];
    content.contentLabel.text = [NSString stringWithFormat:@"*****第%ld页*****",index];
    return content;
}

- (NSInteger)indexOfViewController:(EighthViewController *)controller
{
    return [self.pageContent indexOfObject:controller.dataObject];
}


- (void)creatContentPages
{
    NSMutableArray *pagesStrings = [[NSMutableArray alloc]init];
    for (int i = 0; i < 10; i++) {
        
        NSString *contentString = [NSString stringWithFormat:@"00%d.jpg",i];
        [pagesStrings addObject:contentString];
    }
    self.pageContent = [pagesStrings copy];
}


#pragma mark- UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers
{
    
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
//    if (completed) {
//        
//        PageContentViewController *previousViewController =  (PageContentViewController*)previousViewControllers.lastObject;
//        previousViewController.view.hidden = true;
//    }
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = [self indexOfViewController:(EighthViewController *)viewController];
    if (index == 0 || index == NSNotFound) {
        return nil;
    }
    index--;
    return  [self viewControllerAtIndex:index];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = [self indexOfViewController:(EighthViewController *)viewController];
    if (index == NSNotFound) {
        return  nil;
    }
    index++;
    if (index == self.pageContent.count) {
        return  nil;
    }
    return [self viewControllerAtIndex:index];
}

- (void)livePhoto
{
    NSURL * photoURL = [NSURL URLWithString:@""];
    NSURL * videoURL = [NSURL URLWithString:@""];
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^ {
        PHAssetCreationRequest * request = [PHAssetCreationRequest creationRequestForAsset];
        
        
        //这些类型应该从您的文件推断
        
        // PHAssetResourceCreationOptions * photoOptions = [[PHAssetResourceCreationOptions alloc] init];
        //photoOptions.uniformTypeIdentifier = @“public.jpeg”;
        
        // PHAssetResourceCreationOptions * videoOptions = [[PHAssetResourceCreationOptions alloc] init];
        //videoOptions.uniformTypeIdentifier = @“com.apple.quicktime-movie”;
        
        [request addResourceWithType:PHAssetResourceTypePhoto fileURL:photoURL options:nil];
        [request addResourceWithType:PHAssetResourceTypePairedVideo fileURL:videoURL options:nil];
        
    } completionHandler:^(BOOL success,NSError * _Nullable error){
        NSLog(@"成功？%d，错误：%@",success,error);
    }];
}

// 保存livePhoto图片
- (void)saveLivePhoto
{
    //PHLivePhotoView
    NSURL * photoURL = [NSURL URLWithString:@""];
    NSURL * videoURL = [NSURL URLWithString:@""];
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetCreationRequest *request = [PHAssetCreationRequest creationRequestForAsset];
        
        
        //These types should be inferred from your files
        
        PHAssetResourceCreationOptions *photoOptions = [[PHAssetResourceCreationOptions alloc] init];
        photoOptions.uniformTypeIdentifier = @"public.jpeg";
        
        PHAssetResourceCreationOptions *videoOptions = [[PHAssetResourceCreationOptions alloc] init];
        videoOptions.uniformTypeIdentifier = @"com.apple.quicktime-movie";
        
        [request addResourceWithType:PHAssetResourceTypePhoto fileURL:photoURL options:photoOptions];
        [request addResourceWithType:PHAssetResourceTypePairedVideo fileURL:videoURL options:videoOptions];
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        NSLog(@"success? %d, error: %@",success,error);
    }];
}
@end
