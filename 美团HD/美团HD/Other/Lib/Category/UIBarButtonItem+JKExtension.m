//
//  UIBarButtonItem+JKExtension.m
//  美团HD
//
//  Created by 谢聪捷 on 3/10/15.
//  Copyright (c) 2015 Jack-Xie. All rights reserved.
//

#import "UIBarButtonItem+JKExtension.h"

@implementation UIBarButtonItem (JKExtension)

+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action {
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    button.frame = (CGRect){CGPointZero,button.currentImage.size};
    
    // 将按钮包装成一个 UIBarButtonItem 对象返回
    return [[self alloc] initWithCustomView:button];
}

@end
