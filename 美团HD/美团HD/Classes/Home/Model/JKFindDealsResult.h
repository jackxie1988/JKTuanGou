//
//  JKFindDealsResult.h
//  美团HD
//
//  Created by 谢聪捷 on 3/19/15.
//  Copyright (c) 2015 Jack-Xie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKFindDealsResult : NSObject
///  所有团购总数
@property (nonatomic,assign) int total_count;
///  本次团购数据 - 里面装的都是团购模型
@property (nonatomic,strong) NSArray *deals;

@end
