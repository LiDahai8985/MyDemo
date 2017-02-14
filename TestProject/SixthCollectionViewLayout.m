//
//  SixthCollectionViewLayout.m
//  MyDemo
//
//  Created by LiDaHai on 17/2/13.
//  Copyright © 2017年 douchuanjiang. All rights reserved.
//

#import "SixthCollectionViewLayout.h"


//一些默认值
/**列数*/
static const CGFloat columCount = 2;
/**  每一列间距*/
static const CGFloat columMargin = 10;
/**  每一列间距*/
static const CGFloat rowMargin = 10;
/**  边缘间距*/
static const UIEdgeInsets defaultEdgeInsets = {10,10,10,10};


@interface SixthCollectionViewLayout ()

/** 布局属性数组*/
@property (nonatomic,strong) NSMutableArray *attrsArray;

/** 存放所有列的当前高度*/
@property (nonatomic,strong) NSMutableArray *columnHeight;

@end

@implementation SixthCollectionViewLayout

- (NSMutableArray *)attrsArray
{
    if (!_attrsArray) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

- (NSMutableArray *)columnHeight
{
    if (!_columnHeight) {
        _columnHeight = [NSMutableArray array];
    }
    return _columnHeight;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    //如果刷新布局就会重新调用prepareLayout这个方法,所以要先把高度数组清空
    [self.columnHeight removeAllObjects];
    for (int i = 0; i < self.columCount; i++) {
        [self.columnHeight addObject:@(self.defaultEdgeInsets.top)];
    }
    
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    [self.attrsArray removeAllObjects];
    for (NSInteger i = 0; i < count; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        //获取indexPath 对应cell 的布局属性
        UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArray addObject:attr];
    }
}

- (CGSize)collectionViewContentSize
{
    CGFloat maxHeight = [self.columnHeight[0] doubleValue];
    for (int i = 1; i < self.columCount; i++) {
        CGFloat value = [self.columnHeight[i] doubleValue];
        if (maxHeight < value) {
            maxHeight = value;
        }
    }
    return CGSizeMake(0, maxHeight+self.defaultEdgeInsets.bottom);
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrsArray;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    //使用for循环,找出高度最短的那一列
    //最短高度的列
    NSInteger destColumn = 0;
    CGFloat minColumnHeight = [self.columnHeight[0] doubleValue];
    
    for (NSInteger i = 1; i < self.columCount; i++) {
        CGFloat columnHeight  =[self.columnHeight[i] doubleValue];
        if (minColumnHeight > columnHeight) {
            minColumnHeight = columnHeight;
            destColumn = i;
        }
    }
    
    CGFloat w = (self.collectionView.frame.size.width - self.defaultEdgeInsets.left - self.defaultEdgeInsets.right - (self.columCount - 1) * self.columMargin )/self.columCount;
    
    //(使用代理在外部决定cell 的高度,下面会介绍)
    CGFloat h = [self.delegate waterFlowLayout:self heightForRowAtIndex:indexPath.item itemWidth:w];
    CGFloat x = self.defaultEdgeInsets.left + destColumn*(w + self.columMargin);
    CGFloat y = minColumnHeight ;
    
    if (y != self.defaultEdgeInsets.top) {
        y += self.rowMargin;
    }
    
    attr.frame = CGRectMake(x,y,w,h);
    
    self.columnHeight[destColumn] =  @(y+ h);
    return attr;
}


// 外部设置的一些参数
- (NSInteger)columCount
{
    if ([self.delegate respondsToSelector:@selector(cloumnCountInWaterFlowLayout:)]) {
        return  [self.delegate cloumnCountInWaterFlowLayout:self];
    } else{
        return columCount;
    }
}

- (CGFloat)columMargin
{
    if ([self.delegate respondsToSelector:@selector(columMarginInWaterFlowLayout:)]) {
        return  [self.delegate columMarginInWaterFlowLayout:self];
    } else{
        return columMargin;
    }
}

- (CGFloat)rowMargin
{
    if ([self.delegate respondsToSelector:@selector(rowMarginInWaterFlowLayout:)]) {
        return  [self.delegate rowMarginInWaterFlowLayout:self];
    } else{
        return rowMargin;
    }
}

- (UIEdgeInsets)defaultEdgeInsets
{
    if ([self.delegate respondsToSelector:@selector(edgeInsetInWaterFlowLayout:)]) {
        return  [self.delegate edgeInsetInWaterFlowLayout:self];
    } else{
        return defaultEdgeInsets;
    }
}

//- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
//{
//    return NO;
//}
//
//- (BOOL)shouldInvalidateLayoutForPreferredLayoutAttributes:(UICollectionViewLayoutAttributes *)preferredAttributes withOriginalAttributes:(UICollectionViewLayoutAttributes *)originalAttributes
//{
//    return YES;
//}
//
//- (void)prepareForCollectionViewUpdates:(NSArray<UICollectionViewUpdateItem *> *)updateItems
//{
//    NSLog(@"----------=====-----------");
//}

@end
