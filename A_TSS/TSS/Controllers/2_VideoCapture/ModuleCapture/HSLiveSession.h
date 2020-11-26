//
//  HSLiveSession.h
//  Demo
//
//  Created by Chenfy on 2020/5/14.
//  Copyright © 2020 Chenfy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HSLiveSessionDelegate <NSObject>

@required
- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection;

@end

@interface HSLiveSession : NSObject
@property(nonatomic,weak)id <HSLiveSessionDelegate>delegate;

/** 初始化相机环境*/
- (void)setupAVCapture;
/** 设置渲染视图 */
- (void)setVideoPreview:(UIView *)view;
/** 开启视频数据采集*/
- (void)startSession;
/** 停止视频数据采集*/
- (void)stopSession;

- (UIImage *)readSampleBufferVideoToImage:(CMSampleBufferRef)sampleBuffer;

@end

NS_ASSUME_NONNULL_END
