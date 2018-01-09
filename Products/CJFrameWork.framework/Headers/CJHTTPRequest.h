//
//  CJHTTPRequest.h
//  CJFrameWork
//
//  Created by basic－cj on 2017/6/29.
//  Copyright © 2017年 basic. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SuccessBlock)(NSString *data, int tag);
typedef void (^FailureBlock)(NSError *error, NSString* describe);
typedef void (^TotalSuccessBlock)(int tag);
typedef void (^ProgressBlock)(double written, double total);
typedef void (^SingleFailureBlock)(NSError *error, NSString* describe, int tag);

@interface CJHTTPRequest : NSObject

//---------------------------------数据任务------------------------------------------------
+(void)GetMethod:(NSString*)method Params:(NSDictionary*)params Tag:(int)tag Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock;
+(void)PostMethod:(NSString*)method Params:(NSDictionary*)params Tag:(int)tag Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock;
+(void)GetURL:(NSString*)url Method:(NSString*)method Params:(NSDictionary*)params Tag:(int)tag Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock;
+(void)PostURL:(NSString*)url Method:(NSString*)method Params:(NSDictionary*)params Tag:(int)tag Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock;
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
 * paramsArray: 访问请求接口数据数组  每个元素为NSDictionary类型 其中的Key值遵守WebData中CJHTTPQueueKey枚举
 * successblock: 返回每组请求成功数据时的Block
 * failblock: 返回每组请求失败时的Block
 */
+ (void)queueWithParamsArray:(NSArray*)paramsArray Success:(SuccessBlock)successblock Fail:(SingleFailureBlock)failblock TotalSuccess:(TotalSuccessBlock)totalsuccessblock;
//----------------------------------------------------------------------------------------


//-------------------------------组任务------------------------------------------------
+ (void)groupWithParamsArray:(NSArray*)paramsArray Success:(SuccessBlock)successblock Fail:(SingleFailureBlock)failblock TotalSuccess:(TotalSuccessBlock)totalsuccessblock;
//----------------------------------------------------------------------------------------
@end
