//
//  DPAPI.h
//  apidemo
//
//  Created by ZhouHui on 13-1-28.
//  Copyright (c) 2013年 Dianping. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPRequest.h"
#import "JKSingleton.h"


@interface DPAPI : NSObject

- (DPRequest*)requestWithURL:(NSString *)url
					  params:(NSMutableDictionary *)params
					delegate:(id<DPRequestDelegate>)delegate;

- (DPRequest *)requestWithURL:(NSString *)url
				 paramsString:(NSString *)paramsString
					 delegate:(id<DPRequestDelegate>)delegate;

// 添加一个接口方法 block 当作参数传递的时候，可以不用写参数名称
- (DPRequest *)request:(NSString *)url params:(NSDictionary *)params success:(DPSuccess)success failure:(DPFailure)failure;


JKSingleton_H

@end
