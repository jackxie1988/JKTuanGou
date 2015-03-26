//
//  JKGetSingleDealResult.m
//  美团HD
//
//  Created by 谢聪捷 on 3/26/15.
//  Copyright (c) 2015 Jack-Xie. All rights reserved.
//

#import "JKGetSingleDealResult.h"
#import "MJExtension.h"
#import "JKDeal.h"

@implementation JKGetSingleDealResult

+ (NSDictionary *)objectClassInArray {
    return @{@"deals" : [JKDeal class]};
}

@end
