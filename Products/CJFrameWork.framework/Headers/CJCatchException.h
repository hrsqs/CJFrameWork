//
//  CJCatchException.h
//  CJFrameWork
//
//  Created by basic－cj on 2017/6/1.
//  Copyright © 2017年 basic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CJCatchException : NSObject

/*!
 *  异常的处理方法
 *  注：建议在application:didFinishLaunchingWithOptions下调用此函数
 *     异常崩溃日志保存在沙盒Cache文件夹下的CrashLog文件夹中
 */
+ (void)installUncaughtExceptionHandler;

@end
