//
//  CJHTTPConfig.h
//  CJFrameWork
//
//  Created by basic－cj on 2017/6/29.
//  Copyright © 2017年 basic. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NEWHTTPERROR(x) [NSError errorWithDomain:@"CJHTTPError" code:x userInfo:nil]

typedef NS_ENUM(NSInteger, CJHTTPType) {
    CJHTTPType_Data = 2000,
    CJHTTPType_Upload = 2001,
    CJHTTPType_Download = 2002,
    CJHTTPType_Queue = 2003,
    CJHTTPType_Group = 2004
};

typedef NS_ENUM(NSInteger, CJHTTPQueueKey) {
    CJHTTPQueueKey_URL = 3000,      // URL键可以不赋值
    CJHTTPQueueKey_Method = 3001,
    CJHTTPQueueKey_Params = 3002,
    CJHTTPQueueKey_HTTPMethod = 3003,
//    CJHTTPQueueKey_TimeOut = 3003,
    CJHTTPQueueKey_Tag = 3004
};

@interface CJHTTPConfig : NSObject

+(void)setDefaultURL:(NSString*)url;
+(NSString*)getDefaultURL;

/**
* 通过对应的枚举型数值返回对应的字符串
*/
+(NSString*)getQueueKeyString:(CJHTTPQueueKey)e;

//+(void)setHTTPPartner:(NSString*)partner;
//+(NSString*)getHTTPPartner;
//
//+(void)setHTTPPartnerKey:(NSString*)partnerKey;
//+(NSString*)getHTTPPartnerKey;

@end
