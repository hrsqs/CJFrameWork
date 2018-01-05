//
//  CJAudioTool.m
//
//
//  Created by basic－cj on 16/11/29.
//  Copyright © 2016年 basic. All rights reserved.
//

#import "CJAudioTool.h"
#import "ExtAudioConverter.h"
#import "EMVoiceConverter.h"
#import "CJWebService.h"

@implementation CJAudioTool

+(void)GetNewMp3Path:(NSString*)oldPath Result:(result)result
{
    NSString* docPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *outputPath = [NSString stringWithFormat:@"%@/NewSound.mp3", docPath];
    
    ExtAudioConverter* converter = [[ExtAudioConverter alloc] init];
    converter.inputFile =  oldPath;
    converter.outputFile = outputPath;
    converter.outputSampleRate = 44100;
    converter.outputNumberChannels = 2;
    converter.outputBitDepth = BitDepth_16;
    converter.outputFileType = kAudioFileMP3Type;
    converter.outputFormatID = kAudioFormatMPEGLayer3;
    
    __block BOOL isConvert = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString* resultStr = nil;
        isConvert = [converter convert];
        if (isConvert) {
            resultStr = outputPath;
        }
        if (result) {
            result(resultStr);
        }
    });
}

+(void)ConvertToWavFromAndroidWith:(NSURL*)url Result:(result)result
{
    NSString* docPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString* urlStr = [url absoluteString];
    if ([url isFileURL]) {
        // 是本地文件
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"file://" withString:@""];
        if ([EMVoiceConverter isAMRFile:urlStr]) {
            NSString *savePath = [NSString stringWithFormat:@"%@/ConvertSound.wav", docPath];
            if (![EMVoiceConverter amrToWav:urlStr wavSavePath:savePath]) {
                result(savePath);
            }else {
                result(nil);
//                result(@"转换异常");
            }
        }else {
            result(nil);
//            result(@"不是amr格式");
        }
        
    }else {
        // 是网络链接
        NSString *savePath = [NSString stringWithFormat:@"%@/DownloadSound.wav", docPath];
        [CJWebService downloadDataWithURL:urlStr SaveFilePath:savePath Tag:-1 Progress:nil Success:^(NSString *data, int tag) {
            [CJAudioTool ConvertToWavFromAndroidWith:[NSURL fileURLWithPath:savePath] Result:^(NSString *newPath) {
                result(newPath);
            }];
        } Fail:^(NSError *error, NSString *describe) {
            result(nil);
//            result(@"下载异常");
        }];
        
    }
    
}

+(int)isAMRFile:(NSString*)filepath
{
    return [EMVoiceConverter isAMRFile:filepath];
}

@end
