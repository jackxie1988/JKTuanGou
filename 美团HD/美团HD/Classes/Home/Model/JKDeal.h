//
//  JKDeal.h
//  美团HD
//
//  Created by 谢聪捷 on 3/19/15.
//  Copyright (c) 2015 Jack-Xie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKDeal : NSObject
// 团购单 id
@property (nonatomic,copy) NSString *deal_id;
// 团购标题
@property (nonatomic,copy) NSString *title;
// 团购描述
@property (nonatomic,copy) NSString *desc;
// 如果想完整保留服务器的返回数值，就不要用基本数据类型，建议使用NSString 或者 NSNumber
// 团购包含商品原价值
@property (nonatomic,copy) NSString *list_price;
// 团购价格
@property (nonatomic,copy) NSString *current_price;
// 团购当前已购买数
@property (nonatomic,assign) int purchase_count;
// 团购图片链接，最大图片尺寸450×280
@property (nonatomic,copy) NSString *image_url;
// 小尺寸团购图片链接，最大图片尺寸160×100
@property (nonatomic,copy) NSString *s_image_url;
// 团购发布上线日期
@property (nonatomic,copy) NSString *publish_date;
// 团购单的截止购买日期
@property (nonatomic,copy) NSString *purchase_deadline;


@end


















