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

@interface JKHomeViewController ()

@property (nonatomic,strong) UIBarButtonItem *sortItem;
@property (nonatomic,strong) UIBarButtonItem *districtItem;
@property (nonatomic,strong) UIBarButtonItem *categoryItem;


@end

@implementation JKHomeViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = JKColor(230, 230, 230);
    self.collectionView.backgroundColor = JKColor(230, 230, 230);
    
    
    // 设置导航栏左边
    [self setUpNavLeft];
    
    // 设置导航栏右边
    [self setUpNavRight];
    
    [self setUpNotes];
}

#pragma mark - 通知处理
- (void)setUpNotes {
    [JKNoteCenter addObserver:self selector:@selector(sortDidChange:) name:JKSortDidChangeNotification object:nil];
}
- (void)dealloc {
    [JKNoteCenter removeObserver:self];
}
- (void)sortDidChange:(NSNotification *)note {
    JKHomeTopItem *topItem = (JKHomeTopItem *)self.sortItem.customView;
    JKSort *sort = note.userInfo[JKCurrentSortKey];
    topItem.subtitle = sort.label;
    
#warning TODO 重新发送请求给服务器...
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
    
    [self presentViewController:districtVC animated:YES completion:nil];
}
- (void)sortClicked {
//    JKLog(@"sortClicked");
    
    JKSortViewController *sortVC = [[JKSortViewController alloc] init];
    sortVC.modalPresentationStyle = UIModalPresentationPopover;
    sortVC.popoverPresentationController.barButtonItem = self.sortItem;
    
    [self presentViewController:sortVC animated:YES completion:nil];
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

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete method implementation -- Return the number of sections
    return 0;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete method implementation -- Return the number of items in the section
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
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
