//
//  JKDealCell.m
//  美团HD
//
//  Created by 谢聪捷 on 3/19/15.
//  Copyright (c) 2015 Jack-Xie. All rights reserved.
//

#import "JKDealCell.h"

@implementation JKDealCell

//- (void)awakeFromNib {
//    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dealcell"]];
//}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [[UIImage imageNamed:@"bg_dealcell"] drawInRect:rect];
}

@end
