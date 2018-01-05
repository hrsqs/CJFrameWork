//
//  CJHTTPRequest.h
//  CJFrameWork
//
//  Created by basic－cj on 2017/6/29.
//  Copyright © 2017年 basic. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SuccessBlock)(NSString *data, int tag);
typedef void (^FailureBlock)(NSError *error, NSString* describe);


@interface CJHTTPRequest : NSObject


+(void)GetMethod:(NSString*)method Params:(NSDictionary*)params Success:(SuccessBlock)successblock Fail:(FailureBlock)failblock;

@end
