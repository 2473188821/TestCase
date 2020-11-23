//
//  HSLiveSession.m
//  Demo
//
//  Created by Chenfy on 2020/5/14.
//  Copyright © 2020 Chenfy. All rights reserved.
//

#import "HSLiveSession.h"

@interface HSLiveSession ()<AVCaptureAudioDataOutputSampleBufferDelegate,
AVCaptureVideoDataOutputSampleBufferDelegate>
/* <
 AVCapturePhotoCaptureDelegate,
 AVCaptureDepthDataOutputDelegate,
 AVCaptureFileOutputRecordingDelegate,
 AVCaptureMetadataOutputObjectsDelegate,
 AVCaptureDataOutputSynchronizerDelegate,
 AVCapturePhotoFileDataRepresentationCustomizer>
 */

@property(nonatomic,assign)BOOL userFrontCamera;

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

@implementation HSLiveSession

- (void)setupAVCapture {
    // 1 创建session
    AVCaptureSession *session = [AVCaptureSession new];
    //设置session显示分辨率
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        [session setSessionPreset:AVCaptureSessionPreset640x480];
    else
        [session setSessionPreset:AVCaptureSessionPresetPhoto];
    
    _captureSession = session;
    
    [_captureSession beginConfiguration];
    // 1 获取摄像头device,并且默认使用的后置摄像头,并且将摄像头加入到captureSession中
    AVCaptureDeviceInput *deviceInputV = [self deviceInPutForTypeVideo:YES];
    
    if ([self.captureSession canAddInput:deviceInputV]){
        [self.captureSession addInput:deviceInputV];
    }
    _inputVideo = deviceInputV;
    
    // 2 获取摄像头device,并且默认使用的后置摄像头,并且将摄像头加入到captureSession中
    AVCaptureDeviceInput *deviceInputA = [self deviceInPutForTypeVideo:NO];
    
    if ([self.captureSession canAddInput:deviceInputA]){
        [self.captureSession addInput:deviceInputA];
    }
    _inputAudio = deviceInputA;
    
    AVCaptureVideoDataOutput *outputVideo = [self captureOutputVideo];
    _outputVideo = outputVideo;
    
    if ([self.captureSession canAddOutput:outputVideo]) {
        [_captureSession addOutput:outputVideo];
    }
    
    AVCaptureAudioDataOutput *outputAudio = [self captureOutputAudio];
    _outputAudio = outputAudio;
    
    if ([self.captureSession canAddOutput:outputAudio]) {
        [_captureSession addOutput:outputAudio];
    }
    [_captureSession commitConfiguration];
}

- (AVCaptureVideoDataOutput *)captureOutputVideo {
    AVCaptureVideoDataOutput *_captureOutput = [[AVCaptureVideoDataOutput alloc]init];
    _captureOutput.alwaysDiscardsLateVideoFrames = YES;
    
    dispatch_queue_t queue = dispatch_queue_create("cameraQueueVideo", NULL);
    
    [_captureOutput setSampleBufferDelegate:self queue:queue];
    
    NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
    NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
    
    [_captureOutput setVideoSettings:videoSettings];
    
    return _captureOutput;
}

- (AVCaptureAudioDataOutput *)captureOutputAudio {
    AVCaptureAudioDataOutput *_captureOutput = [[AVCaptureAudioDataOutput alloc]init];
    
    dispatch_queue_t queue = dispatch_queue_create("cameraQueueAudio", NULL);
    [_captureOutput setSampleBufferDelegate:self queue:queue];
    
    return _captureOutput;
}

- (AVCaptureDeviceInput *)deviceInPutForTypeVideo:(BOOL)video {
    NSError *error = nil;
    AVMediaType mediaType = video ? AVMediaTypeVideo : AVMediaTypeAudio;
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:mediaType];
    if (video) {
        if ([device lockForConfiguration:nil]) {
            //设置帧率
            //            device.activeVideoMinFrameDuration = CMTimeMake(2, 3);
        }
    }
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    return deviceInput;;
}


#pragma mark -- Audio\Video delegate

- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    [self.delegate captureOutput:output didOutputSampleBuffer:sampleBuffer fromConnection:connection];
}

/** 将sampleBuffer读取到图片 */
- (UIImage *)readSampleBufferVideoToImage:(CMSampleBufferRef) sampleBuffer {
    
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef newContext = CGBitmapContextCreate(baseAddress,
                                                    width, height, 8, bytesPerRow, colorSpace,
                                                    kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGImageRef newImage = CGBitmapContextCreateImage(newContext);
    
    CGContextRelease(newContext);
    CGColorSpaceRelease(colorSpace);
    
    //由于这段代码中，设备是home在下进行录制，所以此处在生成image时，指定了方向
    UIImage *image = [UIImage imageWithCGImage:newImage scale:1.0 orientation:UIImageOrientationRight];
    
    CGImageRelease(newImage);
    
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    return image;
}


#pragma mark -- fun
- (void)setVideoPreview:(UIView *)view {
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.captureSession];
    previewLayer.frame = view.bounds;
    _previewLayer = previewLayer;
    
    [view.layer addSublayer:previewLayer];
}

- (void)startSession {
    if ([self.captureSession isRunning]) {
        return;
    }
    [self.captureSession startRunning];
}

- (void)stopSession {
    if ([self.captureSession isRunning]) {
        [self.captureSession stopRunning];
    }
}


- (void)testVC {
    AVCaptureDevice *de = nil;
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        
    }];
}
@end
