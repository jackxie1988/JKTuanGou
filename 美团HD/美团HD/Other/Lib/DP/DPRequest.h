//
//  DPRequest.h
//  apidemo
//
//  Created by ZhouHui on 13-1-28.
//  Copyright (c) 2013年 Dianping. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef void (^DPBlock)(id result, NSError *error);

typedef void (^DPSuccess)(id json);
typedef void (^DPFailure)(NSError *error);

@class DPAPI;
@protocol DPRequestDelegate;

@interface DPRequest : NSObject
/** 请求后的回调 */
//@property (nonatomic, copy) DPBlock block;

/** 请求成功后的回调 */
@property (nonatomic, copy) DPSuccess success;
/** 请求失败后的回调 */
@property (nonatomic, copy) DPFailure failure;

//@property (nonatomic, copy) void (^success)(id json);
//@property (nonatomic, copy) void (^failure)(NSError *error);

@property (nonatomic, weak) DPAPI *dpapi;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, unsafe_unretained) id<DPRequestDelegate> delegate;

+ (DPRequest *)requestWithURL:(NSString *)url
					   params:(NSDictionary *)params
					 delegate:(id<DPRequestDelegate>)delegate;

+ (NSString *)getParamValueFromUrl:(NSString*)url paramName:(NSString *)paramName;

+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params;

- (void)connect;

- (void)disconnect;

@end


@protocol DPRequestDelegate <NSObject>
@optional
- (void)request:(DPRequest *)request didReceiveResponse:(NSURLResponse *)response;
- (void)request:(DPRequest *)request didReceiveRawData:(NSData *)data;
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error;
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result;
@end
