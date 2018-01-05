//
//  UIImage+CJWebP.m
//  CJFrameWork
//
//  Created by basic－cj on 2017/3/20.
//  Copyright © 2017年 basic. All rights reserved.
//

#import "UIImage+CJWebP.h"
#import "UIImageWebP.h"

@implementation UIImage (CJWebP)

+(UIImage*)imagedWithData:(NSData*)data ImageType:(CJWebDataImageType)type
{
    switch (type) {
        case CJWebDataImageType_WebP:
            
            return [UIImageWebP imageWithWebPData:data];
            
        default:
            return [UIImage imageWithData:data];
    }
}

@end
