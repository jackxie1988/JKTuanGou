//
//  JKDataTool.m
//  美团HD
//
//  Created by 谢聪捷 on 3/13/15.
//  Copyright (c) 2015 Jack-Xie. All rights reserved.
//

#import "JKDataTool.h"
#import "JKSort.h"
#import "JKCategory.h"
#import "JKCityGroup.h"

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


// 使用 MJExtension 进行字典转模型
static NSArray *_categories;
+ (NSArray *)categories {
//    if (_categories == nil) {
//        _categories = [JKCategory objectArrayWithFilename:@"categories.plist"];
//    }
    
    if (_categories == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"categories.plist" ofType:nil];
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:dictArray.count];
        for ( NSDictionary *dict in dictArray) {
            JKCategory *category = [JKCategory categoryWithDict:dict];
            [arrayM addObject:category];
        }
        _categories = [arrayM copy];
    }
    return _categories;
}

static NSArray *_cityGroups;
+ (NSArray *)cityGroups {
    if (_cityGroups == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"cityGroups.plist" ofType:nil];
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:dictArray.count];
        for (NSDictionary *dict in dictArray) {
            JKCityGroup *cityGroup = [JKCityGroup cityGroupWithDict:dict];
            [arrayM addObject:cityGroup];
        }
        _cityGroups = [arrayM copy];
    }
    return _cityGroups;
}

@end
