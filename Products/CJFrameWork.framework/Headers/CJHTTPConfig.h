//
//  CJHTTPConfig.h
//  CJFrameWork
//
//  Created by basic－cj on 2017/6/29.
//  Copyright © 2017年 basic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CJHTTPConfig : NSObject

+(void)setDefaultURL:(NSString*)url;
+(NSString*)getDefaultURL;

+(void)setHTTPPartner:(NSString*)partner;
+(NSString*)getHTTPPartner;

+(void)setHTTPPartnerKey:(NSString*)partnerKey;
+(NSString*)getHTTPPartnerKey;

@end
