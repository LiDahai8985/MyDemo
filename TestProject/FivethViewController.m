//
//  FivethViewController.m
//  MyDemo
//
//  Created by LiDaHai on 16/10/18.
//  Copyright © 2016年 douchuanjiang. All rights reserved.
//

#import "FivethViewController.h"
#import "AutoHeightCell.h"


@interface FivethViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation FivethViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImage *image = [self addImage:[UIImage imageNamed:@"default-5"] toImage:[UIImage imageNamed:@"scratch_tip"]];
    
    [self.imageView setImage:image];
    
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50;
    
    NSArray *array = @[@"啊；收到了快放假；安科技；了阿萨德；发；卡拉胶按时；打开房间爱上地方难对付爱上对方考虑是否，阿迪发洛杉矶阿斯蒂芬。阿萨德发了啥地方看见爱上对方答复沙龙东方，阿斯蒂芬是打发是累的法拉盛发。",
                      @"阿道夫大师傅发洛杉矶阿斯蒂芬。阿萨德发了啥地方看",
                      @"发洛杉矶阿斯蒂芬。阿萨德发了啥地方看大厦法定是发的是阿斯蒂芬大师傅",
                      @"发洛杉矶阿斯蒂芬。阿萨德发了啥地方看大师傅发洛杉矶阿斯蒂芬。阿萨德发了啥地方看大法师的发洛杉矶阿斯蒂芬。阿萨德发了啥地方看",
                      @"大师傅发洛杉矶阿斯蒂芬。阿萨德发了啥地方看发洛杉矶阿斯蒂芬。阿萨德发了啥地方看",
                      @"发洛杉矶阿斯蒂芬。阿萨德发了啥地方看阿斯顿发斯蒂芬撒旦撒旦法安抚阿斯蒂芬阿斯蒂芬撒旦法发洛杉矶阿斯蒂芬。阿萨德发了啥地方看",
                      @"阿斯顿发斯蒂芬阿萨德阿斯蒂芬暗室逢灯撒旦法阿斯蒂芬阿斯蒂芬阿斯顿发发洛杉矶阿斯蒂芬。阿萨德发了啥地方看发洛杉矶阿斯蒂芬。阿萨德发了啥地方看a's'd'f's'd'f发洛杉矶阿斯蒂芬。阿萨德发了啥地方看阿萨德发送到发顺丰s'd'f发洛杉矶阿斯蒂芬。阿萨德发了啥地方看撒旦法",
                      @"发洛杉矶阿斯蒂芬。阿萨德发了啥地方看ad'f'd's'f发洛杉矶阿斯蒂芬。阿萨德发了啥地方看ad'f'd's'f'd's'f",
                      @"发洛杉矶阿斯蒂芬。阿萨德发了啥地方看发洛杉矶阿斯蒂芬。阿萨德发了啥地方看啊；卡收到了附件；了爱迪生；浪费啊，撒旦拉士大夫。",
                      @"发洛杉矶阿斯蒂芬。阿萨德发了啥地方看 发洛杉矶阿斯蒂芬。阿萨德发了啥地方看发洛杉矶阿斯蒂芬。阿萨德发了啥地方看发洛杉矶阿斯蒂芬。阿萨德发了啥地方看"];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6];
    NSDictionary *attributeDic = @{NSFontAttributeName:[UIFont systemFontOfSize:20],
                                   NSForegroundColorAttributeName:[UIColor blueColor],
                                   NSParagraphStyleAttributeName:paragraphStyle};
    for (int i = 0; i < array.count; i ++) {
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:array[i] attributes:attributeDic];
        [self.dataArray addObject:string];
    }
    
    [self.tableView reloadData];
}


#pragma mark- UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AutoHeightCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AutoHeightCell"];

    cell.bioLabel.attributedText = self.dataArray[indexPath.row];
    return cell;
}



#pragma mark-
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


#pragma mark-
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
@end
