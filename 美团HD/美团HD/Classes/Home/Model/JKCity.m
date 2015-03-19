//
//  JKCity.m
//  美团HD
//
//  Created by 谢聪捷 on 3/19/15.
//  Copyright (c) 2015 Jack-Xie. All rights reserved.
//

#import "JKCity.h"
#import "MJExtension.h"
#import "JKDistrict.h"


@implementation JKCity

+ (instancetype)cityWithDict:(NSDictionary *)dict {
    id obj = [[self alloc] init];
    [obj setValuesForKeysWithDictionary:dict];
    return obj;
}

+ (NSDictionary *)objectClassInArray {
    return @{@"districts" : [JKDistrict class]};
}

@end
