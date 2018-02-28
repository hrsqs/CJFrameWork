//
//  CJHTTPRequest.h
//  CJFrameWork
//
//  Created by basic－cj on 2017/6/29.
//  Copyright © 2017年 basic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CJHTTPFormModel.h"

typedef void (^SuccessBlock)(NSString *data, int tag);
typedef void (^FailureBlock)(NSError *error, NSString* describe);
typedef void (^TotalSuccessBlock)(int tag);
typedef void (^ProgressBlock)(double written, double total);
typedef void (^SingleFailureBlock)(NSError *error, NSString* describe, int tag);
typedef void (^FormParamsBlock)(CJHTTPFormModel *formModel);

@interface CJHTTPRequest : NSObject

//---------------------------------数据任务------------------------------------------------
/**
 * 访问指定的服务端接口数据
 * url: 服务端URL地址
 * method: 需要访问的接口名
 * params: 需要传入的接口参数
 * tag: 网络请求任务标记(*负数无效*)
 * successblock: 返回成功数据时的Block
 * failblock: 返回失败时的Block
 */
// 默认请求头的POST请求
+(void)GetMethod:(NSString*)method Params:(NSDictionary*)params Tag:(int)tag Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock;
+(void)PostMethod:(NSString*)method Params:(NSDictionary*)params Tag:(int)tag Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock;
+(void)GetURL:(NSString*)url Method:(NSString*)method Params:(NSDictionary*)params Tag:(int)tag Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock;
+(void)PostURL:(NSString*)url Method:(NSString*)method Params:(NSDictionary*)params Tag:(int)tag Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock;

// Json请求头的POST请求
+(void)PostJsonMethod:(NSString*)method Params:(NSDictionary*)params Tag:(int)tag Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock;
+(void)PostJsonURL:(NSString*)url Method:(NSString*)method Params:(NSDictionary*)params Tag:(int)tag Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock;

// 自定义请求头的POST请求
+(void)PostMethod:(NSString*)method Header:(NSDictionary*)header Params:(NSDictionary*)params Tag:(int)tag Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock;
+(void)PostURL:(NSString*)url Method:(NSString*)method Header:(NSDictionary*)header Params:(NSDictionary*)params Tag:(int)tag Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock;

// 表单形式的POST请求
+(void)FormMethod:(NSString*)method Tag:(int)tag FormParams:(FormParamsBlock)formblock Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock;
+(void)FormURL:(NSString*)url Method:(NSString*)method Tag:(int)tag FormParams:(FormParamsBlock)formblock Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock;
//----------------------------------------------------------------------------------------


//---------------------------------上传任务------------------------------------------------
// 上传任务直接当做数据任务调用即可
//----------------------------------------------------------------------------------------


//---------------------------------下载任务------------------------------------------------
+ (void)downloadDataWithURL:(NSString*)url SaveFilePath:(NSString*)filepath Tag:(int)tag Progress:(ProgressBlock)progress Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock;
//----------------------------------------------------------------------------------------


//-------------------------------队列任务------------------------------------------------
/**
 * 通过队列访问服务器端口数据(可多个队列任务同时进行)
 * 注：暂不支持表单请求
 * paramsArray: 访问请求接口数据数组  每个元素为NSDictionary类型 其中的Key值遵守WebData中CJHTTPQueueKey枚举
 * successblock: 返回每组请求成功数据时的Block
 * failblock: 返回每组请求失败时的Block
 */
+ (void)queueWithParamsArray:(NSArray*)paramsArray Success:(SuccessBlock)successblock Fail:(SingleFailureBlock)failblock TotalSuccess:(TotalSuccessBlock)totalsuccessblock;
//----------------------------------------------------------------------------------------


//-------------------------------组任务------------------------------------------------
// 注：暂不支持表单请求
+ (void)groupWithParamsArray:(NSArray*)paramsArray Success:(SuccessBlock)successblock Fail:(SingleFailureBlock)failblock TotalSuccess:(TotalSuccessBlock)totalsuccessblock;
//----------------------------------------------------------------------------------------
@end
