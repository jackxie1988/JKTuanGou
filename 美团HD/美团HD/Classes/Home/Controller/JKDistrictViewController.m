//
//  JKDistrictViewController.m
//  美团HD
//
//  Created by 谢聪捷 on 3/11/15.
//  Copyright (c) 2015 Jack-Xie. All rights reserved.
//

#import "JKDistrictViewController.h"
#import "JKCityViewController.h"
#import "JKNavigationController.h"

@interface JKDistrictViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;

@end

@implementation JKDistrictViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = JKRandomColor;
}
///  切换城市
- (IBAction)changeCity {
    // 1. 销毁当前控制器
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // 2. 弹出切换城市的控制器
    JKCityViewController *cityVC = [[JKCityViewController alloc] init];
    JKNavigationController *nav = [[JKNavigationController alloc] initWithRootViewController:cityVC];
    // 重点：设置弹出控制器的样式，表格样式
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    // 重点：拿到主窗口的根控制器，让根控制器弹出切换城市控制器
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootVC presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end
