//
//  JKHomeTopItem.m
//  美团HD
//
//  Created by 谢聪捷 on 3/10/15.
//  Copyright (c) 2015 Jack-Xie. All rights reserved.
//

#import "JKHomeTopItem.h"

@implementation JKHomeTopItem

+ (instancetype)item {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"JKHomeTopItem" owner:nil options:nil] firstObject];
}

// 将 xib 的自动拉伸去掉！！！  
- (void)awakeFromNib {
    self.autoresizingMask = UIViewAutoresizingNone;
}

@end
