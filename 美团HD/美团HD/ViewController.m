//
//  ViewController.m
//  美团HD
//
//  Created by 谢聪捷 on 3/9/15.
//  Copyright (c) 2015 Jack-Xie. All rights reserved.
//

#import "ViewController.h"
#import "DPAPI.h"




@interface ViewController ()<DPRequestDelegate>


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DPAPI *api = [[DPAPI alloc] init];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"city"] = @"北京";
    [api requestWithURL:@"v1/deal/find_deals" params:params delegate:self];
    
}

- (void)request:(DPRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"请求失败 - %@",error);
}

- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result {
    NSLog(@"请求成功 - %@",result);
}

@end
