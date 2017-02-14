//
//  SixthViewController.m
//  MyDemo
//
//  Created by LiDaHai on 17/1/4.
//  Copyright © 2017年 douchuanjiang. All rights reserved.
//

#import "SixthViewController.h"
#import "SixthCollectionViewLayout.h"
#import "WaterfallColectionLayout.h"

@interface SixthViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,SixCollectionViewLayoutDelegate>

@property (nonatomic, strong) NSAttributedString *attributeStr;
@property (nonatomic, strong) UICollectionView   *collectionView;
@property (nonatomic, strong) NSMutableArray     *dataArray;
@property (nonatomic, strong) WaterfallColectionLayout *waterLayout;
@property (nonatomic, strong) SixthCollectionViewLayout *sixLayout;
@property (nonatomic, strong) NSArray* heightArr;
@end

@implementation SixthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *desc = @"爱上了；都看见快乐阿斯蒂芬；家里；速度快放假；阿里速度快解放；啊束带结发；阿萨德了会计法啊；收到了快放假啊；收到了快放假啊是；的离开房间按时；的离开房间按时；登录开发";
    NSMutableParagraphStyle *linebreak = [[NSMutableParagraphStyle alloc] init];
    linebreak.lineBreakMode = NSLineBreakByTruncatingTail;
    linebreak.paragraphSpacing = 5.f;
    linebreak.maximumLineHeight = 10.f;
    self.attributeStr = [[NSAttributedString alloc] initWithString:desc
                                                                                       attributes:@{NSParagraphStyleAttributeName : linebreak,
                                                                                                    NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                                                    NSFontAttributeName:[self sh_fontMediumWithSize:15]}];
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    self.collectionView = [[UICollectionView alloc] initWithFrame:(CGRect){{0,20},{screenRect.size.width,screenRect.size.height - 20}} collectionViewLayout:self.sixLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [self.collectionView registerClass:[SixthCollectionViewItem class] forCellWithReuseIdentifier:@"sixth"];
    [self.view addSubview:self.collectionView];
    
    [self.dataArray addObjectsFromArray:@[@"按时；的离开积分",@"群文件",@"擦破哦分啊的",@"鹏IM单据的",@"；卡的时刻V女爱",@"第三方骄傲的",@"阿尔我记",@"气温比到今年的",@"陪你大货车大酒店",@"诶如瑞诶诶",@"啊啊啊啊啊啊",@"不不不不不不不",@"擦擦擦擦擦擦",@"的顶顶顶顶顶大",@"嗯嗯嗯嗯嗯嗯",@"反反复复凤飞飞",@"嘎嘎嘎灌灌灌灌灌",@"和哈哈哈哈哈哈",@"就急急急急急急",@"快快快快快快快快",@"么么么么么么么么",@"你你你你你你你你你",@"噢噢噢噢噢噢噢",@"啪啪啪啪啪啪啪啪啪",@"去去去去去去去",@"人人人人人人人人",@"谁谁谁水水水水",@"天天天天天天",@"uuuuuuuuuuuuu",@"VVVVVVVVVv",@"吾问无为谓呜呜呜"]];
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(NSArray *)heightArr{
    if(!_heightArr){
        //随机生成高度
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i<2000; i++) {
            [arr addObject:@(arc4random()%50+80)];
        }
        _heightArr = [arr copy];
    }
    return _heightArr;
}

-(UICollectionViewLayout *)waterLayout{
    if(!_waterLayout){
        _waterLayout = [[WaterfallColectionLayout alloc]initWithItemsHeightBlock:^CGFloat(NSIndexPath *index) {
            return [self.heightArr[index.item] floatValue];
        }];
    }
    return _waterLayout;
}

- (SixthCollectionViewLayout *)sixLayout
{
    if (!_sixLayout) {
        _sixLayout = [[SixthCollectionViewLayout alloc] init];
        _sixLayout.delegate = self;
    }
    return _sixLayout;
}

- (UIFont *)sh_fontMediumWithSize:(NSInteger)size
{
    if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_9_0) {
        return [UIFont fontWithName:@"PingFangSC-Semibold" size:size];
    }else{
        return [UIFont fontWithName:@"STHeitiSC-Medium" size:size];
    }
}

#pragma mark- UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.heightArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SixthCollectionViewItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sixth" forIndexPath:indexPath];
    cell.title = self.dataArray[indexPath.row%self.dataArray.count];
    return cell;
}

#pragma mark- WaterFlowLayoutDelegate

- (CGFloat)waterFlowLayout:(SixthCollectionViewLayout *)waterFlowLayout heightForRowAtIndex:(NSInteger)index itemWidth:(CGFloat)width
{
    return [self.heightArr[index] floatValue];
}

@end



@interface SixthCollectionViewItem ()
{
    UILabel *_titleLabel;
}
@end

@implementation SixthCollectionViewItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [self randomColor];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, frame.size.width - 20, frame.size.height - 20)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        [self addSubview:_titleLabel];
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = title;
}

-(UIColor *) randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 ); //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

@end
