//
//  CJAppStore.m
//  CJFrameWork
//
//  Created by basic－cj on 2017/5/31.
//  Copyright © 2017年 basic. All rights reserved.
//

#import "CJAppStore.h"

@interface CJAppStore ()

typedef void(^GetVersionBlock)(NSString *version);

@end

@implementation CJAppStore

static NSString* _appleID;

+(void)setAppleID:(NSString*)idStr
{
    _appleID = idStr;
}

+(void)clearAppleID
{
    _appleID = nil;
}

+(BOOL)isNilForAppleID
{
    return _appleID == nil;
}

+(void)getAppStoreVersion:(GetVersionBlock)block
{
    if ([CJAppStore isNilForAppleID]) {
        if (block) {
            block(nil);
        }
        return;
    }
    
    __block NSString* version = nil;
    NSString* url = [[NSString alloc]initWithFormat:@"https://itunes.apple.com/lookup?id=%@", _appleID];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSDictionary *dictAll = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if (dictAll) {
                NSArray *array = dictAll[@"results"];
                if (array) {
                    NSDictionary *dict = [array lastObject];
                    if (dict) {
                        version = (NSString*)dict[@"version"];
                    }
                }
            }
        }
        
        if (block) {
            block(version);
        }
        
    }];
    [dataTask resume];
    
}

+(NSString*)getLocalAppVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+(void)isNeedUpdateFromAppStore:(UIViewController*)controller//:(isNeedUpdateBlock)block
{
    [CJAppStore getAppStoreVersion:^(NSString *version) {
        if (version) {
            NSInteger compareResult = [CJAppStore compareVersion:[CJAppStore getLocalAppVersion] to:version];
            if (compareResult < 0) {
                UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"版本更新" message:[[NSString alloc] initWithFormat:@"找到新版本V%@\n是否跳转更新?", version] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"暂不更新" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {}];
                UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"立刻跳转" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    NSString* itunesStr = [[NSString alloc]initWithFormat:@"itms-apps://itunes.apple.com/app/id%@", _appleID];
                    [[UIApplication sharedApplication] openURL:[[NSURL alloc] initWithString:itunesStr]];
                }];
                [alertVc addAction:cancle];
                [alertVc addAction:confirm];
                [controller presentViewController:alertVc animated:YES completion:nil];
            }
        }
        
    }];
}

/**
 比较两个版本号的大小
 
 @param v1 第一个版本号
 @param v2 第二个版本号
 @return 版本号相等,返回0; v1小于v2,返回-1; 否则返回1.
 */
+ (NSInteger)compareVersion:(NSString *)v1 to:(NSString *)v2 {
    // 都为空，相等，返回0
    if (!v1 && !v2) {
        return 0;
    }
    
    // v1为空，v2不为空，返回-1
    if (!v1 && v2) {
        return -1;
    }
    
    // v2为空，v1不为空，返回1
    if (v1 && !v2) {
        return 1;
    }
    
    // 获取版本号字段
    NSArray *v1Array = [v1 componentsSeparatedByString:@"."];
    NSArray *v2Array = [v2 componentsSeparatedByString:@"."];
    // 取字段最少的，进行循环比较
    NSInteger smallCount = (v1Array.count > v2Array.count) ? v2Array.count : v1Array.count;
    
    for (int i = 0; i < smallCount; i++) {
        NSInteger value1 = [[v1Array objectAtIndex:i] integerValue];
        NSInteger value2 = [[v2Array objectAtIndex:i] integerValue];
        if (value1 > value2) {
            // v1版本字段大于v2版本字段，返回1
            return 1;
        } else if (value1 < value2) {
            // v2版本字段大于v1版本字段，返回-1
            return -1;
        }
        
        // 版本相等，继续循环。
    }
    
    // 版本可比较字段相等，则字段多的版本高于字段少的版本。
    if (v1Array.count > v2Array.count) {
        return 1;
    } else if (v1Array.count < v2Array.count) {
        return -1;
    } else {
        return 0;
    }
    
    return 0;
}

@end
