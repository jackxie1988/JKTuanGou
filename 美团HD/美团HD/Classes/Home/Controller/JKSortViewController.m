//
//  JKSortViewController.m
//  美团HD
//
//  Created by 谢聪捷 on 3/11/15.
//  Copyright (c) 2015 Jack-Xie. All rights reserved.
//

#import "JKSortViewController.h"
#import "JKSort.h"

@interface JKSortViewController ()

// 定义一个数据属性，存储排序数据
@property (nonatomic,strong) NSArray *sorts;

@end

@implementation JKSortViewController

// 排序数据懒加载方法
- (NSArray *)sorts {
    if (_sorts == nil) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"sorts.plist" ofType:nil];
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:path];
        
        NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:dictArray.count];
        for (NSDictionary *dict in dictArray) {
            JKSort *sort = [JKSort sortWithDict:dict];
            [arrayM addObject:sort];
        }
        _sorts = [arrayM copy];
    }
    return _sorts;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = JKRandomColor;
//    JKLog(@"%@",self.sorts);
    
    NSUInteger count = self.sorts.count;
    CGFloat margin = 10;
    UIButton *lastButton = nil;
    for (int i=0; i<count; i++) {
        UIButton *button = [[UIButton alloc] init];
        button.tag = i;
        [self.view addSubview:button];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        JKSort *sort = self.sorts[i];
        [button setTitle:sort.label forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        [button setBackgroundImage:[UIImage imageNamed:@"btn_filter_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"btn_filter_selected"] forState:UIControlStateHighlighted];
        lastButton = button;
        
        // 设置按钮的 frame
        button.width = 100;
        button.height = 30;
        button.x = 15;
        button.y = margin + i * (button.height + margin);
    }
    
    // 设置popover的尺寸
    CGFloat w = CGRectGetMaxX(lastButton.frame) + lastButton.x;
    CGFloat h = CGRectGetMaxY(lastButton.frame) + margin;
    self.preferredContentSize = CGSizeMake(w, h);
    
}

- (void)buttonClick:(UIButton *)button {
    JKLog(@"buttonClick");
}


@end
