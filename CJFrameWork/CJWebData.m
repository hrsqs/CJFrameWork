//
//  CJWebData.m
//
//
//  Created by basic－cj on 16/9/22.
//  Copyright © 2016年 fxyy. All rights reserved.
//

#import "CJWebData.h"
#import "NSData+CJBase64.h"
#import "UIImageWebP.h"

@implementation CJWebData

static NSString* _defaultURL;

+(void)setDefaultURL:(NSString*)url
{
    if (_defaultURL != url) {
        _defaultURL = [url copy];
    }
}

+(NSString*)getDefaultURL
{
    return _defaultURL;
}

+(NSString*)imageToStringBase64:(UIImage*)image Type:(CJWebDataImageType)type
{
    NSData* imageData = nil;
    switch (type) {
        case CJWebDataImageType_JPG:
            imageData = UIImageJPEGRepresentation(image, 1.0);
            break;
        case CJWebDataImageType_PNG:
            imageData = UIImagePNGRepresentation(image);
            break;
        default:
            imageData = [UIImageWebP imageToWebP:image quality:1.0];
            break;
    }
    if (imageData) {
        NSString *pictureDataString=[imageData base64Encoding];
//        NSString *imageStr=[CJWebData encodeURL:pictureDataString];
//        return imageStr;
        return pictureDataString;
    }else {
        return nil;
    }
}

+(NSString* _Nullable)dataToStringBase64:(NSData* _Nonnull)data
{
    if (data) {
        NSString *dataBase64String=[data base64Encoding];
//        NSString *resultStr=[CJWebData encodeURL:dataBase64String];
//        return resultStr;
        return dataBase64String;
    }else {
        return nil;
    }
}

+ (NSString*)encodeURL:(NSString *)string
{
    NSString *newString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)string, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"),kCFStringEncodingUTF8));
    if (newString) {
        return newString;
    }
    return nil;
}

+(NSString*)stringToUTF8String:(NSString*)oldStr
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,(CFStringRef)oldStr, CFSTR(""),kCFStringEncodingUTF8));
}

+(NSString*)getQueueKeyString:(CJWebServiceQueueKey)e
{
    switch (e) {
        case CJWebServiceQueueKey_Method:
            return @"Method";
        case CJWebServiceQueueKey_Params:
            return @"Params";
        case CJWebServiceQueueKey_TimeOut:
            return @"TimeOut";
        case CJWebServiceQueueKey_Tag:
            return @"Tag";
        case CJWebServiceQueueKey_URL:
        default:
            return @"URL";
    }
}

@end
