//
//  EighthViewController.m
//  MyDemo
//
//  Created by LiDaHai on 17/2/13.
//  Copyright © 2017年 douchuanjiang. All rights reserved.
//

#import "EighthViewController.h"

@interface EighthViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;

@end

@implementation EighthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 1;
    flowLayout.minimumInteritemSpacing = 1;
    flowLayout.itemSize = CGSizeMake(130, 100);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:(CGRect){{0,20},{screenSize.width,screenSize.height - 20}} collectionViewLayout:flowLayout];
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor colorWithRed:0.8568 green:0.8568 blue:0.8568 alpha:1.0];
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[EighthCollectionViewCell class]
            forCellWithReuseIdentifier:NSStringFromClass([EighthCollectionViewCell class])];
    [self.view addSubview:self.collectionView];
    
    self.dataArray = [NSMutableArray arrayWithObjects:@"红包", @"转账", @"手机充值", @"芝麻信用",
                      @"天猫", @"生活缴费", @"蚂蚁呗", @"世界那么大",
                      @"余额宝", @"安全快付", @"蚂蚁聚宝", @"哈哈",@"红包1", @"转账1", @"手机充值1", @"芝麻信用1",
                      @"天猫1", @"生活缴费1", @"蚂蚁呗1", @"世界那么大1",
                      @"余额宝1", @"安全快付1", @"蚂蚁聚宝1", @"哈哈1",  nil];
    
    _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(lonePressMoving:)];
    [self.collectionView addGestureRecognizer:_longPress];
}

- (void)lonePressMoving:(UILongPressGestureRecognizer *)longPress
{
    
    switch (_longPress.state) {
        case UIGestureRecognizerStateBegan: {
            {
                NSIndexPath *selectIndexPath = [self.collectionView indexPathForItemAtPoint:[_longPress locationInView:self.collectionView]];
                [self.collectionView beginInteractiveMovementForItemAtIndexPath:selectIndexPath];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [self.collectionView updateInteractiveMovementTargetPosition:[longPress locationInView:_longPress.view]];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            [self.collectionView endInteractiveMovement];
            break;
        }
        default: [self.collectionView cancelInteractiveMovement];
            break;
    }
}

#pragma mark-

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EighthCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([EighthCollectionViewCell class]) forIndexPath:indexPath];
    cell.titleLabel.text = self.dataArray[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(nonnull NSIndexPath *)sourceIndexPath toIndexPath:(nonnull NSIndexPath *)destinationIndexPath
{
    //改变数据源顺序，与拖动后的排序保持一致
    id tmpObj = [self.dataArray objectAtIndex:sourceIndexPath.item];
    [self.dataArray removeObjectAtIndex:sourceIndexPath.item];
    [self.dataArray insertObject:tmpObj atIndex:destinationIndexPath.item];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"----------%@-----------",self.dataArray[indexPath.item]);
}
@end




@implementation EighthCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:(CGRect){{10,20},{frame.size.width - 20,frame.size.height - 40}}];
        self.titleLabel.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.numberOfLines = 0;
        [self addSubview:self.titleLabel];
    }
    
    return self;
}

@end
