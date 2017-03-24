//
//  SeventhViewController.m
//  MyDemo
//
//  Created by LiDaHai on 17/2/9.
//  Copyright © 2017年 douchuanjiang. All rights reserved.
//

#import "SeventhViewController.h"
#import "InfoCell.h"
#import "AnimateExpandCell.h"


typedef NS_ENUM(NSInteger, ExpandCellAnimation) {
    ExpandCellAnimation_onlyOneExpand = 0, //全部逻辑在vc中，只允许tableView中有一个cell展开
    ExpandCellAnimation_multableExpand,    //全部逻辑在vc中，cell展开数量不受限制，点击即展开再点击收缩
    ExpandCellAnimation_cellControlExpand, //cell展开动画在cell中执行
};

@interface SeventhViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *datasArray;
@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, assign) ExpandCellAnimation expandAnimation; // 是否只展开一个
@property (nonatomic, strong) NSMutableArray *selectedIndexArray;
@property (nonatomic, strong) NSIndexPath    *currentSelectedIndexPath;
@end

@implementation SeventhViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.expandAnimation = ExpandCellAnimation_onlyOneExpand;
    
    for (int i=0; i < 35; i ++) {
        [self.datasArray addObject:[Model ModelWithNormalHeight:50.f expendHeight:100.f expend:i==0]];
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:(CGRect){0,20,self.view.bounds.size} style:UITableViewStylePlain];
    self.tableView.delegate       = self;
    self.tableView.dataSource     = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[InfoCell class] forCellReuseIdentifier:@"InfoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AnimateExpandCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([AnimateExpandCell class])];
    [self.view addSubview:self.tableView];
}

- (NSMutableArray *)datasArray
{
    if (!_datasArray) {
        _datasArray = [NSMutableArray array];
    }
    return _datasArray;
}

- (NSMutableArray *)selectedIndexArray
{
    if (!_selectedIndexArray) {
        _selectedIndexArray = [NSMutableArray array];
    }
    return _selectedIndexArray;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _datasArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 展开逻辑在viewController中，方面处理cell点击时效果有相互影响的情况，即在处理被点击cell的同时，还要对其他cell进行处理
    AnimateExpandCell *expandCell = [tableView dequeueReusableCellWithIdentifier:@"AnimateExpandCell"];
    
    
    // 展开逻辑在cell中
    InfoCell *infoCell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
    infoCell.indexPath = indexPath;
    infoCell.tableView = tableView;
    [infoCell loadData:_datasArray[indexPath.row]];
    
    if (self.expandAnimation == ExpandCellAnimation_onlyOneExpand) {
        return expandCell;
    } else if (self.expandAnimation == ExpandCellAnimation_multableExpand) {
        return expandCell;
    } else{
        return infoCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.expandAnimation == ExpandCellAnimation_onlyOneExpand) {
        if (indexPath == self.currentSelectedIndexPath) {
            return 155;
        } else {
            return 46;
        }
    } else if (self.expandAnimation == ExpandCellAnimation_multableExpand) {
        if ([self.selectedIndexArray containsObject:indexPath]) {
            return 155;
        }
        return 46;
    } else{
        Model *model = _datasArray[indexPath.row];
        return model.expend?model.expendHeight:model.normalHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.expandAnimation == ExpandCellAnimation_onlyOneExpand) {
        //**********只展开一行的逻辑************
        
        // 刷新tableview时beginUpdates和endUpdates两方法很重要
        
        if (self.currentSelectedIndexPath == indexPath) {
            // 只收缩
            self.currentSelectedIndexPath = nil;
            
            UITableViewCell *curCell = [tableView cellForRowAtIndexPath:indexPath];
            CGRect rect = curCell.contentView.frame;
            rect.size.height = 46;
//            [UIView animateWithDuration:5.3 animations:^{
                curCell.contentView.frame = rect;
//            }];
        } else {
            
            // 一个收缩一个展开
            NSIndexPath *lastSelectIndexPath = self.currentSelectedIndexPath;
            self.currentSelectedIndexPath = indexPath;
            
            UITableViewCell *curCell = [tableView cellForRowAtIndexPath:self.currentSelectedIndexPath];
            UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:lastSelectIndexPath];
            
            // 原来展开的，现在收缩
            if (lastCell) {
                CGRect lasRrect = lastCell.contentView.frame;
                lasRrect.size.height = 46;
                
//                [UIView animateWithDuration:5.3 animations:^{
                    lastCell.contentView.frame = lasRrect;
//                }];
            }
            
            // 收缩着的，现在展开
            CGRect curRect = curCell.contentView.frame;
            curRect.size.height = 155;
//            [UIView animateWithDuration:5.3 animations:^{
                curCell.contentView.frame = curRect;
//            }];
        }
        
        //此动画时间决定tableview的updates时间，上面每个分动画的具体时间无效
        [UIView animateWithDuration:0.3 animations:^{
            [tableView beginUpdates];
            [tableView endUpdates];
        }];
        
        //防止最后一行展开时，内容在屏幕下方被遮盖
        [tableView scrollToRowAtIndexPath:self.currentSelectedIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
        
    } else if (self.expandAnimation == ExpandCellAnimation_multableExpand) {
        
        BOOL expand = NO;
        if ([self.selectedIndexArray containsObject:indexPath]) {
            [self.selectedIndexArray removeObject:indexPath];
            expand = YES;
        } else {
            [self.selectedIndexArray addObject:indexPath];
        }
        
        [tableView beginUpdates];
        UITableViewCell *curCell = [tableView cellForRowAtIndexPath:indexPath];
        CGRect rect = curCell.contentView.frame;
        rect.size.height = expand?155:46;
        [UIView animateWithDuration:0.3 animations:^{
            curCell.contentView.frame = rect;
        }];
        
        [tableView endUpdates];
        
        //防止最后一行展开时，内容在屏幕下方被遮盖
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
        
    } else{
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
