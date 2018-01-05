//
//  NSData+CJBase64.h
//  
//
//  Created by basic－cj on 16/9/29.
//  Copyright © 2016年 fxyy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (CJBase64)
+ (id)dataWithBase64EncodedString:(NSString *)string;
- (NSString *)base64Encoding;
@end
