//
//  JKDealCell.m
//  美团HD
//
//  Created by 谢聪捷 on 3/19/15.
//  Copyright (c) 2015 Jack-Xie. All rights reserved.
//

#import "JKDealCell.h"
#import "UIImageView+WebCache.h"
#import "JKDeal.h"
#import "JKCenterLineLabel.h"

@interface JKDealCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *listPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *purchaseCountLabel;

// 新单属性
@property (weak, nonatomic) IBOutlet UIImageView *dealNewMark;



@end

@implementation JKDealCell

- (void)setDeal:(JKDeal *)deal {
    _deal = deal;
    
    // 图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:deal.s_image_url] placeholderImage:[UIImage imageNamed:@"placeholder_deal"]];
    // 标题
    self.titleLabel.text = deal.title;
    // 描述
    self.descLabel.text = deal.desc;
    // 原价
    self.listPriceLabel.text = [NSString stringWithFormat:@"￥%@",deal.list_price];
    // 现价
    self.currentPriceLabel.text = [NSString stringWithFormat:@"￥%@",deal.current_price];
    // 购买数
    self.purchaseCountLabel.text = [NSString stringWithFormat:@"已售%d",deal.purchase_count];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    // 将 NSDate 日期转化成字符串
    NSString *now = [fmt stringFromDate:[NSDate date]];
    NSComparisonResult result = [now compare:deal.publish_date];
    self.dealNewMark.hidden = (result == NSOrderedDescending) ? YES : NO;
    
//    JKLog(@"%@",deal.publish_date);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [[UIImage imageNamed:@"bg_dealcell"] drawInRect:rect];
}

@end
