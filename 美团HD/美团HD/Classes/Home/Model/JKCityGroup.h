//
//  JKCityGroup.h
//  美团HD
//
//  Created by 谢聪捷 on 3/13/15.
//  Copyright (c) 2015 Jack-Xie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKCityGroup : NSObject
///  这组的所有城市内容名称
@property (nonatomic,strong) NSArray *cities;
///  这组的头部标题名称
@property (nonatomic,copy) NSString *title;

///  提供接口方法 KVC 字典转模型
+ (instancetype)cityGroupWithDict:(NSDictionary *)dict;

@end
