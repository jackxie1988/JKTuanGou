//
//  JKGetSingleDealResult.h
//  美团HD
//
//  Created by 谢聪捷 on 3/26/15.
//  Copyright (c) 2015 Jack-Xie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKGetSingleDealResult : NSObject
/**
 *  本次团购数据  里面装着都是JKDeal模型 
 */
@property (nonatomic,strong) NSArray *deals;

@end
