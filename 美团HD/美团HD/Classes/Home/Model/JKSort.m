//
//  JKSort.m
//  美团HD
//
//  Created by 谢聪捷 on 3/12/15.
//  Copyright (c) 2015 Jack-Xie. All rights reserved.
//

#import "JKSort.h"

@implementation JKSort

// KVC 接口方法的实现
+ (instancetype)sortWithDict:(NSDictionary *)dict {
    id obj = [[self alloc] init];
    [obj setValuesForKeysWithDictionary:dict];
    return obj;
}

@end
