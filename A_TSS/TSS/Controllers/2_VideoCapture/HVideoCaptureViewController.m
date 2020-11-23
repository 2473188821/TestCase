//
//  HVideoCaptureViewController.m
//  TSS
//
//  Created by Chenfy on 2020/11/23.
//  Copyright © 2020 Chenfy. All rights reserved.
//

#import "HVideoCaptureViewController.h"

#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#import "HSLiveSession.h"


@interface HVideoCaptureViewController ()<HSLiveSessionDelegate>

//media video
@property(nonatomic,strong)HSLiveSession *session;
@property(nonatomic,strong)UIImageView *imageV;
@property(nonatomic,strong)MPVolumeView *volumeView;

@end

@implementation HVideoCaptureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self testHSLiveSession];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIImageView *)imageV {
    if (!_imageV) {
        _imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
        _imageV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageV;
}


#pragma mark -- Media Test

- (void)enableAirplay {
    UIImage *airplayImage = [UIImage imageNamed:@"airplay"];
    self.volumeView = [[MPVolumeView alloc] initWithFrame:CGRectZero];
    self.volumeView.showsVolumeSlider = NO;
    self.volumeView.showsRouteButton = YES;
    [self.volumeView setRouteButtonImage:airplayImage forState:UIControlStateNormal];

    [self.volumeView sizeToFit];
    // 只需要展示这个Item即可
    
    [self.view addSubview:self.volumeView];
}

- (void)testHSLiveSession {
    [self.session setupAVCapture];
    [self.session setVideoPreview:self.view];
    [self.session startSession];
        
    [self.view addSubview:self.imageV];
}

- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    if ([output isKindOfClass:[AVCaptureVideoDataOutput class]]) {
        NSLog(@"OutPut  Video ++++++++++++++++++++++++");
        UIImage *img = [self.session readSampleBufferVideoToImage:sampleBuffer];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageV.image = img;
        });
    }
    if ([output isKindOfClass:[AVCaptureAudioDataOutput class]]) {
        NSLog(@"OutPut   Audio ----------------------");
    }
    
    
}
#pragma mark -- session
- (HSLiveSession *)session {
    if (!_session) {
        _session = [[HSLiveSession alloc]init];
        _session.delegate = self;
    }
    return _session;
}


@end
