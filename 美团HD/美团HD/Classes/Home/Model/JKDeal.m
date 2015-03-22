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

//- (void)setPublish_date:(NSDate *)publish_date {
//    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
//    fmt.dateFormat = @"yyyy-MM-dd";
//    // 将字符串类型转换成 NSDate 类型
//    _publish_date = [fmt dateFromString:(NSString *)publish_date];
//}
//
//- (void)setPurchase_deadline:(NSDate *)purchase_deadline {
//    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
//    fmt.dateFormat = @"yyyy-MM-dd";
//    // 将字符串类型转换成 NSDate 类型
//    _purchase_deadline = [fmt dateFromString:(NSString *)purchase_deadline];
//}


@end



















