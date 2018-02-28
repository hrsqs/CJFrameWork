//
//  CJHTTPFormModel.h
//  CJFrameWork
//
//  Created by 陈敬 on 2018/2/26.
//  Copyright © 2018年 陈敬. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CJHTTPFormModel : NSObject

// require
@property (nonatomic, strong) NSString *boundary;


// optional
/**
 默认为"keep-alive"
 */
@property (nonatomic, strong) NSString *Connection;
/**
 默认为"UTF-8"
 */
@property (nonatomic, strong) NSString *Charsert;
/**
 默认为"multipart/form-data;boundary="+boundary
 */
@property (nonatomic, strong) NSString *Content_Type;
/**
 默认为""
 */
@property (nonatomic, strong) NSString *Authorization;

/**
 添加一个键值对数据

 @param data value数据
 @param name key字符串
 */
- (void)appendFormData:(NSData*)data name:(NSString*)name;

/**
 添加一个文件型数据

 @param data 文件数据
 @param name key字符串,如"file"
 @param filename 文件名
 @param mimetype 文本类型,如"application/octet-stream"、"text/plain"等
 */
- (void)appendFileData:(NSData*)data name:(NSString*)name fileName:(NSString*)filename mimeType:(NSString*)mimetype;

- (NSData*)getFormData;
/**
 获取HTTP的POST请求头
 注：为框架使用
 
 @return 请求头字典
 */
- (NSDictionary*)getHeadersDictionary;

/**
 添加参数末尾的分隔符
 注：为框架使用
 */
- (void)appendParamsSeparateEnd;

@end
