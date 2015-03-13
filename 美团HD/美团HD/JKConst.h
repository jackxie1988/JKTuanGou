//
//  JKConst.h
//  美团HD
//
//  Created by 谢聪捷 on 3/13/15.
//  Copyright (c) 2015 Jack-Xie. All rights reserved.
//

#import <UIKit/UIKit.h>
///  排序改变的通知
UIKIT_EXTERN NSString *const JKSortDidChangeNotification;
///  通过这个 key 可以去除当前的排序模型
UIKIT_EXTERN NSString *const JKCurrentSortKey;
///  类别改变的通知
UIKIT_EXTERN NSString *const JKCategoryDidChangeNotification;
///  通过这个key可以取出当前的类别模型
UIKIT_EXTERN NSString *const JKCurrentCategoryKey;
///  通过这个可以可以取出当前子类别的索引
UIKIT_EXTERN NSString *const JKCurrentSubCategoryIndexKey;