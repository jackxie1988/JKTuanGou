//
//  JKCategory.m
//  美团HD
//
//  Created by 谢聪捷 on 3/13/15.
//  Copyright (c) 2015 Jack-Xie. All rights reserved.
//

#import "JKCategory.h"

@implementation JKCategory

+ (instancetype)categoryWithDict:(NSDictionary *)dict {
    id obj = [[self alloc] init];
    [obj setValuesForKeysWithDictionary:dict];
    return obj;
}

@end
