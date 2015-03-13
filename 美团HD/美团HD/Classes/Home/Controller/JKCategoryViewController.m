//
//  JKCategoryViewController.m
//  美团HD
//
//  Created by 谢聪捷 on 3/11/15.
//  Copyright (c) 2015 Jack-Xie. All rights reserved.
//

#import "JKCategoryViewController.h"
#import "JKDataTool.h"
#import "JKCategory.h"
#import "JKDropDownLeftCell.h"
#import "JKDropDownRightCell.h"

@interface JKCategoryViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTabelView;
@end

@implementation JKCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置 popover 的大小
    CGFloat rowHeight = 40;
    self.leftTableView.rowHeight = rowHeight;
    self.rightTabelView.rowHeight = rowHeight;
    self.preferredContentSize = CGSizeMake(400, rowHeight * [JKDataTool categories].count);
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.leftTableView) {
        return [JKDataTool categories].count;
    } else {
        
    ///  先获取左边选中的行，取出模型，再根据模型中 subcategories 属性数组的个数设置右边tableView的数量
        NSInteger leftSelectedRow = [self.leftTableView indexPathForSelectedRow].row;
        JKCategory *category = [JKDataTool categories][leftSelectedRow];
        return category.subcategories.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (tableView == self.leftTableView) {
        
        cell = [JKDropDownLeftCell cellWithTableView:tableView];
        
        JKCategory *category = [JKDataTool categories][indexPath.row];
        cell.textLabel.text = category.name;
        cell.accessoryType = category.subcategories.count ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
        cell.imageView.image = [UIImage imageNamed:category.small_icon];
        cell.imageView.highlightedImage = [UIImage imageNamed:category.small_highlighted_icon];
    } else { // 右边表格数据
        
        cell = [JKDropDownRightCell cellWithTableView:tableView];
        
        // 先获取左边选中的行，再设置右边的数据
        NSInteger leftSelectedRow = [self.leftTableView indexPathForSelectedRow].row;
        JKCategory *category = [JKDataTool categories][leftSelectedRow];
        cell.textLabel.text = category.subcategories[indexPath.row];
    }    
    return cell;
}

#pragma mark - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTableView) {
         // 选中左边行的时候刷新右边的数据
        if (tableView == self.leftTableView) {
            [self.rightTabelView reloadData];
            
            // 如果用户点击左边，而左边选项没有子类别，就发送通知
            JKCategory *category = [JKDataTool categories][indexPath.row];
            if (category.subcategories.count == 0) {
                [self postNote:category subcategoryIndex:nil];
            }
        }
    } else {
        // 点击右边 发送通知
        NSInteger leftSelectedRow = [self.leftTableView indexPathForSelectedRow].row;
        JKCategory *category = [JKDataTool categories][leftSelectedRow];
        [self postNote:category subcategoryIndex:@(indexPath.row)];
    }
}

#pragma mark - 私有方法
- (void)postNote:(JKCategory *)category subcategoryIndex:(id)subcategoryIndex {
    // 1. 销毁当前控制器
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // 2. 发送通知
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[JKCurrentCategoryKey] = category;
    if (subcategoryIndex) {
        userInfo[JKCurrentSubCategoryIndexKey] = subcategoryIndex;
    }
    [JKNoteCenter postNotificationName:JKCategoryDidChangeNotification object:nil userInfo:userInfo];
}

@end
