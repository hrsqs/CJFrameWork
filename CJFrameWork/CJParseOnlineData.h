//
//  CJParseOnlineData.h
//  
//
//  Created by basic－cj on 16/9/21.
//  Copyright © 2016年 fxyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CJWebData.h"


typedef void (^ResultBlock)(NSError* error, NSString* result);

@interface CJParseOnlineData : NSObject <NSXMLParserDelegate>

@property (nonatomic) ResultBlock resultBlock;

- (void)parseWithData:(NSData*)data ResultBlock:(ResultBlock)block;

@end
