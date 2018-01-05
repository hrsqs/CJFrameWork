//
//  CJAppStore.h
//  CJFrameWork
//
//  Created by basic－cj on 2017/5/31.
//  Copyright © 2017年 basic. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <UIKit/UIKit.h>

@interface CJAppStore : NSObject

/**
 * 设置一个AppleID，供框架使用
 */
+(void)setAppleID:(NSString*)idStr;
+(void)clearAppleID;

/**
 * 判断当前项目是否需要从AppStore更新最新版,如果有更高的版本则自动弹窗提示，如果没有则无反应
 * 注：需先设置好AppleID才可正常获取。
 */
+(void)isNeedUpdateFromAppStore:(UIViewController*)controller;

@end
