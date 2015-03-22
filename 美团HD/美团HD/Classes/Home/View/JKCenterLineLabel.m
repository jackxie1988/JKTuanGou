//
//  JKCenterLineLabel.m
//  美团HD
//
//  Created by 谢聪捷 on 3/19/15.
//  Copyright (c) 2015 Jack-Xie. All rights reserved.
//

#import "JKCenterLineLabel.h"

@implementation JKCenterLineLabel

- (void)drawRect:(CGRect)rect {
    
    // 一定要先调用一下父类的 drawRect 方法
    [super drawRect:rect];
    
    CGFloat x = 0 + rect.origin.x;
    CGFloat y = rect.size.height * 0.5 + rect.origin.y;
    CGFloat w = rect.size.width;
    CGFloat h = 1;
    UIRectFill(CGRectMake(x, y, w, h));
    
    // 方法二
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    
//    // 起点
//    CGFloat startX = 0;
//    CGFloat startY = rect.size.height * 0.5 + rect.origin.y;
//    CGContextMoveToPoint(ctx, startX, startY);
//    
//    // 终点
//    CGFloat endX = rect.size.width;
//    CGFloat endY = startY;
//    CGContextAddLineToPoint(ctx, endX, endY);
//    
//    CGContextStrokePath(ctx);
}

@end
