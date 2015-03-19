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
#import "JKDropDownLeftCell.h"
#import "JKDropDownRightCell.h"
#import "JKDistrict.h"

@interface JKDistrictViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;

@end

@implementation JKDistrictViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = JKRandomColor;
    CGFloat rowHeight = 40;
    self.leftTableView.rowHeight = rowHeight;
    self.rightTableView.rowHeight = rowHeight;
    self.preferredContentSize = CGSizeMake(400, 400);
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
    if (tableView == self.leftTableView) {
        return self.districts.count;
    } else {
        NSInteger leftSelectedRow = [self.leftTableView indexPathForSelectedRow].row;
        JKDistrict *district = self.districts[leftSelectedRow];
        return district.subdistricts.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (tableView == self.leftTableView) {
        cell = [JKDropDownLeftCell cellWithTableView:tableView];
        
        JKDistrict *district = self.districts[indexPath.row];
        cell.textLabel.text = district.name;
        cell.accessoryType = district.subdistricts.count ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    } else {
        cell = [JKDropDownRightCell cellWithTableView:tableView];
        
        NSInteger leftSelectedRow = [self.leftTableView indexPathForSelectedRow].row;
        JKDistrict *district = self.districts[leftSelectedRow];
        cell.textLabel.text = district.subdistricts[indexPath.row];
    }
    return cell;
}

#pragma mark - 代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTableView) {
        [self.rightTableView reloadData];
        
        JKDistrict *district = self.districts[indexPath.row];
        if (district.subdistricts.count == 0) {
            [self postNote:district subdistrictIndex:nil];
        }
    } else {
        NSInteger leftSelectedRow = [self.leftTableView indexPathForSelectedRow].row;
        JKDistrict *district = self.districts[leftSelectedRow];
        [self postNote:district subdistrictIndex:@(indexPath.row)];
    }
}

#pragma mark - 私有方法
- (void)postNote:(JKDistrict *)district subdistrictIndex:(id)subdistrictIndex {
    // 1. 销毁当前控制器
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // 2. 发送通知
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[JKCurrentDistrictKey] = district;
    if (subdistrictIndex) {
        userInfo[JKCurrentSubCategoryIndexKey] = subdistrictIndex;
    }
    [JKNoteCenter postNotificationName:JKDistrictDidChangeNotification object:nil userInfo:userInfo];
}

@end







































