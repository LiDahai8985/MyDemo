//
//  InfoCell.h
//  MyDemo
//
//  Created by LiDaHai on 17/2/9.
//  Copyright © 2017年 douchuanjiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoCell : UITableViewCell

@property (nonatomic, weak) NSIndexPath  *indexPath;
@property (nonatomic, weak) UITableView  *tableView;

- (void)loadData:(id)data;

@end



@interface Model : NSObject

@property (nonatomic) CGFloat  normalHeight;
@property (nonatomic) CGFloat  expendHeight;
@property (nonatomic) BOOL     expend;

+ (instancetype)ModelWithNormalHeight:(CGFloat)normalHeight expendHeight:(CGFloat)expendHeight expend:(BOOL)expend;

@end


