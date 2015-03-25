//
//  __HDTests.m
//  美团HDTests
//
//  Created by 谢聪捷 on 3/9/15.
//  Copyright (c) 2015 Jack-Xie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NSString+JKExtension.h"

@interface __HDTests : XCTestCase

@end

@implementation __HDTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}
/**
 *  测试价格字符串
 */
- (void)testString {
    NSString *str = @"89.9000006754";
    NSString *result = [str dealedPriceString];
    NSAssert([result isEqualToString:@"89.9"], @"dealedPriceString处理有问题");
    
}
/**
 *  测试日期
 */
- (void)testCalendar {
    // 创建日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 创建日期
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date1 = [fmt dateFromString:@"2013-08-06 22:35:20"];
    NSDate *date2 = [fmt dateFromString:@"2015-08-06 22:35:20"];
    
    // 比较时间
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *cmps = [calendar components:unit fromDate:date1 toDate:date2 options:kNilOptions];
    
    NSAssert(cmps.year == 2, @"NSCalendar 计算有问题！");
}

@end



