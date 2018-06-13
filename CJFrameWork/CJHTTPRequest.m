//
//  CJHTTPRequest.m
//  CJFrameWork
//
//  Created by basic－cj on 2017/6/29.
//  Copyright © 2017年 basic. All rights reserved.
//

#import "CJHTTPRequest.h"
#import "CJHTTPConfig.h"
#import "CJWebData.h"

#import <CommonCrypto/CommonDigest.h>

#define CallMainThread(x) dispatch_async(dispatch_get_main_queue(), ^(){x})

@interface CJHTTPRequest () <NSURLSessionDownloadDelegate>
{
    
}
@end

@implementation CJHTTPRequest

// 下载才会用到的属性
//static SuccessBlock _successBlock;
//static ProgressBlock _progressBlock;
//static FailureBlock _failBlock;
//static NSString* _filePath;
static NSMutableArray* _downloadArr;

#pragma mark - 公有静态函数
+(void)GetMethod:(NSString*)method Params:(NSDictionary*)params Tag:(int)tag Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock
{
    [CJHTTPRequest GetURL:[CJHTTPConfig getDefaultURL] Method:method Params:params Tag:tag Success:successblock Fail:failblock];
}

+(void)PostMethod:(NSString*)method Params:(NSDictionary*)params Tag:(int)tag Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock
{
    [CJHTTPRequest PostURL:[CJHTTPConfig getDefaultURL] Method:method Params:params Tag:tag Success:successblock Fail:failblock];
}

+(void)GetURL:(NSString*)url Method:(NSString*)method Params:(NSDictionary*)params Tag:(int)tag Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock
{
    [CJHTTPRequest GetURL:url Method:method Header:nil Params:params Tag:tag Success:successblock Fail:failblock];
}

+(void)PostURL:(NSString*)url Method:(NSString*)method Params:(NSDictionary*)params Tag:(int)tag Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock
{
    [CJHTTPRequest PostURL:url Method:method Header:nil Params:params Tag:tag Success:successblock Fail:failblock];
}

+(void)GetMethod:(NSString*)method ParamsString:(NSString*)paramsStr Tag:(int)tag Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock
{
    [CJHTTPRequest GetURL:[CJHTTPConfig getDefaultURL] Method:method ParamsString:paramsStr Tag:tag Success:successblock Fail:failblock];
}

+(void)GetURL:(NSString*)url Method:(NSString*)method ParamsString:(NSString*)paramsStr Tag:(int)tag Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock
{
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableString *urlMutStr = [[NSMutableString alloc]init];
    [urlMutStr appendString:url];
    if (method) {
        [urlMutStr appendString:[NSString stringWithFormat:@"/%@", method]];
    }
    if (paramsStr) {
        [urlMutStr appendString:paramsStr];
    }
    NSString *urlStr = [urlMutStr copy];
    //转码
    urlStr= [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    NSLog(@"get url = %@", urlStr);
    NSURL *httpUrl = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:httpUrl];
    request.timeoutInterval = DATA_TIMEOUT_VALUE;
    request.HTTPMethod = @"GET";
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            CallMainThread(failblock(error, error.description););
        }else {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            //            NSLog(@"get dict:%@",dict);
            CallMainThread(successblock([CJHTTPRequest toJSONString:dict], tag););
        }
        
    }];
    
    [dataTask resume];
}

+(void)GetJsonMethod:(NSString*)method Params:(NSDictionary*)params Tag:(int)tag Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock
{
    [CJHTTPRequest GetJsonURL:[CJHTTPConfig getDefaultURL] Method:method Params:params Tag:tag Success:successblock Fail:failblock];
}

+(void)GetJsonURL:(NSString*)url Method:(NSString*)method Params:(NSDictionary*)params Tag:(int)tag Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock
{
    NSDictionary* header = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                            @"application/json", @"accept",
                            @"application/json", @"Content-Type",
                            @"application/json", @"Accept-Encoding",
                            @"utf-8",@"charset",
                            @"", @"Authorization",
                            nil];
    
    [CJHTTPRequest GetURL:url Method:method Header:header Params:params Tag:tag Success:successblock Fail:failblock];
}

+(void)PostJsonMethod:(NSString*)method Params:(NSDictionary*)params Tag:(int)tag Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock
{
    [CJHTTPRequest PostJsonURL:[CJHTTPConfig getDefaultURL] Method:method Params:params Tag:tag Success:successblock Fail:failblock];
}

+(void)PostJsonURL:(NSString*)url Method:(NSString*)method Params:(NSDictionary*)params Tag:(int)tag Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock
{
    NSDictionary* header = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                            @"application/json", @"accept",
                            @"application/json", @"Content-Type",
                            @"application/json", @"Accept-Encoding",
                            @"utf-8",@"charset",
                            @"", @"Authorization",
                            nil];
    
    [CJHTTPRequest PostURL:url Method:method Header:header Params:params Tag:tag Success:successblock Fail:failblock];
}

+(void)PutJsonMethod:(NSString*)method Params:(NSDictionary*)params Tag:(int)tag Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock
{
    [CJHTTPRequest PutJsonURL:[CJHTTPConfig getDefaultURL] Method:method Params:params Tag:tag Success:successblock Fail:failblock];
}

+(void)PutJsonURL:(NSString*)url Method:(NSString*)method Params:(NSDictionary*)params Tag:(int)tag Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock
{
    NSDictionary* header = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                            @"application/json", @"accept",
                            @"application/json", @"Content-Type",
                            @"application/json", @"Accept-Encoding",
                            @"utf-8",@"charset",
                            @"", @"Authorization",
                            nil];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableString *urlMutStr = [[NSMutableString alloc]init];
    [urlMutStr appendString:url];
    if (method) {
        [urlMutStr appendString:[NSString stringWithFormat:@"/%@", method]];
    }
    NSString *urlStr = [urlMutStr copy];
    //转码
    urlStr= [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *httpUrl = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:httpUrl];
    request.timeoutInterval = DATA_TIMEOUT_VALUE;
    request.HTTPMethod = @"PUT";
    
    //设置请求头
    // Json请求头方式
    
    for (NSString* key in [header allKeys]) {
        [request setValue:[header valueForKey:key] forHTTPHeaderField:key];
    }
    
    //设置请求体
    NSString *param = [CJHTTPRequest toJSONString:params];
    //    NSLog(@"post param = %@", param);
    //把拼接后的字符串转换为data，设置请求体
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            CallMainThread(failblock(error, error.description););
        }else {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            //            NSLog(@"post dict:%@",dict);
            CallMainThread(successblock([CJHTTPRequest toJSONString:dict], tag););
        }
        
    }];
    
    [dataTask resume];
}

+(void)GetMethod:(NSString*)method Header:(NSDictionary*)header Params:(NSDictionary*)params Tag:(int)tag Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock
{
    [CJHTTPRequest GetURL:[CJHTTPConfig getDefaultURL] Method:method Header:header Params:params Tag:tag Success:successblock Fail:failblock];
}

+(void)GetURL:(NSString*)url Method:(NSString*)method Header:(NSDictionary*)header Params:(NSDictionary*)params Tag:(int)tag Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock
{
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableString *urlMutStr = [[NSMutableString alloc]init];
    [urlMutStr appendString:url];
    if (method) {
        [urlMutStr appendString:[NSString stringWithFormat:@"/%@", method]];
    }
    if (params) {
        [urlMutStr appendString:[NSString stringWithFormat:@"?%@", [self params2String:params]]];
    }
    NSString *urlStr = [urlMutStr copy];
    //转码
    urlStr= [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    NSLog(@"get url = %@", urlStr);
    NSURL *httpUrl = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:httpUrl];
    request.timeoutInterval = DATA_TIMEOUT_VALUE;
    request.HTTPMethod = @"GET";
    
    if (header) {
        // Json请求头方式
        
        for (NSString* key in [header allKeys]) {
            [request setValue:[header valueForKey:key] forHTTPHeaderField:key];
        }
        
        //设置请求体
        NSString *param = [CJHTTPRequest toJSONString:params];
        //    NSLog(@"post param = %@", param);
        //把拼接后的字符串转换为data，设置请求体
        request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    }else {
        
    }
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            CallMainThread(failblock(error, error.description););
        }else {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            //            NSLog(@"get dict:%@",dict);
            CallMainThread(successblock([CJHTTPRequest toJSONString:dict], tag););
        }
        
    }];
    
    [dataTask resume];
}

+(void)PostMethod:(NSString*)method Header:(NSDictionary*)header Params:(NSDictionary*)params Tag:(int)tag Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock
{
    [CJHTTPRequest PostURL:[CJHTTPConfig getDefaultURL] Method:method Header:header Params:params Tag:tag Success:successblock Fail:failblock];
}

+(void)PostURL:(NSString*)url Method:(NSString*)method Header:(NSDictionary*)header Params:(NSDictionary*)params Tag:(int)tag Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock
{
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableString *urlMutStr = [[NSMutableString alloc]init];
    [urlMutStr appendString:url];
    if (method) {
        [urlMutStr appendString:[NSString stringWithFormat:@"/%@", method]];
    }
    NSString *urlStr = [urlMutStr copy];
    //转码
    urlStr= [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *httpUrl = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:httpUrl];
    request.timeoutInterval = DATA_TIMEOUT_VALUE;
    request.HTTPMethod = @"POST";
    
    //设置请求头
    if (header) {
        // Json请求头方式
        
        for (NSString* key in [header allKeys]) {
            [request setValue:[header valueForKey:key] forHTTPHeaderField:key];
        }
        
        //设置请求体
        NSString *param = [CJHTTPRequest toJSONString:params];
        //    NSLog(@"post param = %@", param);
        //把拼接后的字符串转换为data，设置请求体
        request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
        
    }else {
        // 默认请求头方式
        
        //设置请求体
        NSString *param = [self params2String:params];
        //    NSLog(@"post param = %@", param);
        //把拼接后的字符串转换为data，设置请求体
        request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
        
    }
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            CallMainThread(failblock(error, error.description););
        }else {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            //            NSLog(@"post dict:%@",dict);
            CallMainThread(successblock([CJHTTPRequest toJSONString:dict], tag););
        }
        
    }];
    
    [dataTask resume];
}

+(void)FormMethod:(NSString*)method Tag:(int)tag FormParams:(FormParamsBlock)formblock Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock
{
    [self FormURL:[CJHTTPConfig getDefaultURL] Method:method Tag:tag FormParams:formblock Success:successblock Fail:failblock];
}

+(void)FormURL:(NSString*)url Method:(NSString*)method Tag:(int)tag FormParams:(FormParamsBlock)formblock Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock
{
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableString *urlMutStr = [[NSMutableString alloc]init];
    [urlMutStr appendString:url];
    if (method) {
        [urlMutStr appendString:[NSString stringWithFormat:@"/%@", method]];
    }
    NSString *urlStr = [urlMutStr copy];
    //转码
    urlStr= [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *httpUrl = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:httpUrl];
    request.timeoutInterval = DATA_TIMEOUT_VALUE;
    request.HTTPMethod = @"POST";
    
    CJHTTPFormModel *formModel = [[CJHTTPFormModel alloc]init];
    formModel.boundary = @"myBoundary";
    NSDictionary *header = [formModel getHeadersDictionary];
    for (NSString* key in [header allKeys]) {
        [request setValue:[header valueForKey:key] forHTTPHeaderField:key];
    }
    formblock(formModel);
    [formModel appendParamsSeparateEnd];
    
    request.HTTPBody = [formModel getFormData];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            CallMainThread(failblock(error, error.description););
        }else {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//            NSLog(@"post dict:%@",dict);
            CallMainThread(successblock([CJHTTPRequest toJSONString:dict], tag););
        }
        
    }];
    
    [dataTask resume];
}

+ (void)downloadDataWithURL:(NSString*)url SaveFilePath:(NSString*)filepath Tag:(int)tag Progress:(ProgressBlock)progress Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock
{
//    _successBlock = successblock;
//    _progressBlock = progress;
//    _failBlock = failblock;
//    _filePath = filepath;
    
    // 获得NSURLSession对象
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    
    // 获得下载任务
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:[NSURL URLWithString:url]];
    
    // 启动任务
    [task resume];
    
    // 向字典添加对应的tag
    if (_downloadArr == NULL) {
        _downloadArr = [[NSMutableArray alloc]init];
    }
    NSDictionary* dic = @{
                          @"successblock": successblock,
                          @"progress": progress,
                          @"failblock": failblock,
                          @"tag": @(tag),
                          @"filepath": filepath,
                          @"task": task
                          };
    [_downloadArr addObject:dic];
}

+ (void)queueWithParamsArray:(NSArray*)paramsArray Success:(SuccessBlock)successblock Fail:(SingleFailureBlock)failblock TotalSuccess:(TotalSuccessBlock)totalsuccessblock
{
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    //创建一个信号量（值为0）
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_async(queue, ^{
        for (int index = 0; index < paramsArray.count; index++) {

            NSDictionary* paramsDic = (NSDictionary*)[paramsArray objectAtIndex:index];
            __block NSString* url;
            if ([paramsDic valueForKey:[CJHTTPConfig getQueueKeyString:CJHTTPQueueKey_URL]]) {
                url = (NSString*)[paramsDic valueForKey:[CJHTTPConfig getQueueKeyString:CJHTTPQueueKey_URL]];
            }else {
                url = [CJHTTPConfig getDefaultURL];
            }
            __block NSString* method = (NSString*)[paramsDic valueForKey:[CJHTTPConfig getQueueKeyString:CJHTTPQueueKey_Method]];
            __block NSDictionary* params = (NSDictionary*)[paramsDic valueForKey:[CJHTTPConfig getQueueKeyString:CJHTTPQueueKey_Params]];
            __block NSString* httpMethod = (NSString*)[paramsDic valueForKey:[CJHTTPConfig getQueueKeyString:CJHTTPQueueKey_HTTPMethod]];
//            __block int timeout = [(NSString*)[paramsDic objectForKey:[CJHTTPConfig getQueueKeyString:CJHTTPQueueKey_TimeOut]] intValue];
            __block int tag = [(NSString*)[paramsDic objectForKey:[CJHTTPConfig getQueueKeyString:CJHTTPQueueKey_Tag]] intValue];
            
            if ([[httpMethod uppercaseString] isEqualToString:@"GET"]) {
                [CJHTTPRequest GetURL:url Method:method Params:params Tag:tag Success:^(NSString *data, int tag) {
                    CallMainThread(successblock(data, tag););
                    //信号量加1
                    dispatch_semaphore_signal(semaphore);
                } Fail:^(NSError *error, NSString *describe) {
                    CallMainThread(failblock(error, describe, tag););
                    return;
                }];
            }else if ([[httpMethod uppercaseString] isEqualToString:@"POST"]) {
                [CJHTTPRequest PostURL:url Method:method Params:params Tag:tag Success:^(NSString *data, int tag) {
                    CallMainThread(successblock(data, tag););
                    //信号量加1
                    dispatch_semaphore_signal(semaphore);
                } Fail:^(NSError *error, NSString *describe) {
                    CallMainThread(failblock(error, describe, tag););
                    return;
                }];
            }
            
            //信号量减1，如果>0，则向下执行，否则等待
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }
        CallMainThread(totalsuccessblock(-1););
    });
}

+ (void)groupWithParamsArray:(NSArray*)paramsArray Success:(SuccessBlock)successblock Fail:(SingleFailureBlock)failblock TotalSuccess:(TotalSuccessBlock)totalsuccessblock
{
    dispatch_queue_t conCurrentGlobalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_group_t groupQueue = dispatch_group_create();
    
    __block int successCount = 0;
    __block int failCount = 0;
    
    for (int index = 0; index < paramsArray.count; index++) {
        NSDictionary* paramsDic = (NSDictionary*)[paramsArray objectAtIndex:index];
        __block NSString* url;
        if ([paramsDic valueForKey:[CJHTTPConfig getQueueKeyString:CJHTTPQueueKey_URL]]) {
            url = (NSString*)[paramsDic valueForKey:[CJHTTPConfig getQueueKeyString:CJHTTPQueueKey_URL]];
        }else {
            url = [CJHTTPConfig getDefaultURL];
        }
        __block NSString* method = (NSString*)[paramsDic valueForKey:[CJHTTPConfig getQueueKeyString:CJHTTPQueueKey_Method]];
        __block NSDictionary* params = (NSDictionary*)[paramsDic valueForKey:[CJHTTPConfig getQueueKeyString:CJHTTPQueueKey_Params]];
        __block NSString* httpMethod = (NSString*)[paramsDic valueForKey:[CJHTTPConfig getQueueKeyString:CJHTTPQueueKey_HTTPMethod]];
//        __block int timeout = [(NSString*)[paramsDic objectForKey:[CJHTTPConfig getQueueKeyString:CJHTTPQueueKey_TimeOut]] intValue];
        __block int tag = [(NSString*)[paramsDic objectForKey:[CJHTTPConfig getQueueKeyString:CJHTTPQueueKey_Tag]] intValue];
        
        dispatch_group_async(groupQueue, conCurrentGlobalQueue, ^{
            if ([[httpMethod uppercaseString] isEqualToString:@"GET"]) {
                [CJHTTPRequest GetURL:url Method:method Params:params Tag:tag Success:^(NSString *data, int tag) {
                    successCount++;
                    CallMainThread(successblock(data, tag););
                } Fail:^(NSError *error, NSString *describe) {
                    failCount++;
                    CallMainThread(failblock(error, describe, tag););
                }];
            }else if ([[httpMethod uppercaseString] isEqualToString:@"POST"]) {
                [CJHTTPRequest PostURL:url Method:method Params:params Tag:tag Success:^(NSString *data, int tag) {
                    successCount++;
                    CallMainThread(successblock(data, tag););
                } Fail:^(NSError *error, NSString *describe) {
                    failCount++;
                    CallMainThread(failblock(error, describe, tag););
                }];
            }
        });
    }
    dispatch_group_async(groupQueue, conCurrentGlobalQueue, ^{
        while (1 && paramsArray.count > 0) {
            if (successCount + failCount == paramsArray.count) {
                if (successCount == paramsArray.count) {
                    CallMainThread(totalsuccessblock(-1););
                }
                break;
            }
            [NSThread sleepForTimeInterval:0.1];
        }
    });
}

#pragma mark - 私有静态函数
+ (NSString *)toJSONString:(NSDictionary*)dic
{
    NSData *paramsJSONData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
    return [[NSString alloc] initWithData:paramsJSONData encoding:NSUTF8StringEncoding];
}

+(NSString*)params2String:(NSDictionary*)params {
    NSMutableString* result = [[NSMutableString alloc]initWithString:@""];
    NSMutableDictionary* paramsNew = [[NSMutableDictionary alloc]initWithDictionary:params];
    
    NSMutableArray* keyArr = [[NSMutableArray alloc]initWithArray:[paramsNew allKeys]];
    NSArray *sortedArray = [keyArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return [obj1 compare:obj2];
    }];
    
    for (NSString* key in sortedArray) {
        NSString* value = paramsNew[key];
        [result appendString:[NSString stringWithFormat:@"%@=%@&", key, value]];
    }
    if (result.length > 0) {
        result = [[NSMutableString alloc]initWithString:[result substringToIndex:result.length-1]];
    }
//    NSLog(@"result = %@", result);
    return result;
}

#pragma mark - NSURLSessionDownloadDelegate代理
+ (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    // 先从downloadArr中查找指定任务的dic
    NSDictionary* dic;
    for (dic in _downloadArr) {
        if (dic[@"task"] == downloadTask) {
            break;
        }
        dic = nil;
    }
    if (!dic) return;
    
    ProgressBlock progress = (ProgressBlock)dic[@"progress"];
    if (progress) {
        dispatch_async(dispatch_get_main_queue(), ^(){
            progress(totalBytesWritten, totalBytesExpectedToWrite);
        });
    }
}

+ (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    // 先从downloadArr中查找指定任务的dic
    NSDictionary* dic;
    for (dic in _downloadArr) {
        if (dic[@"task"] == downloadTask) {
            [_downloadArr removeObject:dic];
            break;
        }
        dic = nil;
    }
    if (!dic) return;
    
    SuccessBlock successblock = (SuccessBlock)dic[@"successblock"];
    FailureBlock failblock = (FailureBlock)dic[@"failblock"];
    NSString* filePath = (NSString*)dic[@"filepath"];
    int tag = [(NSString*)dic[@"tag"] intValue];
    
    if (location == NULL) {
        if (failblock) {
            CallMainThread(failblock(NEWHTTPERROR(CJWebServiceError_DownFileIsNULL), @"下载的文件为空"););
        }
    }else if (filePath == NULL) {
        if (failblock) {
            CallMainThread(failblock(NEWHTTPERROR(CJWebServiceError_SavePathIsNULL), @"下载后所需要保存的文件路径为空"););
        }
    }else {
        // 先删除预保存的路径
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            [[NSFileManager defaultManager] removeItemAtURL:[NSURL fileURLWithPath:filePath] error:nil];
        }
        // 复制文件
        NSError* error;
        [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:filePath] error:&error];
        if (error) {
            CallMainThread(failblock(NEWHTTPERROR(CJWebServiceError_SaveDownloadData), @"保存下载文件失败"););
        }else {
            // 成功block回调
            if (successblock) {
                CallMainThread(successblock(nil, tag););
            }
        }
    }
}

+(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    // 先从downloadArr中查找指定任务的dic
    NSDictionary* dic;
    for (dic in _downloadArr) {
        if (dic[@"task"] == task) {
            [_downloadArr removeObject:dic];
            break;
        }
        dic = nil;
    }
    if (!dic) return;
    
    FailureBlock failblock = (FailureBlock)dic[@"failblock"];
    CallMainThread(failblock(NEWHTTPERROR(CJWebServiceError_ConnectTimeout), @"下载连接超时"););
}

@end
