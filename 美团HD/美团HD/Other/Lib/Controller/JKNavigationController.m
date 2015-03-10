//
//  JKNavigationController.m
//  美团HD
//
//  Created by 谢聪捷 on 3/10/15.
//  Copyright (c) 2015 Jack-Xie. All rights reserved.
//

#import "JKNavigationController.h"

@interface JKNavigationController ()

@end

@implementation JKNavigationController


+ (void)initialize {
    // 设置导航栏背景图片
    UINavigationBar *bar = [UINavigationBar appearance];
    UIImage *image = [UIImage imageNamed:@"bg_navigationBar_normal"];
    [bar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
