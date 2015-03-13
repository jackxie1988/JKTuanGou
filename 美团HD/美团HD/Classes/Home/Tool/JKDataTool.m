//
//  JKDataTool.m
//  美团HD
//
//  Created by 谢聪捷 on 3/13/15.
//  Copyright (c) 2015 Jack-Xie. All rights reserved.
//

#import "JKDataTool.h"
#import "JKSort.h"

@implementation JKDataTool

static NSArray *_sorts;
+ (NSArray *)sorts {
    if (_sorts == nil) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"sorts.plist" ofType:nil];
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:path];
        
        NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:dictArray.count];
        for (NSDictionary *dict in dictArray) {
            JKSort *sort = [JKSort sortWithDict:dict];
            [arrayM addObject:sort];
        }
        _sorts = [arrayM copy];
    }
    return _sorts;
}

@end
