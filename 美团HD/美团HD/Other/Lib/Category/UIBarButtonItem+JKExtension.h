//
//  UIBarButtonItem+JKExtension.h
//  美团HD
//
//  Created by 谢聪捷 on 3/10/15.
//  Copyright (c) 2015 Jack-Xie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (JKExtension)

///  创建一个拥有两张图片的 item
///
///  @param image     普通图片
///  @param highImage 高亮图片
///  @param target    谁是按钮事件监听者
///  @param action    按钮被点击后调用的方法
///
///  @return 返回创建的 item
+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;

@end
