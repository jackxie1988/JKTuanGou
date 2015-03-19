//
//  JKCity.h
//  美团HD
//
//  Created by 谢聪捷 on 3/19/15.
//  Copyright (c) 2015 Jack-Xie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKCity : NSObject
///  城市名称
@property (nonatomic,copy) NSString *name;
///  城市名称的拼音
@property (nonatomic,copy) NSString *pinYin;
///  城市名称的拼音声母
@property (nonatomic,copy) NSString *pinYinHead;

//  使用苹果系统的 KVC 字典转模型，需要将系统的每一个属性都写上，即使不用
//  也需要写全，否则在使用 setValuesForKeysWithDictionary 时，系统会崩溃！
@property (nonatomic,strong) NSArray *districts;

// 字典转模型接口方法
+ (instancetype)cityWithDict:(NSDictionary *)dict;

@end
