//
//  JKHomeTopItem.m
//  美团HD
//
//  Created by 谢聪捷 on 3/10/15.
//  Copyright (c) 2015 Jack-Xie. All rights reserved.
//

#import "JKHomeTopItem.h"

@interface JKHomeTopItem  ()
///  标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
///  子标题
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
///  图标按钮
@property (weak, nonatomic) IBOutlet UIButton *iconButton;


@end

@implementation JKHomeTopItem

+ (instancetype)item {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"JKHomeTopItem" owner:nil options:nil] firstObject];
}

// 将 xib 的自动拉伸去掉！！！  
- (void)awakeFromNib {
    self.autoresizingMask = UIViewAutoresizingNone;
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)setSubtitle:(NSString *)subtitle {
    self.subtitleLabel.text = subtitle;
}

- (void)setIcon:(NSString *)icon highIcon:(NSString *)highIcon {
    [self.iconButton setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [self.iconButton setImage:[UIImage imageNamed:highIcon] forState:UIControlStateHighlighted];
}

- (void)addTarget:(id)target action:(SEL)action {
    [self.iconButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
