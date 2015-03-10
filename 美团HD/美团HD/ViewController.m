//
//  ViewController.m
//  美团HD
//
//  Created by 谢聪捷 on 3/9/15.
//  Copyright (c) 2015 Jack-Xie. All rights reserved.
//

#import "ViewController.h"
#import "DPAPI.h"




@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"city"] = @"北京";
    [[DPAPI sharedInstance] request:@"v1/deal/find_deals" params:params success:^(id result) {
        NSLog(@"请求成功 - %@",result);
    } failure:^(NSError *error) {
        NSLog(@"请求失败");
    }];
}


@end
