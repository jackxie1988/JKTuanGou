//
//  DPAPI.m
//  apidemo
//
//  Created by ZhouHui on 13-1-28.
//  Copyright (c) 2013年 Dianping. All rights reserved.
//

#import "DPAPI.h"
#import "DPConstants.h"

@interface DPAPI ()<DPRequestDelegate>
{
    NSMutableSet *_requests;
}

@end

@implementation DPAPI

- (DPRequest *)request:(NSString *)url params:(NSDictionary *)params success:(DPSuccess)success failure:(DPFailure)failure {
    
    // 将不可变的字典类型参数转换成可变字典类型参数
    NSMutableDictionary *paramsM = [NSMutableDictionary dictionaryWithDictionary:params];
    
    // 调用请求方法
    DPRequest *request = [self requestWithURL:url params:paramsM delegate:self];
    
    // 记录 block
    request.success = success;
    request.failure = failure;
    
    // 返回请求
    return request;
    
}

#pragma mark - <DPRequestDelegate>
// 请求成功后的回调
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result {
    if (request.success) {
        request.success(result);
    }
}
// 请求失败后的回调
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error {
    if (request.failure) {
        request.failure(error);
    }
}

#pragma mark - 单例

JKSingleton_M



#pragma mark - 原来的代码
- (id)init {
	self = [super init];
    if (self) {
        _requests = [[NSMutableSet alloc] init];
    }
    return self;
}

- (DPRequest*)requestWithURL:(NSString *)url
					  params:(NSMutableDictionary *)params
					delegate:(id<DPRequestDelegate>)delegate {
	if (params == nil) {
        params = [NSMutableDictionary dictionary];
    }
    
	NSString *fullURL = [kDPAPIDomain stringByAppendingString:url];
	
	DPRequest *_request = [DPRequest requestWithURL:fullURL
											 params:params
										   delegate:delegate];
	_request.dpapi = self;
	[_requests addObject:_request];
	[_request connect];
	return _request;
}

- (DPRequest *)requestWithURL:(NSString *)url
				 paramsString:(NSString *)paramsString
					 delegate:(id<DPRequestDelegate>)delegate {
	return [self requestWithURL:[NSString stringWithFormat:@"%@?%@", url, paramsString] params:nil delegate:delegate];
}

- (void)requestDidFinish:(DPRequest *)request
{
    [_requests removeObject:request];
    request.dpapi = nil;
}

- (void)dealloc
{
    for (DPRequest* _request in _requests)
    {
        _request.dpapi = nil;
    }
}

@end
