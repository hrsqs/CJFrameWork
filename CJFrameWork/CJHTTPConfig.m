//
//  CJHTTPConfig.m
//  CJFrameWork
//
//  Created by basic－cj on 2017/6/29.
//  Copyright © 2017年 basic. All rights reserved.
//

#import "CJHTTPConfig.h"

@implementation CJHTTPConfig

static NSString* _defaultURL;
static NSString* _partner;
static NSString* _partnerKey;

+(void)setDefaultURL:(NSString*)url
{
    _defaultURL = url;
}

+(NSString*)getDefaultURL
{
    return _defaultURL;
}

+(void)setHTTPPartner:(NSString*)partner
{
    _partner = partner;
}

+(NSString*)getHTTPPartner
{
    return _partner;
}

+(void)setHTTPPartnerKey:(NSString*)partnerKey
{
    _partnerKey = partnerKey;
}

+(NSString*)getHTTPPartnerKey
{
    return _partnerKey;
}

@end
