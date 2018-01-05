//
//  CJAudioTool.h
//
//
//  Created by basic－cj on 16/11/29.
//  Copyright © 2016年 basic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CJAudioTool : NSObject

typedef void(^result)(NSString *newPath);

/**
 * 将旧的MP3音频文件转换为新的MP3格式音频
 * oldPath：旧音频文件路径
 * result： 返回结果用的Block
 * 返回结果：新MP3音频文件路径
 */
+(void)GetNewMp3Path:(NSString*)oldPath Result:(result)result;

/**
 * 将安卓传来的AMR视频进行转码
 * url： 支持本地文件([NSURL fileURLWithPath:])与网络链接([NSURL URLWithString:])
 * result： 返回结果用的Block  若返回nil，表示转码失败
 */
+(void)ConvertToWavFromAndroidWith:(NSURL*)url Result:(result)result;

// 调试框架用
//+(int)isAMRFile:(NSString*)filepath;

@end
