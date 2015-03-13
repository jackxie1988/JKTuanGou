//
//  JKDataTool.h
//  美团HD
//
//  Created by 谢聪捷 on 3/13/15.
//  Copyright (c) 2015 Jack-Xie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKDataTool : NSObject

///  返回所有的排数数据 (数组)
+ (NSArray *)sorts;

///  返回所有的分类数据 (数组)
+ (NSArray *)categories;

///  返回所有的城市组数据
+ (NSArray *)cityGroups;

@end
