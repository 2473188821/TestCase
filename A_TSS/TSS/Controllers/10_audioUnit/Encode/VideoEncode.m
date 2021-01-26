//
//  HVideoEncode.m
//  TSS
//
//  Created by Chenfy on 2021/1/25.
//  Copyright © 2021 Chenfy. All rights reserved.
//

#import "VideoEncode.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <VideoToolbox/VideoToolbox.h>

@interface VideoEncode ()
{
    int frameID;
    dispatch_queue_t queueCapture;
    dispatch_queue_t queueEncode;
    
    VTCompressionSessionRef EncodingSession;
    CMFormatDescriptionRef formatDes;
    NSFileHandle *fileHandle;
}
@end


@implementation VideoEncode

/** 初始化vidoeToolBox*/
- (void)initVideoToolBox {
    NSString *file = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"abc.h264"];
    [[NSFileManager defaultManager] removeItemAtPath:file error:nil];
    [[NSFileManager defaultManager] createFileAtPath:file contents:nil attributes:nil];
    fileHandle = [NSFileHandle fileHandleForWritingAtPath:file];

    NSError *error = nil;
    OSStatus status;
    
    frameID = 0;
    int width = 480, height = 640;
    
    status = VTCompressionSessionCreate(NULL, width, height, kCMVideoCodecType_H264, NULL, NULL, NULL, didCompressH264, (__bridge void *)self, &(EncodingSession));
    
    /* 1-5 做一系列设置操作 */
    
    VTCompressionSessionPrepareToEncodeFrames(EncodingSession);
}

/** 视频采集回调*/
- (void)captureBufferCallBack:(CMSampleBufferRef)sampleBuffer {
    dispatch_sync(queueEncode, ^{
        [self encodeVideoH264:sampleBuffer];
    });
}

/** 视频H264编码*/
- (void)encodeVideoH264:(CMSampleBufferRef)dataBuffer {
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(dataBuffer);
    CMTime presentationTimeStamp = CMTimeMake(frameID++, 1000);
    VTEncodeInfoFlags flags;
    OSStatus statusCode = VTCompressionSessionEncodeFrame(EncodingSession, imageBuffer, presentationTimeStamp, kCMTimeInvalid, NULL, NULL,    &flags);
}

/** 视频H264编码 回调*/
void didCompressH264(void * outputCallbackRefCon,void * sourceFrameRefCon,OSStatus status,VTEncodeInfoFlags infoFlags, CMSampleBufferRef sampleBuffer ) {
    
    NSLog(@"didCompressH264 called with status %d infoFlags %d", (int)status, (int)infoFlags);
    if (status != 0) {
        return;
    }
    if (!CMSampleBufferDataIsReady(sampleBuffer)) {
        NSLog(@"didCompressH264 data is not ready ");
        return;
    }
    
    VideoEncode* encoder = (__bridge VideoEncode*)outputCallbackRefCon;
    
    bool keyframe = !CFDictionaryContainsKey( (CFArrayGetValueAtIndex(CMSampleBufferGetSampleAttachmentsArray(sampleBuffer, true), 0)), kCMSampleAttachmentKey_NotSync);
    // 判断当前帧是否为关键帧
    // 获取sps & pps数据
    if (keyframe) {
        /* 获取sps、pps写入关键帧数据*/
    }
    
    /** 循环读取NALU 数据，加入分隔符写入文件*/
}

- (void)gotSpsPps:(NSData*)sps pps:(NSData*)pps
{
    NSLog(@"gotSpsPps %d %d", (int)[sps length], (int)[pps length]);
    const char bytes[] = "\x00\x00\x00\x01";
    size_t length = (sizeof bytes) - 1; //string literals have implicit trailing '\0'
    NSData *ByteHeader = [NSData dataWithBytes:bytes length:length];
    [fileHandle writeData:ByteHeader];
    [fileHandle writeData:sps];
    [fileHandle writeData:ByteHeader];
    [fileHandle writeData:pps];
    
}
- (void)gotEncodedData:(NSData*)data isKeyFrame:(BOOL)isKeyFrame
{
    NSLog(@"gotEncodedData %d", (int)[data length]);
    if (fileHandle != NULL)
    {
        const char bytes[] = "\x00\x00\x00\x01";
        size_t length = (sizeof bytes) - 1; //string literals have implicit trailing '\0'
        NSData *ByteHeader = [NSData dataWithBytes:bytes length:length];
        [fileHandle writeData:ByteHeader];
        [fileHandle writeData:data];
    }
}

- (void)EndVideoToolBox
{
    VTCompressionSessionCompleteFrames(EncodingSession, kCMTimeInvalid);
    VTCompressionSessionInvalidate(EncodingSession);
    CFRelease(EncodingSession);
    EncodingSession = NULL;
}


@end
