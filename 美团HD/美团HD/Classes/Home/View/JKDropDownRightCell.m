//
//  JKDropDownRightCell.m
//  美团HD
//
//  Created by 谢聪捷 on 3/13/15.
//  Copyright (c) 2015 Jack-Xie. All rights reserved.
//

#import "JKDropDownRightCell.h"

@implementation JKDropDownRightCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *rightID = @"right";
    JKDropDownRightCell *cell = [tableView dequeueReusableCellWithIdentifier:rightID];
    if (cell == nil) {
        cell = [[JKDropDownRightCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rightID];
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dropdown_rightpart"]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dropdown_right_selected"]];
    }
    return cell;
}

@end
