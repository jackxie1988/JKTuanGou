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
#import "MJRefresh.h"
#import "JKDataTool.h"
#import "UIView+AutoLayout.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
#import "JKDetailViewController.h"

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
/**
 *  当前页码
 */
@property (nonatomic,assign) int currentPage;
/**
 *  当前正在发送的网络请求
 */
@property (nonatomic,weak) DPRequest *currentRequest;
/**
 *  没有团购数据时显示的提醒图片
 */
@property (nonatomic,weak) UIImageView *noDataView;
/**
 *  搜索到的团购结果属性
 */
@property (nonatomic,strong) JKFindDealsResult *result;


// 显示所有的团购
@property (nonatomic,strong) NSMutableArray *deals;

@end

@implementation JKHomeViewController

- (UIImageView *)noDataView {
    if (_noDataView == nil) {
        UIImageView *noDataView = [[UIImageView alloc] init];
        noDataView.image = [UIImage imageNamed:@"icon_deals_empty"];
        noDataView.contentMode = UIViewContentModeCenter;
        [self.view addSubview:noDataView];
        // 添加约束
        [noDataView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        // 赋值记录
        self.noDataView = noDataView;
    }
    return _noDataView;
}

- (NSMutableArray *)deals {
    if (_deals == nil) {
        _deals = [NSMutableArray array];
    }
    return _deals;
}

static NSString * const reuseIdentifier = @"Deal";

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    JKLog(@"%@",NSStringFromCGRect(self.view.frame));
    // 输出结果   {{0, 0}, {768, 1024}}
    
    // 在视图即将显现的时候调用 监听屏幕旋转方法
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    [self viewWillTransitionToSize:screenSize withTransitionCoordinator:nil];
    
}

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
    
    // 监听通知
    [self setUpNotes];
    
    // 添加刷新功能
    [self setupRefresh];
}

- (void)setupRefresh {
    [self.collectionView addHeaderWithTarget:self action:@selector(loadNewDeals)];
    [self.collectionView addFooterWithTarget:self action:@selector(loadMoreDeals)];
    self.collectionView.footerHidden = YES;
    
#warning TODO
    self.currentCity = [JKDataTool cityWithName:@"北京"];
    [self.collectionView headerBeginRefreshing];
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
    
    // 清除正在发送的请求
    [self.currentRequest disconnect];
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
    
    // 取消上一个请求
    [self.currentRequest disconnect];
    // 结束尾部刷新
    [self.collectionView footerEndRefreshing];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    // 城市
    params[@"city"] = self.currentCity.name;
    // 区域
    if (self.currentRegionName) params[@"region"] = self.currentRegionName;
    // 类别
    if (self.currentCategoryName) params[@"category"] = self.currentCategoryName;
    // 排序
    if (self.currentSort) params[@"sort"] = @(self.currentSort.value);
    
    // 网络请求的方法，使用 self.currentRequest 记录
    self.currentRequest = [[DPAPI sharedInstance] request:@"v1/deal/find_deals" params:params success:^(id json) {
        // 使用MJ框架解析json数据
        JKFindDealsResult *result = [JKFindDealsResult objectWithKeyValues:json];
        self.result = result;
        
        // 移除旧数据
        [self.deals removeAllObjects];
        // 添加新数据
        [self.deals addObjectsFromArray:result.deals];
        // 刷新表格
        [self.collectionView reloadData];
        // 结束头部刷新
        [self.collectionView headerEndRefreshing];
        // 修改页面
        self.currentPage = 1;
        
    } failure:^(NSError *error) {
        JKLog(@"failure - %@",error);
        [MBProgressHUD showError:@"网络繁忙，请稍后再试"];
        
        // 结束头部刷新
        [self.collectionView headerEndRefreshing];
    }];
}
/**
 *  加载更多团购
 */
- (void)loadMoreDeals {
    if (self.currentCity == nil) return;
    
    // 取消上一个请求
    [self.currentRequest disconnect];
    [self.collectionView headerEndRefreshing];
    
    int tempPage = self.currentPage;
    tempPage++;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    // 城市
    params[@"city"] = self.currentCity.name;
    // 区域
    if (self.currentRegionName) params[@"region"] = self.currentRegionName;
    // 类别
    if (self.currentCategoryName) params[@"category"] = self.currentCategoryName;
    // 排序
    if (self.currentSort) params[@"sort"] = @(self.currentSort.value);
    // 页码
    params[@"page"] = @(tempPage);
    
    // 发送请求给服务器
    self.currentRequest = [[DPAPI sharedInstance] request:@"v1/deal/find_deals" params:params success:^(id json) {
        // 记录当前搜索到的团购结果 （需要定义一个属性） 注意：需要在加载新团购的请求中记录
        self.result = [JKFindDealsResult objectWithKeyValues:json];
        
        // 添加新数据
        [self.deals addObjectsFromArray:self.result.deals];
        // 刷新表格
        [self.collectionView reloadData];
        // 结束刷新
        [self.collectionView footerEndRefreshing];
        // 修改页面
        self.currentPage = tempPage;
        
    } failure:^(NSError *error) {
        // 失败信息
        [MBProgressHUD showError:@"网络繁忙，请稍后再试"];
        // 刷新刷新
        [self.collectionView footerEndRefreshing];
    }];
}

#pragma mark - 监听屏幕旋转
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    CGFloat screenW = size.width;
    // 如果是横屏 --> 3列  如果是竖屏 --> 2列
    int cols = (screenW == JKScreenMaxWH) ? 3 : 2;
    CGFloat allCellW = cols * layout.itemSize.width;
    // 如果是横屏，间距就一样，如果是竖屏，y 值不同
    CGFloat xMargin = (screenW - allCellW) / (cols + 1);
    CGFloat yMargin = (cols == 3) ? xMargin : 30;
    
    layout.sectionInset = UIEdgeInsetsMake(yMargin, xMargin, yMargin, xMargin);
    layout.minimumInteritemSpacing = xMargin;
    layout.minimumLineSpacing = yMargin;
}


#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSUInteger count = self.deals.count;
    // 数组中有数据时就隐藏
    self.noDataView.hidden = (count > 0);
    // 服务器总量搜索数据与团购数组中一样时就隐藏
    self.collectionView.footerHidden = (count == self.result.total_count);
    
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JKDealCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.deal = self.deals[indexPath.item];
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    /**
     *  点击某一个cell，弹出详情控制器
     */
    JKDetailViewController *detailVC = [[JKDetailViewController alloc] init];
    detailVC.deal = self.deals[indexPath.item];
    [self presentViewController:detailVC animated:YES completion:nil];
    
    
}

@end




