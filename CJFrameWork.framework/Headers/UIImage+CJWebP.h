//
//  UIImage+CJWebP.h
//  CJFrameWork
//
//  Created by basic－cj on 2017/3/20.
//  Copyright © 2017年 basic. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "CJWebData.h"

@interface UIImage (CJWebP)

+(UIImage*)imagedWithData:(NSData*)data ImageType:(CJWebDataImageType)type;

@end
