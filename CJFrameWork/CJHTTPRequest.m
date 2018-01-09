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

@implementation CJHTTPRequest

#pragma mark - 公有静态函数
+(void)GetMethod:(NSString*)method Params:(NSDictionary*)params Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock
{
    NSURLSession *session = [NSURLSession sharedSession];

    NSString* urlStr = [NSString stringWithFormat:@"%@/%@?%@", [CJHTTPConfig getDefaultURL], method, [self params2String:params]];
    //转码
    urlStr= [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@"get url = %@", urlStr);
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = DATA_TIMEOUT_VALUE;
    request.HTTPMethod = @"GET";
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            failblock(error, error.description);
        }else {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//            NSLog(@"get dict:%@",dict);
            successblock([CJHTTPRequest toJSONString:dict], -1);
        }
        
    }];
    
    [dataTask resume];
}

+(void)PostMethod:(NSString*)method Params:(NSDictionary*)params Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock
{
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@/%@", [CJHTTPConfig getDefaultURL], method];
    //转码
    urlStr= [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = DATA_TIMEOUT_VALUE;
    request.HTTPMethod = @"POST";
    
    //设置请求体
    NSString *param = [self params2String:params];
//    NSLog(@"post param = %@", param);
    //把拼接后的字符串转换为data，设置请求体
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            failblock(error, error.description);
        }else {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//            NSLog(@"post dict:%@",dict);
            successblock([CJHTTPRequest toJSONString:dict], -1);
        }
        
    }];
    
    [dataTask resume];
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

/*+(NSString*)params2URIString:(NSDictionary*)params {
    NSMutableString* result = [[NSMutableString alloc]initWithString:@""];
    NSMutableDictionary* paramsNew = [[NSMutableDictionary alloc]initWithDictionary:params];
    [paramsNew setObject:[CJHTTPConfig getHTTPPartner] forKey:@"partner"];
    
    NSMutableArray* keyArr = [[NSMutableArray alloc]initWithArray:[paramsNew allKeys]];
    NSArray *sortedArray = [keyArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return [obj1 compare:obj2];
    }];

    for (NSString* key in sortedArray) {
        NSString* value = paramsNew[key];
        [result appendString:[NSString stringWithFormat:@"%@=%@&", key, value]];
    }
    result = [[NSMutableString alloc]initWithString:[result substringToIndex:result.length-1]];
    NSString* md5PreEncodeStr = [NSString stringWithFormat:@"%@%@", result, [CJHTTPConfig getHTTPPartnerKey]];
    
    NSString* md5String = [self md5:md5PreEncodeStr];
    
    [result appendString:[NSString stringWithFormat:@"&sign=%@", md5String]];
//    NSLog(@"result = %@", result);
    return result;
}

+(NSString *)md5:(NSString *)input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}*/

@end
