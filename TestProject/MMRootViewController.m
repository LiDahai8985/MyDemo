//
//  MMRootViewController.m
//  MyDemo
//
//  Created by LiDaHai on 17/1/3.
//  Copyright © 2017年 douchuanjiang. All rights reserved.
//

#import "MMRootViewController.h"
#import "ZeroViewController.h"
#import "FirstViewController.h"
#import "SecondeViewController.h"
#import "ThirdViewController.h"
#import "FourthViewController.h"
#import "FivethViewController.h"
#import "SixthViewController.h"
#import "SeventhViewController.h"
#import "EighthViewController.h"
#import "NinethViewController.h"
#import "TenthViewController.h"
#import "EleventhViewController.h"


@interface MMRootViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, strong) dispatch_source_t timer; // GCD定时器

@end

@implementation MMRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.dataSourceArray addObjectsFromArray:@[@"(0)layer相关+statusBar",@"(1)高斯模糊+歌词+截图+系统原生视频编辑",@"(2)内购+模态弹出",@"(3)播放器上一首下一首",@"(4)涂抹+播放器横竖屏切换",@"(5)cell自适应高度",@"(6)collectionview自定义layout",@"(7)cell点击后动画展开",@"(8)ios9以后collectionView拖动排序",@"(9)系统原生二维码识别",@"(10)CoreText学习",@"(11)LivePhoto"]];
    self.tableView.tableFooterView = [UIView new];

    /*
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(self.timer, ^{
        NSLog(@"-----------------------------");
    });
    dispatch_resume(self.timer);
     */
}

- (NSMutableArray *)dataSourceArray
{
    if (!_dataSourceArray) {
        _dataSourceArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataSourceArray;
}

#pragma mark- UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"----%@----",self.dataSourceArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        ZeroViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([ZeroViewController class])];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 1) {
        FirstViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([FirstViewController class])];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 2) {
        SecondeViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([SecondeViewController class])];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 3) {
        ThirdViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([ThirdViewController class])];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 4) {
        FourthViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([FourthViewController class])];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 5) {
        FivethViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([FivethViewController class])];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 6) {
        SixthViewController *vc = [[SixthViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 7) {
        SeventhViewController *vc = [[SeventhViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 8) {
        EighthViewController *vc = [[EighthViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 9) {
        NinethViewController *vc = [[NinethViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 10) {
        TenthViewController *vc = [[TenthViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 11) {
        EleventhViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([EleventhViewController class])];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

@end
