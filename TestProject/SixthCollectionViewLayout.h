//
//  SixthCollectionViewLayout.h
//  MyDemo
//
//  Created by LiDaHai on 17/2/13.
//  Copyright © 2017年 douchuanjiang. All rights reserved.
//
// ******
// ******   这里attrsArray为全局对象
// ******   只在prepareLayout中计算一次cell布局并保存在attrsArray中，后续滑动加载时全部复用已计算过的cell布局
// ******

#import <UIKit/UIKit.h>

@class SixthCollectionViewLayout;

@protocol SixCollectionViewLayoutDelegate <NSObject>

@required
//决定cell的高度,必须实现方法
- (CGFloat)waterFlowLayout:(SixthCollectionViewLayout *)waterFlowLayout heightForRowAtIndex:(NSInteger)index itemWidth:(CGFloat)width;

@optional
//决定cell的列数
- (NSInteger)cloumnCountInWaterFlowLayout:(SixthCollectionViewLayout *)waterFlowLayout;

//决定cell 的列的距离
- (CGFloat)columMarginInWaterFlowLayout:(SixthCollectionViewLayout *)waterFlowLayout;

//决定cell 的行的距离
- (CGFloat)rowMarginInWaterFlowLayout:(SixthCollectionViewLayout *)waterFlowLayout;

//决定cell 的边缘距
- (UIEdgeInsets)edgeInsetInWaterFlowLayout:(SixthCollectionViewLayout *)waterFlowLayout;

@end


@interface SixthCollectionViewLayout : UICollectionViewLayout

/**代理*/
@property (nonatomic,assign) id <SixCollectionViewLayoutDelegate>delegate;

@end
