//
//  CJParseOnlineData.m
//  
//
//  Created by basic－cj on 16/9/21.
//  Copyright © 2016年 fxyy. All rights reserved.
//

#import "CJParseOnlineData.h"



@interface CJParseOnlineData ()
{
    NSMutableString* value;
    BOOL isSendBlock;
}
@end

@implementation CJParseOnlineData

-(void)sendBlock:(NSString*)result error:(NSError*)error {
    if (_resultBlock && !isSendBlock) {
        isSendBlock = YES;
        _resultBlock(error, result);
    }
}

- (void)parseWithData:(NSData*)data ResultBlock:(ResultBlock)block
{
    isSendBlock = NO;
    _resultBlock = block;
    
    if (data == nil) {
        [self sendBlock:nil error:NEWERROR(CJWebServiceError_ParseValueIsNULL)];
        return;
    }
    
    NSXMLParser* xmlParser = [[NSXMLParser alloc] initWithData: data];
    [xmlParser setDelegate: self];
    [xmlParser setShouldResolveExternalEntities: YES];
    [xmlParser parse];
}

#pragma mark -
#pragma mark XML Parser Delegate Methods
// 开始解析一个元素名
-(void) parser:(NSXMLParser *) parser didStartElement:(NSString *) elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *) qName attributes:(NSDictionary *) attributeDict {
//    NSLog(@"parser1 = %@", elementName);
    
    if (!value)
        value = [[NSMutableString alloc]init];
}

// 追加找到的元素值，一个元素值可能要分几次追加
-(void)parser:(NSXMLParser *) parser foundCharacters:(NSString *)string {
//    NSLog(@"parser2 = %@", string);
    
    [value appendString:string];
}

// 结束解析这个元素名
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
//    NSLog(@"parser3 = %@", elementName);
}

// 解析整个文件结束后
- (void)parserDidEndDocument:(NSXMLParser *)parser {
//    NSLog(@"parser4 = %@", @"complete");
    
    if (value) {
//        value = (NSMutableString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,(CFStringRef)value, CFSTR(""),kCFStringEncodingUTF8));
        [self sendBlock:value error:NEWERROR(CJWebServiceError_NoError)];
    }else {
        [self sendBlock:nil error:NEWERROR(CJWebServiceError_ParseValueError)];
    }
    
    value = nil;
}

// 出错时，例如强制结束解析
- (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
//    NSLog(@"parser5 = %@", parseError);
    
    [self sendBlock:nil error:NEWERROR(CJWebServiceError_ServiceReturnErrorValue)];
}

@end
