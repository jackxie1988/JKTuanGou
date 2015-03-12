//
//  JKSort.h
//  美团HD
//
//  Created by 谢聪捷 on 3/12/15.
//  Copyright (c) 2015 Jack-Xie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKSort : NSObject

// 文字描述
@property (nonatomic,copy) NSString *label;
// 这个排序具体的值，将来要发送给服务器的
@property (nonatomic,assign) int value;

// KVC 接口方法
+ (instancetype)sortWithDict:(NSDictionary *)dict;

@end
