//
//  WebData.h
//  
//
//  Created by basic－cj on 16/9/22.
//  Copyright © 2016年 fxyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**数据任务超时默认设置,单位秒 */
#define DATA_TIMEOUT_VALUE 10.0
/**上传任务超时默认设置,单位秒 */
#define UPLOAD_TIMEOUT_VALUE 3600.0

typedef NS_ENUM(NSInteger, CJWebServiceError) {
    CJWebServiceError_NoError = 0,                      // 无错误
    CJWebServiceError_ConnectTimeout = 10000,           // 连接超时
    CJWebServiceError_ServiceReturnNULL = 10001,        // 服务端返回了NULL值
    CJWebServiceError_ServiceReturnErrorValue = 10002,  // 服务端返回了错误的值
    CJWebServiceError_ParseValueIsNULL = 10003,         // 需要解析的值为NULL
    CJWebServiceError_ParseValueError = 10004,          // 解析值时发生了错误
    CJWebServiceError_SavePathIsNULL = 10005,           // 下载需要保存的文件路径为空
    CJWebServiceError_DownFileIsNULL = 10006,           // 下载的文件为空
    CJWebServiceError_SaveDownloadData = 10007,         // 保存下载文件失败
    CJWebServiceError_URLIsNULL = 10008                 // 访问的URL为空
};

typedef NS_ENUM(NSInteger, CJWebDataImageType) {
    CJWebDataImageType_PNG  = 1000,
    CJWebDataImageType_JPG  = 1001,
    CJWebDataImageType_WebP = 1002
};

typedef NS_ENUM(NSInteger, CJWebServiceType) {
    CJWebServiceType_Data = 2000,
    CJWebServiceType_Upload = 2001,
    CJWebServiceType_Download = 2002,
    CJWebServiceType_Queue = 2003,
    CJWebServiceType_Group = 2004
};

typedef NS_ENUM(NSInteger, CJWebServiceQueueKey) {
    CJWebServiceQueueKey_URL = 3000,
    CJWebServiceQueueKey_Method = 3001,
    CJWebServiceQueueKey_Params = 3002,
    CJWebServiceQueueKey_TimeOut = 3003,
    CJWebServiceQueueKey_Tag = 3004
};

@interface CJWebData : NSObject

/**
 * 设置、获取默认的服务端URL
 */
+(void)setDefaultURL:(NSString*)url;
+(NSString*)getDefaultURL;

/**
 * 将UIImage转换为Base64位的字符串数据
 */
+(NSString* _Nullable)imageToStringBase64:(UIImage* _Nonnull)image Type:(CJWebDataImageType)type;

/**
 * 将NSData转换为Base64位的字符串数据
 */
+(NSString* _Nullable)dataToStringBase64:(NSData* _Nonnull)data;

/**
 * 将字符串转换为UTF8格式字符串
 */
+(NSString*)stringToUTF8String:(NSString*)oldStr;

/**
 * 通过对应的枚举型数值返回对应的字符串
 */
+(NSString*)getQueueKeyString:(CJWebServiceQueueKey)e;

@end
