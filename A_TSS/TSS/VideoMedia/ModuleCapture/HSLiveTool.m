//
//  HSLiveTool.m
//  Demo
//
//  Created by Chenfy on 2020/5/14.
//  Copyright © 2020 Chenfy. All rights reserved.
//

#import "HSLiveTool.h"
#import <Photos/Photos.h>

@interface HSLiveTool ()
@property(nonatomic,strong)AVCaptureSession *captureSession;
@property(nonatomic,strong)AVCaptureDeviceInput *inputVideo;
@property(nonatomic,strong)AVCaptureDeviceInput *inputAudio;

@property(nonatomic,strong)AVCaptureVideoDataOutput *outputVideo;
@property(nonatomic,strong)AVCaptureAudioDataOutput *outputAudio;

//AVCaptureVideoPreviewLayer
@property(nonatomic,strong)AVCaptureVideoPreviewLayer *previewLayer;

#pragma mark -- test
@property(nonatomic,strong)UIView    *preview;
@end

@implementation HSLiveTool
#pragma mark --
#pragma mark -- func
/** 修改视频方向 */
- (void)shutterCamera {
    AVCaptureConnection * videoConnection = [self.outputVideo connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        NSLog(@"take photo failed!");
        return;
    }
    videoConnection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
}

/** 前后摄像头切换 */
- (void)toggleCamera {
    NSUInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    if (cameraCount > 1) {
        NSError *error;
        AVCaptureDeviceInput *newVideoInput;
        AVCaptureDevicePosition position = [[_inputVideo device] position];
        
        if (position == AVCaptureDevicePositionBack)
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self frontCamera] error:&error];
        else if (position == AVCaptureDevicePositionFront)
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backCamera] error:&error];
        else
            return;
        
        if (newVideoInput != nil) {
            [self.captureSession beginConfiguration];
            [self.captureSession removeInput:self.inputVideo];
            if ([self.captureSession canAddInput:newVideoInput]) {
                [self.captureSession addInput:newVideoInput];
                
                self.inputVideo = newVideoInput;
            } else {
                [self.captureSession addInput:self.inputVideo];
            }
            [self.captureSession commitConfiguration];
        } else if (error) {
            NSLog(@"toggle carema failed, error = %@", error);
        }
    }
}

/** 获取前后摄像头 */
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition) position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}

- (AVCaptureDevice *)frontCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

- (AVCaptureDevice *)backCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}

/** 音视频权限申请*/
- (void)mediaRequestAuth {
    // 相册判断授权状态
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted) { // 此应用程序没有被授权访问的照片数据。可能是家长控制权限。
        NSLog(@"因为系统原因, 无法访问相册");
    } else if (status == PHAuthorizationStatusDenied) { // 用户拒绝访问相册

    } else if (status == PHAuthorizationStatusAuthorized) { // 用户允许访问相册
        // 放一些使用相册的代码
    } else if (status == PHAuthorizationStatusNotDetermined) { // 用户还没有做出选择
        // 弹框请求用户授权
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) { // 用户点击了好
              // 放一些使用相册的代码
            }
        }];
    }
    
    //相机权限
    __unused AVAuthorizationStatus authAudio = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    __unused AVAuthorizationStatus authVideo = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];

    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        
    }];
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        
    }];
}

/** 二维码扫描 */
- (void)scanQRCode {
    //1.初始化捕捉设备（AVCaptureDevice），类型为AVMediaTypeVideo
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //2.用captureDevice创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:nil];
    //3.创建媒体数据输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    //4.实例化捕捉会话
    _captureSession = [[AVCaptureSession alloc] init];
    //4.1.将输入流添加到会话
    [_captureSession addInput:input];
    //4.2.将媒体输出流添加到会话中
    [_captureSession addOutput:output];
    //5.设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //5.2.设置输出媒体数据类型为QRCode
    [output setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    //6.实例化预览图层
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    //7.设置预览图层填充方式
    [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    //8.设置图层的frame
    [_previewLayer setFrame:_preview.bounds];
    //9.将图层添加到预览view的图层上
    [_preview.layer addSublayer:_previewLayer];
    //10.设置扫描范围
    output.rectOfInterest = CGRectMake(0.2f, 0.2f, 0.8f, 0.8f);
    //10.1.扫描框
    UIView *_viewPreview = _preview;
    UIView *_boxView = [[UIView alloc] initWithFrame:CGRectMake(_viewPreview.bounds.size.width * 0.2, _viewPreview.bounds.size.height*0.2, _viewPreview.bounds.size.width - _viewPreview.bounds.size.width * 0.4f, _viewPreview.bounds.size.width - _viewPreview.bounds.size.width * 0.4f)];
    _boxView.layer.borderColor = [UIColor redColor].CGColor;
    _boxView.layer.borderWidth = 1.0;
    
    [_viewPreview addSubview:_boxView];
    
    CALayer *_scanLayer = [[CALayer alloc] init];
    _scanLayer.frame = CGRectMake(0, 0, _boxView.bounds.size.width, 1);
    _scanLayer.backgroundColor = [UIColor blackColor].CGColor;
    [_boxView.layer addSublayer:_scanLayer];
    
    [self.captureSession startRunning];
}

#pragma mark -- AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects[0];
        __unused NSString *result = metadataObject.stringValue;
    }
}


@end
