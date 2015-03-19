//
//  JKFindDealsResult.m
//  美团HD
//
//  Created by 谢聪捷 on 3/19/15.
//  Copyright (c) 2015 Jack-Xie. All rights reserved.
//

#import "JKFindDealsResult.h"
#import "MJExtension.h"
#import "JKDeal.h"

@implementation JKFindDealsResult

+ (NSDictionary *)objectClassInArray {
    return @{@"deals" : [JKDeal class]};
}

@end
