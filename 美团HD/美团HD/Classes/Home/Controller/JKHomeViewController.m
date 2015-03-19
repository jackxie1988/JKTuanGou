//
//  JKHomeViewController.m
//  美团HD
//
//  Created by 谢聪捷 on 3/10/15.
//  Copyright (c) 2015 Jack-Xie. All rights reserved.
//

#import "JKHomeViewController.h"
#import "UIBarButtonItem+JKExtension.h"
#import "JKHomeTopItem.h"
#import "JKSortViewController.h"
#import "JKDistrictViewController.h"
#import "JKCategoryViewController.h"
#import "JKSort.h"
#import "JKCategory.h"
#import "JKCity.h"
#import "JKDistrict.h"
#import "DPAPI.h"
#import "MJExtension.h"
#import "JKFindDealsResult.h"
#import "JKDeal.h"
#import "JKDealCell.h"

@interface JKHomeViewController ()
///  导航栏上面的 item
@property (nonatomic,strong) UIBarButtonItem *sortItem;
@property (nonatomic,strong) UIBarButtonItem *districtItem;
@property (nonatomic,strong) UIBarButtonItem *categoryItem;

///  记录一些当前数据
///  当前城市
@property (nonatomic,strong) JKCity *currentCity;
///  当前的排序
@property (nonatomic,strong) JKSort *currentSort;
///  当前的类别名称 - 发送给服务器
@property (nonatomic,copy) NSString *currentCategoryName;
///  当前的区域名称 - 发送给服务器
@property (nonatomic,copy) NSString *currentRegionName;


// 显示所有的团购
@property (nonatomic,strong) NSMutableArray *deals;

@end

@implementation JKHomeViewController

- (NSMutableArray *)deals {
    if (_deals == nil) {
        _deals = [NSMutableArray array];
    }
    return _deals;
}

static NSString * const reuseIdentifier = @"Deal";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"JKDealCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.collectionView.backgroundColor = JKColor(230, 230, 230);
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    layout.itemSize = CGSizeMake(305, 305); // cell 的尺寸大小与xib保持一致
    
    
    // 设置导航栏左边
    [self setUpNavLeft];
    
    // 设置导航栏右边
    [self setUpNavRight];
    
    [self setUpNotes];
}

#pragma mark - 添加通知
- (void)setUpNotes {
    [JKNoteCenter addObserver:self selector:@selector(sortDidChange:) name:JKSortDidChangeNotification object:nil];
    [JKNoteCenter addObserver:self selector:@selector(categoryDidChange:) name:JKCategoryDidChangeNotification object:nil];
    [JKNoteCenter addObserver:self selector:@selector(cityDidChange:) name:JKCityDidChangeNotification object:nil];
    [JKNoteCenter addObserver:self selector:@selector(districtDidChange:) name:JKDistrictDidChangeNotification object:nil];
}
- (void)dealloc {
    [JKNoteCenter removeObserver:self];
}
#pragma mark - 通知处理
- (void)sortDidChange:(NSNotification *)note {
    JKHomeTopItem *topItem = (JKHomeTopItem *)self.sortItem.customView;
    
    self.currentSort = note.userInfo[JKCurrentSortKey];
    topItem.subtitle = self.currentSort.label;
    
//    JKSort *sort = note.userInfo[JKCurrentSortKey];
//    topItem.subtitle = sort.label;
    [self loadNewDeals]; // 发送请求给服务器
}
- (void)categoryDidChange:(NSNotification *)note {
    // 取得导航栏上面的自定义视图
    JKHomeTopItem *topItem = (JKHomeTopItem *)self.categoryItem.customView;
    // 同时通知传进来的 key 取出模型
    JKCategory *category = note.userInfo[JKCurrentCategoryKey];
    // 取出模型中子类型里所对应的下标
    int subcategoryIndex = [note.userInfo[JKCurrentSubCategoryIndexKey] intValue];
    NSString *subcategory = category.subcategories[subcategoryIndex];
    
    // 设置导航栏属性内容
    topItem.title = category.name;
    topItem.subtitle = subcategory;
    [topItem setIcon:category.icon highIcon:category.highlighted_icon];
    
    // 记录发送给服务器的类别名称
    self.currentCategoryName = subcategory ? subcategory : category.name;
    if ([self.currentCategoryName isEqualToString:@"全部"]) {
        self.currentCategoryName = category.name;
    } else if ([self.currentCategoryName isEqualToString:@"全部分类"]) {
        self.currentCategoryName = nil; // 如果用户点击了左边的全部分类，就不分这个参数，意味着加载全部
    }
    
    [self loadNewDeals]; // 发送请求给服务器
}
- (void)cityDidChange:(NSNotification *)note {
    // 更新导航栏顶部
    JKHomeTopItem *topItem = (JKHomeTopItem *)self.districtItem.customView;
    
    // 取出模型
    self.currentCity = note.userInfo[JKCurrentCityKey];
    
    topItem.title = [NSString stringWithFormat:@"%@ - 全部",self.currentCity.name];
    topItem.subtitle = nil;
    
    [self loadNewDeals]; // 发送请求给服务器
}
- (void)districtDidChange:(NSNotification *)note {
    // 1.更新导航栏顶部
    JKHomeTopItem *topItem = (JKHomeTopItem *)self.districtItem.customView;
    // 2.取出模型
    JKDistrict *district = note.userInfo[JKCurrentDistrictKey];
    int subdistrictIndex = [note.userInfo[JKCurrentSubCategoryIndexKey] intValue];
    NSString *subdistrictName = district.subdistricts[subdistrictIndex];
    // 3.设置数据
    topItem.title = [NSString stringWithFormat:@"%@ - %@",self.currentCity.name,district.name];
    topItem.subtitle = subdistrictName;
    
    // 记录发送给服务器的区域名称
    self.currentRegionName = subdistrictName ? subdistrictName : district.name;
    if ([self.currentRegionName isEqualToString:@"全部"]) {
        self.currentRegionName = subdistrictName ? district.name : nil;
    }
    
    [self loadNewDeals];
}

#pragma mark - 设置导航栏
// 设置导航栏左边
- (void)setUpNavLeft {
    
    UIImage *image = [UIImage imageNamed:@"icon_meituan_logo"];
    // 设置图片的渲染颜色
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *logoItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:nil action:nil];
    
    // 分类
    JKHomeTopItem *catagory = [JKHomeTopItem item];
    catagory.title = @"全部分类";
    catagory.subtitle = nil;
    [catagory setIcon:@"icon_category_-1" highIcon:@"icon_category_highlighted_-1"];
    [catagory addTarget:self action:@selector(categoryClicked)];
    self.categoryItem = [[UIBarButtonItem alloc] initWithCustomView:catagory];
    // 区域
    JKHomeTopItem *district = [JKHomeTopItem item];
    district.title = @"北京";
    district.subtitle = @"北京";
    [district setIcon:@"icon_district" highIcon:@"icon_district_highlighted"];
    [district addTarget:self action:@selector(districtClicked)];
    self.districtItem = [[UIBarButtonItem alloc] initWithCustomView:district];
    // 排序
    JKHomeTopItem *sort = [JKHomeTopItem item];
    sort.title = @"排序";
    sort.subtitle = @"默认排序";
    [sort setIcon:@"icon_sort" highIcon:@"icon_sort_highlighted"];
    [sort addTarget:self action:@selector(sortClicked)];
    self.sortItem = [[UIBarButtonItem alloc] initWithCustomView:sort];
    
    // 添加到 leftBarButtonItems 数组中
    self.navigationItem.leftBarButtonItems = @[logoItem, self.categoryItem, self.districtItem, self.sortItem];
}

// 设置导航栏右边
- (void)setUpNavRight {
    // 将按钮包装成自定义 UIBarButtonItem,因为导航栏中只能放 UIBarButtonItem
    UIBarButtonItem *searchItem = [UIBarButtonItem itemWithImage:@"icon_search" highImage:@"icon_search_highlighted" target:self action:@selector(searchBtnClicked)];
    searchItem.customView.width = 50;
    
    UIBarButtonItem *mapItem = [UIBarButtonItem itemWithImage:@"icon_map" highImage:@"icon_map_highlighted" target:self action:@selector(mapBtnClicked)];
    mapItem.customView.width = searchItem.customView.width;
    
    self.navigationItem.rightBarButtonItems = @[mapItem,searchItem];
}

#pragma mark - 按钮点击监听方法
- (void)searchBtnClicked {
    JKLog(@"searchBtnClicked");
}
- (void)mapBtnClicked {
    JKLog(@"mapBtnClicked");
}
- (void)categoryClicked {
//    JKLog(@"categoryClicked");
    
    JKCategoryViewController *categoryVC = [[JKCategoryViewController alloc] init];
    categoryVC.modalPresentationStyle = UIModalPresentationPopover;
    categoryVC.popoverPresentationController.barButtonItem = self.categoryItem;
    
    [self presentViewController:categoryVC animated:YES completion:nil];
    
}
- (void)districtClicked {
//    JKLog(@"districtClicked");
    JKDistrictViewController *districtVC = [[JKDistrictViewController alloc] init];
    districtVC.modalPresentationStyle = UIModalPresentationPopover;
    districtVC.popoverPresentationController.barButtonItem = self.districtItem;
    
    districtVC.districts = self.currentCity.districts;
    
    [self presentViewController:districtVC animated:YES completion:nil];
}
- (void)sortClicked {
//    JKLog(@"sortClicked");
    
    JKSortViewController *sortVC = [[JKSortViewController alloc] init];
    sortVC.modalPresentationStyle = UIModalPresentationPopover;
    sortVC.popoverPresentationController.barButtonItem = self.sortItem;
    
    [self presentViewController:sortVC animated:YES completion:nil];
}

#pragma mark - 发送请求给服务器 - 加载新的团购
- (void)loadNewDeals {
    // 如果没有选择城市，直接返回
    if (self.currentCity == nil) return;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    // 城市
    params[@"city"] = self.currentCity.name;
    // 区域
    if (self.currentRegionName) params[@"region"] = self.currentRegionName;
    // 类别
    if (self.currentCategoryName) params[@"category"] = self.currentCategoryName;
    // 排序
    if (self.currentSort) params[@"sort"] = @(self.currentSort.value);
    
    
    JKLog(@"params - %@",params);
    [[DPAPI sharedInstance] request:@"v1/deal/find_deals" params:params success:^(id json) {
        // 使用MJ框架解析json数据
        JKFindDealsResult *result = [JKFindDealsResult objectWithKeyValues:json];
        
        // 移除旧数据
        [self.deals removeAllObjects];
        
        // 添加新数据
        [self.deals addObjectsFromArray:result.deals];
        
        // 刷新表格
        [self.collectionView reloadData];
        
        
    } failure:^(NSError *error) {
        JKLog(@"failure - %@",error);
    }];
}

/***************************************** 数据源方法 *****************************************/

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

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.deals.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JKDealCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
