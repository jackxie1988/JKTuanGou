//
//  JKCityViewController.m
//  美团HD
//
//  Created by 谢聪捷 on 3/13/15.
//  Copyright (c) 2015 Jack-Xie. All rights reserved.
//

#import "JKCityViewController.h"
#import "UIBarButtonItem+JKExtension.h"

@interface JKCityViewController ()

@end

@implementation JKCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. 设置标题
    self.title = @"切换城市";
    // 2. 使用自定义 UIBarButtonItem 的扩展方法设置导航栏左边的样式
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"btn_navigation_close" highImage:@"btn_navigation_close_hl" target:self action:@selector(close)];
}

- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
