//
//  JKSingleton.h
//  美团HD
//
//  Created by 谢聪捷 on 3/10/15.
//  Copyright (c) 2015 Jack-Xie. All rights reserved.
//

#define JKSingleton_H + (instancetype)sharedInstance;

#define JKSingleton_M \
static id _instance; \
+ (instancetype)allocWithZone:(struct _NSZone *)zone { \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _instance = [super allocWithZone:zone]; \
    }); \
    return _instance; \
} \
+ (instancetype)sharedInstance { \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _instance = [[self alloc] init]; \
    }); \
    return _instance; \
}


