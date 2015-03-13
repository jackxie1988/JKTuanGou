//
//  JKCategory.h
//  美团HD
//
//  Created by 谢聪捷 on 3/13/15.
//  Copyright (c) 2015 Jack-Xie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKCategory : NSObject
///  类别名称
@property (nonatomic,copy) NSString *name;
///  子类别名称
@property (nonatomic,strong) NSArray *subcategories;
///  显示在导航栏右边的大图标
@property (nonatomic,copy) NSString *highlighted_icon;
@property (nonatomic,copy) NSString *icon;
///  显示在下拉菜单的小图标
@property (nonatomic,copy) NSString *small_highlighted_icon;
@property (nonatomic,copy) NSString *small_icon;

// 地图图标
@property (nonatomic,copy) NSString *map_icon;


///  KVC 字典转模型接口方法
+ (instancetype)categoryWithDict:(NSDictionary *)dict;


@end
