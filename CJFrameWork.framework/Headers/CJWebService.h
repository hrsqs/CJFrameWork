//
//  CJWebService.h
//
//
//  Created by basic－cj on 16/9/21.
//  Copyright © 2016年 fxyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CJParseOnlineData.h"



typedef void (^SuccessBlock)(NSString *data, int tag);
typedef void (^TotalSuccessBlock)(int tag);
typedef void (^ProgressBlock)(double written, double total);
typedef void (^FailureBlock)(NSError *error, NSString* describe); // error.code 判断具体的错误原因，正数为WebData.h下的CJWebServiceError枚举，负数为NSURLError中的枚举
typedef void (^SingleFailureBlock)(NSError *error, NSString* describe, int tag);


@interface CJWebService : NSObject

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
+ (void)getOnlineDataWithMethod:(NSString*)method Params:(NSDictionary*)params Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock;
+ (void)getOnlineDataWithURL:(NSString*)url Method:(NSString*)method Params:(NSDictionary*)params Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock;
+ (void)getOnlineDataWithMethod:(NSString*)method Params:(NSDictionary*)params Tag:(int)tag Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock;
+ (void)getOnlineDataWithURL:(NSString*)url Method:(NSString*)method Params:(NSDictionary*)params Tag:(int)tag Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock;

//----------------------------------------------------------------------------------------


//---------------------------------上传任务------------------------------------------------
+ (void)uploadDataWithMethod:(NSString*)method Params:(NSDictionary*)params Tag:(int)tag Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock;
+ (void)uploadDataWithURL:(NSString*)url Method:(NSString*)method Params:(NSDictionary*)params Tag:(int)tag Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock;
//----------------------------------------------------------------------------------------


//---------------------------------下载任务------------------------------------------------
+ (void)downloadDataWithURL:(NSString*)url SaveFilePath:(NSString*)filepath Tag:(int)tag Progress:(ProgressBlock)progress Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock;
//----------------------------------------------------------------------------------------


//-------------------------------队列任务------------------------------------------------
/**
 * 通过队列访问服务器端口数据(可多个队列任务同时进行)
 * paramsArray: 访问请求接口数据数组  每个元素为NSDictionary类型 其中的Key值遵守WebData中CJWebServiceQueueKey枚举
 * tag: 队列网络请求任务标记
 * successblock: 返回每组请求成功数据时的Block
 * failblock: 返回每组请求失败时的Block
 */
+ (void)queueWithParamsArray:(NSArray*)paramsArray Tag:(int)tag Success:(SuccessBlock)successblock Fail:(SingleFailureBlock)failblock TotalSuccess:(TotalSuccessBlock)totalsuccessblock;
//----------------------------------------------------------------------------------------


//---------------------------------组任务------------------------------------------------
+ (void)groupWithParamsArray:(NSArray*)paramsArray Tag:(int)tag Success:(SuccessBlock)successblock Fail:(SingleFailureBlock)failblock TotalSuccess:(TotalSuccessBlock)totalsuccessblock;
//----------------------------------------------------------------------------------------


// 以下功能暂不支持队列任务、组任务
+ (void)pauseTaskWithTag:(int)tag Type:(CJWebServiceType)type;
+ (void)resumeTaskWithTag:(int)tag Type:(CJWebServiceType)type;
+ (void)cancelTaskWithTag:(int)tag Type:(CJWebServiceType)type;

@end
