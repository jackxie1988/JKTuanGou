//
//  JKHomeTopItem.h
//  美团HD
//
//  Created by 谢聪捷 on 3/10/15.
//  Copyright (c) 2015 Jack-Xie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKHomeTopItem : UIView

+ (instancetype)item;
// 标题
- (void)setTitle:(NSString *)title;
// 子标题
- (void)setSubtitle:(NSString *)subtitle;
// 设置普通 / 高亮图片
- (void)setIcon:(NSString *)icon highIcon:(NSString *)highIcon;
// 按钮点击事件
- (void)addTarget:(id)target action:(SEL)action;

@end
