//
//  JKSortViewController.m
//  美团HD
//
//  Created by 谢聪捷 on 3/11/15.
//  Copyright (c) 2015 Jack-Xie. All rights reserved.
//

#import "JKSortViewController.h"
#import "JKSort.h"
#import "JKDataTool.h"


@interface JKSortViewController ()

@end

@implementation JKSortViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *sorts = [JKDataTool sorts];
    NSUInteger count = sorts.count;
    CGFloat margin = 10;
    UIButton *lastButton = nil;
    for (int i=0; i<count; i++) {
        UIButton *button = [[UIButton alloc] init];
        button.tag = i;
        [self.view addSubview:button];
        // 按钮点击事件监听
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        JKSort *sort = sorts[i];
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
//    JKLog(@"buttonClick");
    /// 1. 让 popover 消失
    [self dismissViewControllerAnimated:YES completion:nil];
    
    ///  2. 发出通知 [JKDataTool sorts][button.tag] 先取得 排序数组，根据 tag 取得对应的按钮
    NSDictionary *userInfo = @{JKCurrentSortKey : [JKDataTool sorts][button.tag]};
    [JKNoteCenter postNotificationName:JKSortDidChangeNotification object:nil userInfo:userInfo];
}


@end
