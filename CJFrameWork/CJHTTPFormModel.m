//
//  CJHTTPFormModel.m
//  CJFrameWork
//
//  Created by 陈敬 on 2018/2/26.
//  Copyright © 2018年 陈敬. All rights reserved.
//

#import "CJHTTPFormModel.h"

@interface CJHTTPFormModel ()

@property (nonatomic, strong) NSMutableData *formData;

@end

@implementation CJHTTPFormModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.formData = [[NSMutableData alloc]init];
    }
    return self;
}

- (NSDictionary*)getHeadersDictionary {
    if (!self.boundary) {
        return nil;
    }
    if (!self.Connection) {
        self.Connection = @"keep-alive";
    }
    if (!self.Charsert) {
        self.Charsert = @"UTF-8";
    }
    if (!self.Content_Type) {
        self.Content_Type = [NSString stringWithFormat:@"multipart/form-data;boundary=%@", self.boundary];
    }
    if (!self.Authorization) {
        self.Authorization = @"";
    }
    NSDictionary *result = @{
                             @"connection":     self.Connection,
                             @"Charsert":       self.Charsert,
                             @"Content-Type":   self.Content_Type,
                             @"Authorization":  self.Authorization
                             };
    return result;
}

- (void)appendParamsSeparate {
    [self.formData appendData:[[NSString stringWithFormat:@"--%@\r\n", self.boundary] dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)appendParamsSeparateEnd {
    [self.formData appendData:[[NSString stringWithFormat:@"--%@--\r\n", self.boundary] dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)appendFormData:(NSData*)data name:(NSString*)name {
    [self appendParamsSeparate];
    //拼接参数名
    [self.formData appendData:[[NSString stringWithFormat:@"Content-Disposition:form-data;name=\"%@\"\r\n", name] dataUsingEncoding:NSUTF8StringEncoding]];
    [self.formData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    //拼接参数值
    [self.formData appendData:data];
    [self.formData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)appendFileData:(NSData*)data name:(NSString*)name fileName:(NSString*)filename mimeType:(NSString*)mimetype {
    [self appendParamsSeparate];
    //拼接参数名
    [self.formData appendData:[[NSString stringWithFormat:@"Content-Disposition:form-data;name=\"%@\"; filename=\"%@\"\r\n", name, filename] dataUsingEncoding:NSUTF8StringEncoding]];
//    [self.formData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [self.formData appendData:[[NSString stringWithFormat:@"Content-Type:%@\r\n\r\n", mimetype] dataUsingEncoding:NSUTF8StringEncoding]];
    //拼接参数值
    [self.formData appendData:data];
    [self.formData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
}

- (NSData*)getFormData {
    return self.formData;
}

@end
