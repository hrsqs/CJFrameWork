//
//  CJHTTPRequest.m
//  CJFrameWork
//
//  Created by basic－cj on 2017/6/29.
//  Copyright © 2017年 basic. All rights reserved.
//

#import "CJHTTPRequest.h"
#import "CJHTTPConfig.h"

#import <CommonCrypto/CommonDigest.h>

@implementation CJHTTPRequest

#pragma mark - 公有静态函数
+(void)GetMethod:(NSString*)method Params:(NSDictionary*)params Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock
{
    NSURLSession *session = [NSURLSession sharedSession];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?%@", [CJHTTPConfig getDefaultURL], method, [self params2URIString:params]]];
    
    //3.创建可变的请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSLog(@"data:%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        //8.解析数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"dict:%@",dict);
        
    }];
    
    //7.执行任务
    [dataTask resume];
}

#pragma mark - 私有静态函数
+(NSString*)params2URIString:(NSDictionary*)params {
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
}

@end
