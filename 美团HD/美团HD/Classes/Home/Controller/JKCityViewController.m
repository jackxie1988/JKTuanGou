//
//  JKCityViewController.m
//  美团HD
//
//  Created by 谢聪捷 on 3/13/15.
//  Copyright (c) 2015 Jack-Xie. All rights reserved.
//

#import "JKCityViewController.h"
#import "UIBarButtonItem+JKExtension.h"
#import "JKDataTool.h"
#import "JKCityGroup.h"
#import "UIView+AutoLayout.h"
#import "JKCityResultViewController.h"

@interface JKCityViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

///  按钮遮盖
@property (nonatomic, weak) IBOutlet UIButton *cover;
///  城市搜索结果控制器的属性
@property (nonatomic,weak) JKCityResultViewController *cityResultVC;

@end

@implementation JKCityViewController

- (JKCityResultViewController *)cityResultVC {
    if (_cityResultVC == nil) {
        JKCityResultViewController *cityResultVC = [[JKCityResultViewController alloc] init];
        [self addChildViewController:cityResultVC];
        [self.view addSubview:cityResultVC.view];
        
        [cityResultVC.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [cityResultVC.view autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.tableView];
        self.cityResultVC = cityResultVC;
    }
    return _cityResultVC;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. 设置标题
    self.title = @"切换城市";
    // 2. 使用自定义 UIBarButtonItem 的扩展方法设置导航栏左边的样式
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"btn_navigation_close" highImage:@"btn_navigation_close_hl" target:self action:@selector(close)];
    
    // 设置表格的索引文字颜色
    self.tableView.sectionIndexColor = [UIColor blackColor];
    
    // 添加监听遮盖按钮点击
    [self.cover addTarget:self.searchBar action:@selector(resignFirstResponder) forControlEvents:UIControlEventTouchUpInside];
}

- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [JKDataTool cityGroups].count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    JKCityGroup *cityGroup = [JKDataTool cityGroups][section];
    return cityGroup.cities.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"city";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    // 设置城市名称
    JKCityGroup *cityGroup = [JKDataTool cityGroups][indexPath.section];
    cell.textLabel.text = cityGroup.cities[indexPath.row];
    return cell;
}

#pragma mark - 代理方法
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    JKCityGroup *cityGroup = [JKDataTool cityGroups][section];
    return cityGroup.title;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    // 使用 valueForKeyPath 获得索引数组
    return [[JKDataTool cityGroups] valueForKeyPath:@"title"];
}

#pragma mark - 搜索框代理
///  当搜索框已经进入编辑状态 (键盘已经弹出)
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    // 1. 让搜索框背景变为绿色
    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield_hl"];
    // 2,显示 cancel 按钮
    [searchBar setShowsCancelButton:YES animated:YES];
    // 3.导航条以动画形式向上消失
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    // 4.添加蒙版
    self.cover.hidden = NO;
    
}

///  当搜索框已经退出编辑状态 (键盘已经退下)
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    // 1. 让搜索框背景变为灰色
    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield"];
    // 2.隐藏 cancel 按钮
    [searchBar setShowsCancelButton:NO animated:YES];
    // 3.导航条向下以动画形式出现 
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    // 4.移除蒙版
    self.cover.hidden = YES;
    
    // 5.清除搜索框文字
    searchBar.text = nil;
    // 6.隐藏搜索结果控制器
    self.cityResultVC.view.hidden = YES;
    
}
// 点击取消按钮
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar endEditing:YES];
}
// 搜索框的文字改变
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//    if (searchText.length != 0) {
//        self.cityResultVC.view.hidden = NO;
//    } else {
//        self.cityResultVC.view.hidden = YES;
//    }
    self.cityResultVC.view.hidden = (searchText.length == 0);
    self.cityResultVC.searchText = searchText;
}
@end


























