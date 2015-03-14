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

@interface JKCityViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

///  按钮遮盖
@property (nonatomic, weak) UIButton *cover;

@end

@implementation JKCityViewController

///  实现遮盖按钮的懒加载方法
- (UIButton *)cover {
    if (_cover == nil) {
        UIButton *cover = [[UIButton alloc] init];
        cover.backgroundColor = [UIColor lightGrayColor];
        
        // 为遮盖按钮绑定一个监听事件
        [cover addTarget:self.searchBar action:@selector(resignFirstResponder) forControlEvents:UIControlEventTouchUpInside];
        
        cover.alpha = 0.5;
        [self.view addSubview:cover];
        
        // 使用第三方框架为遮盖添加约束
        [cover autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [cover autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.tableView];
        
        _cover = cover;
    }
    return _cover;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. 设置标题
    self.title = @"切换城市";
    // 2. 使用自定义 UIBarButtonItem 的扩展方法设置导航栏左边的样式
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"btn_navigation_close" highImage:@"btn_navigation_close_hl" target:self action:@selector(close)];
    
    // 设置表格的索引文字颜色
    self.tableView.sectionIndexColor = [UIColor blackColor];
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
    
}
// 点击取消按钮
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar endEditing:YES];
}


@end
