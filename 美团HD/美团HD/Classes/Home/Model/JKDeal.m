//
//  JKDeal.m
//  美团HD
//
//  Created by 谢聪捷 on 3/19/15.
//  Copyright (c) 2015 Jack-Xie. All rights reserved.
//

#import "JKDeal.h"
#import "MJExtension.h"
#import "NSString+JKExtension.h"

@implementation JKDeal

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"desc" : @"description"};
}

- (void)setList_price:(NSString *)list_price {
    _list_price = list_price.dealedPriceString;
}

- (void)setCurrent_price:(NSString *)current_price {
    _current_price = current_price.dealedPriceString;
}

@end
