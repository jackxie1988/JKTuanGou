//
//  JKDropDownLeftCell.m
//  美团HD
//
//  Created by 谢聪捷 on 3/13/15.
//  Copyright (c) 2015 Jack-Xie. All rights reserved.
//

#import "JKDropDownLeftCell.h"

@implementation JKDropDownLeftCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *leftID = @"left";
    JKDropDownLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:leftID];
        if (cell == nil) {
            cell = [[JKDropDownLeftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:leftID];
            cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dropdown_leftpart"]];
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dropdown_left_selected"]];
        }
    return cell;
}

@end
