//
//  JKDistrict.h
//  美团HD
//
//  Created by 谢聪捷 on 3/19/15.
//  Copyright (c) 2015 Jack-Xie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKDistrict : NSObject

///  区域名称
@property (nonatomic,copy) NSString *name;

///  这个区域的所有子区域
@property (nonatomic,strong) NSArray *subdistricts;

@end
