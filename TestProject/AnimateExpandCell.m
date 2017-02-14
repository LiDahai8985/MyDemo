//
//  MyProductHistoryOrderCell.m
//  Shire
//
//  Created by LDhai on 16/7/7.
//  Copyright © 2016年 LLJZ. All rights reserved.
//

#import "AnimateExpandCell.h"

@interface AnimateExpandCell()

@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblMoney;
@property (weak, nonatomic) IBOutlet UILabel *lblProfit;
@property (weak, nonatomic) IBOutlet UILabel *lblCouponProfit;
@property (weak, nonatomic) IBOutlet UILabel *lblCouponTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgCouponIcon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusConstraintW;

@end

@implementation AnimateExpandCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
