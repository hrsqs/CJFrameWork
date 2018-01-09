//
//  WebServiceV2.m
//
//
//  Created by basic－cj on 16/9/21.
//  Copyright © 2016年 fxyy. All rights reserved.
//

#import "CJWebService.h"

#define CallMainThread(x) dispatch_async(dispatch_get_main_queue(), ^(){x})
#define CallMainThreadAndReset(x) dispatch_async(dispatch_get_main_queue(), ^(){x _successBlock = NULL;_progressBlock = NULL;_failBlock = NULL;_filePath = NULL;})

@interface CJWebService () <NSURLSessionDownloadDelegate>
{
    
}
@end

@implementation CJWebService

static NSMutableDictionary* taskDic;

// 下载才会用到的属性
static SuccessBlock _successBlock;
static ProgressBlock _progressBlock;
static FailureBlock _failBlock;
static NSMutableDictionary* _tagDic;
static NSString* _filePath;

// 队列才会用到的属性
//static dispatch_queue_t queue;

#pragma mark - 数据任务
+ (void)getOnlineDataWithMethod:(NSString*)method Params:(NSDictionary*)params Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock
{
    [CJWebService getOnlineDataWithURL:[CJWebData getDefaultURL] Method:method Params:params Success:successblock Fail:failblock];
}

+ (void)getOnlineDataWithURL:(NSString*)url Method:(NSString*)method Params:(NSDictionary*)params Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock
{
    [CJWebService getOnlineDataWithURL:url Method:method Params:params Tag:-1 Success:successblock Fail:failblock];
}

+ (void)getOnlineDataWithMethod:(NSString*)method Params:(NSDictionary*)params Tag:(int)tag Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock
{
    [CJWebService getOnlineDataWithURL:[CJWebData getDefaultURL] Method:method Params:params Tag:tag Success:successblock Fail:failblock];
}

+ (void)getOnlineDataWithURL:(NSString*)url Method:(NSString*)method Params:(NSDictionary*)params Tag:(int)tag Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock
{
    [CJWebService interactiveWebServiceWithURL:url Method:method Params:params Timeout:DATA_TIMEOUT_VALUE Tag:tag Success:successblock Fail:failblock];
}

#pragma mark - 上传任务
+ (void)uploadDataWithMethod:(NSString*)method Params:(NSDictionary*)params Tag:(int)tag Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock
{
    [CJWebService uploadDataWithURL:[CJWebData getDefaultURL] Method:method Params:params Tag:tag Success:successblock Fail:failblock];
}

+ (void)uploadDataWithURL:(NSString*)url Method:(NSString*)method Params:(NSDictionary*)params Tag:(int)tag Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock
{
    [CJWebService interactiveWebServiceWithURL:url Method:method Params:params Timeout:UPLOAD_TIMEOUT_VALUE Tag:tag Success:successblock Fail:failblock];
}

#pragma mark - 执行WebService任务
+ (void)interactiveWebServiceWithURL:(NSString*)url Method:(NSString*)method Params:(NSDictionary*)params Timeout:(NSTimeInterval)timeout Tag:(int)tag Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock
{
    if (!url) {
        CallMainThread(failblock(NEWERROR(CJWebServiceError_URLIsNULL), nil););
        return;
    }
    
    NSURL *nsurl = [NSURL URLWithString:[NSString stringWithFormat:@"%@", url]];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:nsurl];
    //如果想要设置网络超时的时间的话，可以使用下面的方法：
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:nsurl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeout];
//    NSLog(@"timeout = %f", request.timeoutInterval);
    //设置请求类型
//    NSLog(@"body = %@", request.HTTPBody);
//    if (params != nil) {
    NSString* paramsStr = [CJWebService parseParams:params];
//    }

    NSString* postStr = [[NSString alloc]initWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><%@ xmlns=\"http://tempuri.org/\">%@</%@></soap:Body></soap:Envelope>", method, paramsStr, method];
    
    //把参数放到请求体内
    request.HTTPBody = [postStr dataUsingEncoding:NSUTF8StringEncoding];
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%lu", (unsigned long)[postStr length]] forHTTPHeaderField:@"Content-Length"];
    [request addValue: [NSString stringWithFormat:@"http://tempuri.org/%@", method] forHTTPHeaderField:@"SOAPAction"];
    request.HTTPMethod = @"POST";
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) { //请求失败
            //            NSLog(@"请求失败V2");
            
            if (error.code == NSURLErrorCancelled) // 过滤掉因为取消而返回的错误
                return;
            
            CallMainThread(failblock(error, error.description););
            
        } else {  //请求成功
            //            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            //            successblock(dic);
            
//            NSLog(@"请求结果 = %@", [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
            [[CJParseOnlineData alloc] parseWithData:data ResultBlock:^(NSError* error, NSString *result) {
                if (error.code == 0) {
                    CallMainThread(successblock(result, tag););
                }else {
                    CallMainThread(failblock(error, [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]););
                }
            }];
        }
        //        NSLog(@"tag = %d", tag);
        if (tag >= 0) {
            NSString* key = [NSString stringWithFormat:@"%d", tag];
            if ([[taskDic allKeys] containsObject:key]) {
                [taskDic removeObjectForKey:key];
            }
        }
    }];
    
    if (tag >= 0) {
        if (!taskDic) {
            taskDic = [[NSMutableDictionary alloc] init];
        }
        [taskDic setObject:dataTask forKey:[NSString stringWithFormat:@"%d", tag]];
    }
    
    
    [dataTask resume];  //开始请求
    //    NSLog(@"开始请求 - %@", method);
}

#pragma mark - 下载任务
+ (void)downloadDataWithURL:(NSString*)url SaveFilePath:(NSString*)filepath Tag:(int)tag Progress:(ProgressBlock)progress Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock
{
    _successBlock = successblock;
    _progressBlock = progress;
    _failBlock = failblock;
    _filePath = filepath;
    
    // 获得NSURLSession对象
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    
    // 获得下载任务
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:[NSURL URLWithString:url]];
    
    // 启动任务
    [task resume];
    
    // 向字典添加对应的tag
    if (_tagDic == NULL) {
        _tagDic = [[NSMutableDictionary alloc]init];
    }
    [_tagDic setObject:task forKey:[NSString stringWithFormat:@"%d", tag]];
}

#pragma mark - 队列任务
+ (void)queueWithParamsArray:(NSArray*)paramsArray Tag:(int)tagQueue Success:(SuccessBlock)successblock Fail:(SingleFailureBlock)failblock TotalSuccess:(TotalSuccessBlock)totalsuccessblock
{
    //创建一个全局队列
//    if (queue) {
//        dispatch_suspend(queue);
//        queue = nil;
//    }
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    //创建一个信号量（值为0）
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_async(queue, ^{
        for (int index = 0; index < paramsArray.count; index++) {
//            NSLog(@"start webservice %d", index);
            NSDictionary* paramsDic = (NSDictionary*)[paramsArray objectAtIndex:index];
            __block NSString* method = (NSString*)[paramsDic valueForKey:[CJWebData getQueueKeyString:CJWebServiceQueueKey_Method]];
            __block NSDictionary* params = (NSDictionary*)[paramsDic valueForKey:[CJWebData getQueueKeyString:CJWebServiceQueueKey_Params]];
            __block int timeout = [(NSString*)[paramsDic objectForKey:[CJWebData getQueueKeyString:CJWebServiceQueueKey_TimeOut]] intValue];
            __block int tag = [(NSString*)[paramsDic objectForKey:[CJWebData getQueueKeyString:CJWebServiceQueueKey_Tag]] intValue];
            
            [self interactiveWebServiceWithURL:[CJWebData getDefaultURL] Method:method Params:params Timeout:timeout Tag:tag Success:^(NSString *data, int tag) {
                
                CallMainThread(successblock(data, tag););
                
                //信号量加1
                dispatch_semaphore_signal(semaphore);
            } Fail:^(NSError *error, NSString *describe) {
                CallMainThread(failblock(error, error.description, tag););
                return;
            }];
            
            //信号量减1，如果>0，则向下执行，否则等待
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//            NSLog(@"end webservice %d", index);
        }
        CallMainThread(totalsuccessblock(tagQueue););
    });
    
}

#pragma mark - 组任务
+ (void)groupWithParamsArray:(NSArray*)paramsArray Tag:(int)tagGroup Success:(SuccessBlock)successblock Fail:(SingleFailureBlock)failblock TotalSuccess:(TotalSuccessBlock)totalsuccessblock
{
    dispatch_queue_t conCurrentGlobalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_group_t groupQueue = dispatch_group_create();
    
    __block int successCount = 0;
    __block int failCount = 0;
    
    for (int index = 0; index < paramsArray.count; index++) {
        NSDictionary* paramsDic = (NSDictionary*)[paramsArray objectAtIndex:index];
        __block NSString* method = (NSString*)[paramsDic valueForKey:[CJWebData getQueueKeyString:CJWebServiceQueueKey_Method]];
        __block NSDictionary* params = (NSDictionary*)[paramsDic valueForKey:[CJWebData getQueueKeyString:CJWebServiceQueueKey_Params]];
        __block int timeout = [(NSString*)[paramsDic objectForKey:[CJWebData getQueueKeyString:CJWebServiceQueueKey_TimeOut]] intValue];
        __block int tag = [(NSString*)[paramsDic objectForKey:[CJWebData getQueueKeyString:CJWebServiceQueueKey_Tag]] intValue];
        
        dispatch_group_async(groupQueue, conCurrentGlobalQueue, ^{
            [self interactiveWebServiceWithURL:[CJWebData getDefaultURL] Method:method Params:params Timeout:timeout Tag:tag Success:^(NSString *data, int tag) {
                successCount++;
                CallMainThread(successblock(data, tag););
            } Fail:^(NSError *error, NSString *describe) {
                failCount++;
                CallMainThread(failblock(error, error.description, tag););
            }];
        });
    }
    dispatch_group_async(groupQueue, conCurrentGlobalQueue, ^{
        while (1 && paramsArray.count > 0) {
            if (successCount + failCount == paramsArray.count) {
                if (successCount == paramsArray.count) {
                    CallMainThread(totalsuccessblock(tagGroup););
                }
                break;
            }
            [NSThread sleepForTimeInterval:0.1];
        }
    });
}

#pragma mark - 通过Tag值处理对应的任务
+ (void)pauseTaskWithTag:(int)tag Type:(CJWebServiceType)type
{
    NSDictionary* targetDic;
    if (type == CJWebServiceType_Data || type == CJWebServiceType_Upload) {
        targetDic = taskDic;
    }else if (type == CJWebServiceType_Download) {
        targetDic = _tagDic;
    }/*else if (type == CJWebServiceType_Queue) {
        dispatch_suspend(queue);
//        return;
    }*/
    if (!targetDic) return;
    NSString* key = [NSString stringWithFormat:@"%d", tag];
    if ([[targetDic allKeys] containsObject:key]) {
        NSURLSessionTask* task = (NSURLSessionTask*)[targetDic objectForKey:key];
        [task suspend];
    }
}

+ (void)resumeTaskWithTag:(int)tag Type:(CJWebServiceType)type
{
    NSDictionary* targetDic;
    if (type == CJWebServiceType_Data || type == CJWebServiceType_Upload) {
        targetDic = taskDic;
    }else if (type == CJWebServiceType_Download) {
        targetDic = _tagDic;
    }/*else if (type == CJWebServiceType_Queue) {
        dispatch_resume(queue);
//        return;
    }*/
    if (!targetDic) return;
    NSString* key = [NSString stringWithFormat:@"%d", tag];
    if ([[targetDic allKeys] containsObject:key]) {
        NSURLSessionTask* task = (NSURLSessionTask*)[targetDic objectForKey:key];
        [task resume];
    }
}

+ (void)cancelTaskWithTag:(int)tag Type:(CJWebServiceType)type
{
    NSMutableDictionary* targetDic;
    if (type == CJWebServiceType_Data || type == CJWebServiceType_Upload) {
        targetDic = taskDic;
    }else if (type == CJWebServiceType_Download) {
        targetDic = _tagDic;
    }/*else if (type == CJWebServiceType_Queue) {
        dispatch_suspend(queue);
        queue = nil;
//        return;
    }*/
    if (!targetDic) return;
    NSString* key = [NSString stringWithFormat:@"%d", tag];
    if ([[targetDic allKeys] containsObject:key]) {
        NSURLSessionTask* task = (NSURLSessionTask*)[targetDic objectForKey:key];
        [task cancel];
        
        [targetDic removeObjectForKey:key];
    }
}

#pragma mark - NSURLSessionDownloadDelegate代理
+ (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    //    NSLog(@"--------%g", 1.0 * totalBytesWritten / totalBytesExpectedToWrite);
    if (_progressBlock) {
        //        CallMainThread(_progressBlock(totalBytesWritten, totalBytesExpectedToWrite););
        dispatch_async(dispatch_get_main_queue(), ^(){
            _progressBlock(totalBytesWritten, totalBytesExpectedToWrite);
        });
    }
}

+ (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    //    NSLog(@"download complete = %@", downloadTask.response.suggestedFilename);
    //    NSLog(@"location = %@", location);
    //    NSLog(@"_filePath = %@", _filePath);
    
    // 清掉字典里指定的tag
    NSArray* keyArr = [_tagDic allKeys];
    int tag = -1;
    for (int index = 0; index < keyArr.count; index++) {
        NSString* keyStr = (NSString*)[keyArr objectAtIndex:index];
        if ([_tagDic objectForKey:keyStr] == downloadTask) {
            tag = [keyStr intValue];
            [_tagDic removeObjectForKey:keyStr];
            break;
        }
    }
    
    if (location == NULL) {
        if (_failBlock) {
            CallMainThread/*AndReset*/(_failBlock(NEWERROR(CJWebServiceError_DownFileIsNULL), @"下载的文件为空"););
        }
    }else if (_filePath == NULL) {
        if (_failBlock) {
            CallMainThread/*AndReset*/(_failBlock(NEWERROR(CJWebServiceError_SavePathIsNULL), @"下载后所需要保存的文件路径为空"););
        }
    }else {
        // 先删除预保存的路径
        if ([[NSFileManager defaultManager] fileExistsAtPath:_filePath]) {
            [[NSFileManager defaultManager] removeItemAtURL:[NSURL fileURLWithPath:_filePath] error:nil];
        }
        // 复制文件
        NSError* error;
        [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:_filePath] error:&error];
        if (error) {
            CallMainThread/*AndReset*/(_failBlock(NEWERROR(CJWebServiceError_SaveDownloadData), @"保存下载文件失败"););
        }else {
            // 成功block回调
            if (_successBlock) {
                CallMainThread/*AndReset*/(_successBlock(nil, tag););
            }
        }
        
        
    }
    
    if (_tagDic.count > 0) {
        _successBlock = NULL;
        _progressBlock = NULL;
        _failBlock = NULL;
        _filePath = NULL;
    }
}

#pragma mark - 数据处理
//把NSDictionary解析成post格式的NSString字符串
+ (NSString *)parseParams:(NSDictionary *)params
{
//    NSString *keyValueFormat;
//    NSMutableString *result = [NSMutableString new];
//    NSMutableArray *array = [NSMutableArray new];
//    //实例化一个key枚举器用来存放dictionary的key
//    NSEnumerator *keyEnum = [params keyEnumerator];
//    id key;
//    while (key = [keyEnum nextObject]) {
//        keyValueFormat = [NSString stringWithFormat:@"%@=%@&", key, [params valueForKey:key]];
//        [result appendString:keyValueFormat];
//        [array addObject:keyValueFormat];
//    }
//    return result;
    NSMutableString* result = [[NSMutableString alloc]init];
    if (params != nil) {
        NSArray* keyArr = [params allKeys];
        
        for (int i = 0; i < keyArr.count; i++) {
            NSString* key = keyArr[i];
            NSString* value = [params valueForKey:key];
            [result appendFormat:@"<%@>%@</%@>", key, value, key];
        }
    }
    
    
    return result;
}

@end
