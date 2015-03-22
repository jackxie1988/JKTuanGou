//
//  NSString+JKExtension.m
//  美团HD
//
//  Created by 谢聪捷 on 3/22/15.
//  Copyright (c) 2015 Jack-Xie. All rights reserved.
//

#import "NSString+JKExtension.h"

@implementation NSString (JKExtension)

- (instancetype)dealedPriceString {
    NSString *newString = self;
    
    NSUInteger dotLoc = [newString rangeOfString:@"."].location;
    if (dotLoc != NSNotFound) {
        NSUInteger decimalCount = newString.length - dotLoc - 1;
        if (decimalCount > 2) {
            newString = [newString substringToIndex:dotLoc + 3];
            if ([newString hasSuffix:@"0"]) {
                newString = [newString substringToIndex:newString.length - 1];
            }
        }
    }
    return newString;
}

@end
