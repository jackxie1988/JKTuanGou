//
//  JKCityResultViewController.m
//  美团HD
//
//  Created by 谢聪捷 on 3/19/15.
//  Copyright (c) 2015 Jack-Xie. All rights reserved.
//

#import "JKCityResultViewController.h"
#import "JKDataTool.h"
#import "JKCity.h"

@interface JKCityResultViewController ()

///  存储城市搜索结果的数组属性
@property (nonatomic,strong) NSArray *resultCities;

@end

@implementation JKCityResultViewController


- (void)setSearchText:(NSString *)searchText {
    if (searchText.length == 0) return;
    
    _searchText = [searchText copy];
    searchText = searchText.lowercaseString; // 转成小写字母
    
    // 获取城市模型数组，然后根据搜索条中传入的内容进行遍历
    NSArray *cities = [JKDataTool cities];
    
    // 创建过滤条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains %@ or pinYin contains %@ or pinYinHead contains %@",searchText,searchText,searchText];
    self.resultCities = [cities filteredArrayUsingPredicate:predicate];
    
    
    // 刷新表格数据
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultCities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"city";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    
    JKCity *city = self.resultCities[indexPath.row];
    cell.textLabel.text = city.name;
    
    return cell;
}

#pragma mark - 代理方法
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"共有%zd个搜索结果",self.resultCities.count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1.销毁当前控制器
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // 2.取出城市模型
    JKCity *city = self.resultCities[indexPath.row];
    
    // 3.发送通知
    NSDictionary *userInfo = @{JKCurrentCityKey : city};
    [JKNoteCenter postNotificationName:JKCityDidChangeNotification object:nil userInfo:userInfo];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
