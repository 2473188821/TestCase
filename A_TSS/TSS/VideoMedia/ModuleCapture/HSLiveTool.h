//
//  HSLiveTool.h
//  Demo
//
//  Created by Chenfy on 2020/5/14.
//  Copyright © 2020 Chenfy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HSLiveTool : NSObject
/** 音视频权限申请*/
- (void)mediaRequestAuth;

/** 修改视频方向 */
- (void)shutterCamera;

/** 前后摄像头切换 */
- (void)toggleCamera;

/** 二维码扫描 */
- (void)scanQRCode;

/** 获取摄像头 */
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position;

@end

NS_ASSUME_NONNULL_END
