//
//  HMediaTool.m
//  TSS
//
//  Created by Chenfy on 2021/1/21.
//  Copyright © 2021 Chenfy. All rights reserved.
//

/**** 参考block  *******
 * https://blog.csdn.net/xiaolinyeyi/article/details/50878996
 * https://www.cnblogs.com/samirchen/p/7074270.html
 *
 * Auth：loyinglin
 * https://github.com.cnpmjs.org/loyinglin/LearnAVFoundation.git
 * https://github.com.cnpmjs.org/loyinglin/LearnVideoToolBox.git
 ****/



#import "HMediaTool.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

#define MediaFileName @"MixVideo.MOV"

@interface HMediaTool ()
{
    CADisplayLink* dlink;
    
    ///AVFoundation
    AVAsset * videoAsset;
    AVAssetExportSession *exporter;
}
@end

@implementation HMediaTool

#pragma mark -- 1、self

+ (void)mergeAudio:(NSURL *)audioPATH video:(NSURL *)videoPATH output:(NSURL *)output complete:(void (^)(BOOL, NSURL * _Nonnull))complete {
    //转换 audio、video 地址
    //    NSURL *audioURL = [NSURL fileURLWithPath:audioPATH];
    //    NSURL *videoURL = [NSURL fileURLWithPath:videoPATH];
    
    NSURL *audioURL = audioPATH;
    NSURL *videoURL = videoPATH;
    
    //获取 audio、video track
    AVURLAsset *assetAudio = [[AVURLAsset alloc]initWithURL:audioURL options:nil];
    AVAssetTrack *trackAudio = [[assetAudio tracksWithMediaType:AVMediaTypeAudio]lastObject];
    
    AVURLAsset *assetVideo = [[AVURLAsset alloc]initWithURL:videoURL options:nil];
    AVAssetTrack *trackVideo = [[assetVideo tracksWithMediaType:AVMediaTypeVideo]lastObject];
    
    CMTime ctime;
    if (CMTimeGetSeconds(assetAudio.duration) >= CMTimeGetSeconds(assetVideo.duration)) {
        ctime = assetVideo.duration;
    } else {
        ctime = assetAudio.duration;
    }
    
    NSError *error;
    CMTimeRange mix_timeRange = CMTimeRangeMake(kCMTimeZero, ctime);
    
    //音视频合成
    AVMutableComposition *mixComposition = [AVMutableComposition composition];
    
    AVMutableCompositionTrack *compAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *compVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    [compAudioTrack insertTimeRange:mix_timeRange ofTrack:trackAudio atTime:kCMTimeZero error:&error];
    if(error)
    {
        NSLog(@"Ups. Something went wrong! %@", [error debugDescription]);
    }

    [compVideoTrack insertTimeRange:mix_timeRange ofTrack:trackVideo atTime:kCMTimeZero error:&error];
    if(error)
    {
        NSLog(@"Ups. Something went wrong! %@", [error debugDescription]);
    }

    NSURL *outURL = output;
    
    AVAssetExportSession *assetExport = [[AVAssetExportSession alloc]initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    assetExport.outputURL = outURL;
    assetExport.shouldOptimizeForNetworkUse = YES;
    assetExport.outputFileType = AVFileTypeQuickTimeMovie;
    
    CMTimeValue val = mixComposition.duration.value;
    
    CMTime start=CMTimeMake(0, 600);
    CMTime duration=CMTimeMake(val, 600);
    CMTimeRange range=CMTimeRangeMake(start, duration);
    assetExport.timeRange=range;
    
    [assetExport exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            //在系统相册存储一份
            UISaveVideoAtPathToSavedPhotosAlbum([outURL path], nil, nil, nil);
            
            AVAssetExportSessionStatus status = [assetExport status];
            NSLog(@"Export status: AVAssetExportSessionStatus---%ld--",(long)status);
            NSLog(@"Export path: AVAssetExportSessionStatus----%@---",outURL);

            BOOL success = status == AVAssetExportSessionStatusCompleted ? YES : NO;
            if (complete) {
                complete(success,output);
            }
        });
    }];
}




#pragma mark -- 2、network

 
+ (void)addBackgroundMiusicWithVideoUrlStr:(NSURL *)videoUrl
                                  audioUrl:(NSURL *)audioUrl
                                     start:(CGFloat)startTime
                                       end:(CGFloat)endTime
                                 isOrignalSound:(BOOL)isOrignal
                                completion:(void (^)(NSString *outPath,BOOL isSuccess))completionHandle
{
    //声音来源路径（最终混合的音频）
    NSURL   *audio_inputFileUrl = audioUrl;
    
    //视频来源路径
    NSURL   *video_inputFileUrl = videoUrl;
    
    NSString *outputFilePath = [HMediaTool fileSavePath];
    NSURL   *outputFileUrl = [NSURL fileURLWithPath:outputFilePath];
    
    
    CMTime nextClipStartTime = kCMTimeZero;
    
    //创建可变的音频视频组合
    AVMutableComposition* mixComposition =[AVMutableComposition composition];
    
    //视频采集
    AVURLAsset* videoAsset =[[AVURLAsset alloc]initWithURL:video_inputFileUrl options:nil];
    CMTimeRange video_timeRange = CMTimeRangeMake(kCMTimeZero,videoAsset.duration);
    AVMutableCompositionTrack*a_compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                                    preferredTrackID:kCMPersistentTrackID_Invalid];
    [a_compositionVideoTrack insertTimeRange:video_timeRange
                                     ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                                      atTime:nextClipStartTime
                                       error:nil];
    
    
    CMTime start = CMTimeMakeWithSeconds(startTime, videoAsset.duration.timescale);
    CMTime duration = CMTimeMakeWithSeconds(endTime - startTime,videoAsset.duration.timescale);
    CMTimeRange audio_timeRange = CMTimeRangeMake(start, duration);
    
    
    if (isOrignal) {
        //视频声音采集(也可不执行这段代码不采集视频音轨，合并后的视频文件将没有视频原来的声音)
        CMTimeRange videoTimeRange = CMTimeRangeMake(kCMTimeZero,videoAsset.duration);
        AVMutableCompositionTrack *compositionVoiceTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        
        [compositionVoiceTrack insertTimeRange:videoTimeRange ofTrack:([videoAsset tracksWithMediaType:AVMediaTypeAudio].count>0)?[videoAsset tracksWithMediaType:AVMediaTypeAudio].firstObject:nil atTime:kCMTimeZero error:nil];
    }
    //音乐声音采集
    AVURLAsset* audioAsset =[[AVURLAsset alloc]initWithURL:audio_inputFileUrl options:nil];
    //CMTimeRange audio_timeRange = CMTimeRangeMake(kCMTimeZero,videoAsset.duration);//声音长度截取范围==视频长度
    AVMutableCompositionTrack*b_compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                                    preferredTrackID:kCMPersistentTrackID_Invalid];
    //3秒到8秒 则atTime从3秒开始
    [b_compositionAudioTrack insertTimeRange:audio_timeRange
                                     ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio]objectAtIndex:0]
                                      atTime:start
                                       error:nil];
    
    //创建一个输出
    AVAssetExportSession* _assetExport =[[AVAssetExportSession alloc]initWithAsset:mixComposition presetName:AVAssetExportPresetMediumQuality];
    _assetExport.outputFileType = AVFileTypeQuickTimeMovie;
    _assetExport.outputURL = outputFileUrl;
    _assetExport.shouldOptimizeForNetworkUse= YES;
    
    [_assetExport exportAsynchronouslyWithCompletionHandler:
     ^(void ) {
         switch ([_assetExport status]) {
             case AVAssetExportSessionStatusFailed: {
                 NSLog(@"合成失败：%@",[[_assetExport error] description]);
                 completionHandle(outputFilePath,NO);
             } break;
             case AVAssetExportSessionStatusCancelled: {
                 completionHandle(outputFilePath,NO);
             } break;
             case AVAssetExportSessionStatusCompleted: {
                 completionHandle(outputFilePath,YES);
             } break;
             default: {
                 completionHandle(outputFilePath,NO);
             } break;
         }
         
     }
     ];
}

 
+ (void)cropWithVideoUrlStr:(NSURL *)videoUrl
                   audioUrl:(NSURL *)audioUrl
                      start:(CGFloat)startTime
                        end:(CGFloat)endTime
             isOrignalSound:(BOOL)isOrignal
                 completion:(void (^)(NSString *outPath,BOOL isSuccess))completionHandle
{
    NSURL   *audio_inputFileUrl = audioUrl;
    
    //视频来源路径
    NSURL   *video_inputFileUrl = videoUrl;
    
    NSString *outputFilePath = [HMediaTool fileSavePath];
    NSURL   *outputFileUrl = [NSURL fileURLWithPath:outputFilePath];
    
    AVURLAsset* videoAsset =[[AVURLAsset alloc]initWithURL:video_inputFileUrl options:nil];
    
    
    CMTime nextClipStartTime = kCMTimeZero;
    
    //创建可变的音频视频组合
    AVMutableComposition* mixComposition =[AVMutableComposition composition];
    
    //视频采集
    CMTimeRange video_timeRange = CMTimeRangeMake(kCMTimeZero,videoAsset.duration);
    AVMutableCompositionTrack*a_compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                                    preferredTrackID:kCMPersistentTrackID_Invalid];
    [a_compositionVideoTrack insertTimeRange:video_timeRange
                                     ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                                      atTime:nextClipStartTime
                                       error:nil];
    
    
    CMTime start = CMTimeMakeWithSeconds(startTime, videoAsset.duration.timescale);
    CMTime duration = CMTimeMakeWithSeconds(endTime - startTime,videoAsset.duration.timescale);
    CMTimeRange audio_timeRange = CMTimeRangeMake(start, duration);
    
    
    if (isOrignal) {
        //视频声音采集(也可不执行这段代码不采集视频音轨，合并后的视频文件将没有视频原来的声音)
        CMTimeRange videoTimeRange = CMTimeRangeMake(kCMTimeZero,videoAsset.duration);
        AVMutableCompositionTrack *compositionVoiceTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        
        [compositionVoiceTrack insertTimeRange:videoTimeRange ofTrack:([videoAsset tracksWithMediaType:AVMediaTypeAudio].count>0)?[videoAsset tracksWithMediaType:AVMediaTypeAudio].firstObject:nil atTime:kCMTimeZero error:nil];
    }
    
    //音乐声音采集
    AVURLAsset* audioAsset =[[AVURLAsset alloc]initWithURL:audio_inputFileUrl options:nil];
    //CMTimeRange audio_timeRange = CMTimeRangeMake(kCMTimeZero,videoAsset.duration);//声音长度截取范围==视频长度
    AVMutableCompositionTrack*b_compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                                    preferredTrackID:kCMPersistentTrackID_Invalid];
    //3秒到8秒 则atTime从3秒开始
    [b_compositionAudioTrack insertTimeRange:audio_timeRange
                                     ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio]objectAtIndex:0]
                                      atTime:start
                                       error:nil];
 
 
    
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:videoAsset];
    if ([compatiblePresets containsObject:AVAssetExportPresetMediumQuality]) {
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]
                                               initWithAsset:videoAsset presetName:AVAssetExportPresetPassthrough];
        NSURL *furl = outputFileUrl;
        
        exportSession.outputURL = furl;
        exportSession.outputFileType = AVFileTypeQuickTimeMovie;
        exportSession.shouldOptimizeForNetworkUse= YES;
        
        //剪辑视频片段 设置timeRange
        CMTime start = CMTimeMakeWithSeconds(startTime, videoAsset.duration.timescale);
        CMTime duration = CMTimeMakeWithSeconds(endTime - startTime,videoAsset.duration.timescale);
        CMTimeRange range = CMTimeRangeMake(start, duration);
        exportSession.timeRange = range;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:
         ^(void ) {
             switch ([exportSession status]) {
                 case AVAssetExportSessionStatusFailed: {
                     NSLog(@"合成失败：%@",[[exportSession error] description]);
                     completionHandle(outputFilePath,NO);
                 } break;
                 case AVAssetExportSessionStatusCancelled: {
                     completionHandle(outputFilePath,NO);
                 } break;
                 case AVAssetExportSessionStatusCompleted: {
                     completionHandle(outputFilePath,YES);
                 } break;
                 default: {
                     completionHandle(outputFilePath,NO);
                 } break;
             }
             
         }
         ];
    }
}
 
+ (CGFloat)getMediaDurationWithMediaUrl:(NSString *)mediaUrlStr {
    
    NSURL *mediaUrl = [NSURL URLWithString:mediaUrlStr];
    AVURLAsset *mediaAsset = [[AVURLAsset alloc] initWithURL:mediaUrl options:nil];
    CMTime duration = mediaAsset.duration;
    
    return duration.value / duration.timescale;
}
 
+ (NSString *)getMediaFilePath {
    
    return [NSTemporaryDirectory() stringByAppendingPathComponent:MediaFileName];
    
}
 
+ (NSString *)fileSavePath
{
    NSDate *date = [NSDate date];
    NSInteger nowInter = (long)[date timeIntervalSince1970];
    NSString *fileName = [NSString stringWithFormat:@"output%ld.mp4",(long)nowInter];
    
    NSString *documentsDirectory =[NSHomeDirectory()
                                   stringByAppendingPathComponent:@"Documents"];
    //最终合成输出路径
    NSString *outputFilePath =[documentsDirectory stringByAppendingPathComponent:fileName];
    // NSURL   *outputFileUrl = [NSURL fileURLWithPath:outputFilePath];
    
    if([[NSFileManager defaultManager]fileExistsAtPath:outputFilePath])
        [[NSFileManager defaultManager]removeItemAtPath:outputFilePath error:nil];
    return outputFilePath;
}
 
 

#pragma mark -- 3、iOS视频裁剪、拼接、添加水印、添加背景音乐

///使用AVfoundation添加水印
- (void)AVsaveVideoPath:(NSURL*)videoPath WithWaterImg:(UIImage*)img WithInfoDic:(NSDictionary*)infoDic WithFileName:(NSString*)fileName completion:(void (^)(NSURL *outputURL, BOOL isSuccess))completionHandle
{
    if (!videoPath) {
        return;
    }
    
    //1 创建AVAsset实例 AVAsset包含了video的所有信息 self.videoUrl输入视频的路径
    
    //封面图片
    NSDictionary *opts = [NSDictionary dictionaryWithObject:@(YES) forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    videoAsset = [AVURLAsset URLAssetWithURL:videoPath options:opts];     //初始化视频媒体文件
    
    CMTime startTime = CMTimeMakeWithSeconds(0.2, 600);
    CMTime endTime = CMTimeMakeWithSeconds(videoAsset.duration.value/videoAsset.duration.timescale-0.2, videoAsset.duration.timescale);
    
    //声音采集
    AVURLAsset * audioAsset = [[AVURLAsset alloc] initWithURL:videoPath options:opts];
    
    //2 创建AVMutableComposition实例. apple developer 里边的解释 【AVMutableComposition is a mutable subclass of AVComposition you use when you want to create a new composition from existing assets. You can add and remove tracks, and you can add, remove, and scale time ranges.】
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    
    //3 视频通道  工程文件中的轨道，有音频轨、视频轨等，里面可以插入各种对应的素材
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    //把视频轨道数据加入到可变轨道中 这部分可以做视频裁剪TimeRange
    [videoTrack insertTimeRange:CMTimeRangeFromTimeToTime(startTime, endTime)
                        ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                         atTime:kCMTimeZero error:nil];
    //音频通道
    AVMutableCompositionTrack * audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    //音频采集通道
    AVAssetTrack * audioAssetTrack = [[audioAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
    [audioTrack insertTimeRange:CMTimeRangeFromTimeToTime(startTime, endTime) ofTrack:audioAssetTrack atTime:kCMTimeZero error:nil];
    
    //3.1 AVMutableVideoCompositionInstruction 视频轨道中的一个视频，可以缩放、旋转等
    AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruction.timeRange = CMTimeRangeFromTimeToTime(kCMTimeZero, videoTrack.timeRange.duration);
    
    // 3.2 AVMutableVideoCompositionLayerInstruction 一个视频轨道，包含了这个轨道上的所有视频素材
    AVMutableVideoCompositionLayerInstruction *videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    AVAssetTrack *videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    //    UIImageOrientation videoAssetOrientation_  = UIImageOrientationUp;
    BOOL isVideoAssetPortrait_  = NO;
    CGAffineTransform videoTransform = videoAssetTrack.preferredTransform;
    if (videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0) {
        //        videoAssetOrientation_ = UIImageOrientationRight;
        isVideoAssetPortrait_ = YES;
    }
    if (videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0) {
        //        videoAssetOrientation_ =  UIImageOrientationLeft;
        isVideoAssetPortrait_ = YES;
    }
    //    if (videoTransform.a == 1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == 1.0) {
    //        videoAssetOrientation_ =  UIImageOrientationUp;
    //    }
    //    if (videoTransform.a == -1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == -1.0) {
    //        videoAssetOrientation_ = UIImageOrientationDown;
    //    }
    [videolayerInstruction setTransform:videoAssetTrack.preferredTransform atTime:kCMTimeZero];
    [videolayerInstruction setOpacity:0.0 atTime:endTime];
    // 3.3 - Add instructions
    mainInstruction.layerInstructions = [NSArray arrayWithObjects:videolayerInstruction,nil];
    //AVMutableVideoComposition：管理所有视频轨道，可以决定最终视频的尺寸，裁剪需要在这里进行
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
    
    CGSize naturalSize;
    if(isVideoAssetPortrait_){
        naturalSize = CGSizeMake(videoAssetTrack.naturalSize.height, videoAssetTrack.naturalSize.width);
    } else {
        naturalSize = videoAssetTrack.naturalSize;
    }
    
    float renderWidth, renderHeight;
    renderWidth = naturalSize.width;
    renderHeight = naturalSize.height;
    mainCompositionInst.renderSize = CGSizeMake(renderWidth, renderHeight);
    mainCompositionInst.renderSize = CGSizeMake(renderWidth, renderHeight);
    mainCompositionInst.instructions = [NSArray arrayWithObject:mainInstruction];
    mainCompositionInst.frameDuration = CMTimeMake(1, 25);
    
    //shuiyin
    //[self applyVideoEffectsToComposition:mainCompositionInst WithWaterImg:img WithCoverImage:coverImg WithQustion:question size:CGSizeMake(renderWidth, renderHeight)];
    
    //by yangyunfei
    [self applyVideoEffectsToComposition:mainCompositionInst WithWaterImg:img WithInfoDic:infoDic size:CGSizeMake(renderWidth, renderHeight)];
        
//    //UI操作放到主线程执行
//    dispatch_async(dispatch_get_main_queue(), ^{
//
//        [self applyVideoEffectsToComposition:mainCompositionInst WithWaterImg:img WithCoverImage:coverImg WithQustion:question size:CGSizeMake(renderWidth, renderHeight)];
//
//    });
    
    // 4 - 输出路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:
                             [NSString stringWithFormat:@"%@-%d.mov",fileName,arc4random() % 1000]];
//    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mov",fileName]];
    unlink([myPathDocs UTF8String]);
    
    //如果文件已经存在，先移除，否则会报无法存储的错误
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager removeItemAtPath:myPathDocs error:nil];
    
    NSURL* videoUrl = [NSURL fileURLWithPath:myPathDocs];
    
    dlink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateProgress)];
    [dlink setFrameInterval:15];
    [dlink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [dlink setPaused:NO];
    
    // 5 - 视频文件输出
    exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL=videoUrl;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    exporter.videoComposition = mainCompositionInst;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            //这里是输出视频之后的操作，做你想做的
//            [self exportDidFinish:exporter];
//        });
        switch ([exporter status]) {
            case AVAssetExportSessionStatusFailed:
            {
                NSLog(@"添加水印失败：%@", [[exporter error] description]);
                completionHandle(videoUrl, NO);
            }
                break;
            case AVAssetExportSessionStatusCancelled:
            {
                completionHandle(videoUrl, NO);
            }
                break;
            case AVAssetExportSessionStatusCompleted:
            {
                //成功
                NSLog(@"添加水印成功");
                completionHandle(videoUrl, YES);
                
            }
                break;
            default:
            {
                completionHandle(videoUrl, NO);
            } break;
        }
    }];
    
}
 
//添加水印
- (void)applyVideoEffectsToComposition:(AVMutableVideoComposition *)composition WithWaterImg:(UIImage*)img WithCoverImage:(UIImage*)coverImg WithQustion:(NSString*)question  size:(CGSize)size {
    
    UIFont *font = [UIFont systemFontOfSize:30.0];
    CATextLayer *subtitle1Text = [[CATextLayer alloc] init];
    [subtitle1Text setFontSize:30];
    [subtitle1Text setString:question];
    [subtitle1Text setAlignmentMode:kCAAlignmentCenter];
    [subtitle1Text setForegroundColor:[[UIColor whiteColor] CGColor]];
    subtitle1Text.masksToBounds = YES;
    subtitle1Text.cornerRadius = 23.0f;
    [subtitle1Text setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor];
    CGSize textSize = [question sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    [subtitle1Text setFrame:CGRectMake(50, 100, textSize.width+20, textSize.height+10)];
    
    //水印
    CALayer *imgLayer = [CALayer layer];
    imgLayer.contents = (id)img.CGImage;
    //    imgLayer.bounds = CGRectMake(0, 0, size.width, size.height);
    imgLayer.bounds = CGRectMake(0, 0, 210, 50);
    imgLayer.position = CGPointMake(size.width/2.0, size.height/2.0);
    
    //第二个水印
    CALayer *coverImgLayer = [CALayer layer];
    coverImgLayer.contents = (id)coverImg.CGImage;
    //    [coverImgLayer setContentsGravity:@"resizeAspect"];
    coverImgLayer.bounds =  CGRectMake(50, 200,210, 50);
    coverImgLayer.position = CGPointMake(size.width/4.0, size.height/4.0);
    
    // 2 - The usual overlay
    CALayer *overlayLayer = [CALayer layer];
    [overlayLayer addSublayer:subtitle1Text];
    [overlayLayer addSublayer:imgLayer];
    overlayLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [overlayLayer setMasksToBounds:YES];
    
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, size.width, size.height);
    videoLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:overlayLayer];
    [parentLayer addSublayer:coverImgLayer];
    
    //设置封面
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anima.fromValue = [NSNumber numberWithFloat:1.0f];
    anima.toValue = [NSNumber numberWithFloat:0.0f];
    anima.repeatCount = 0;
    anima.duration = 5.0f;  //5s之后消失
    [anima setRemovedOnCompletion:NO];
    [anima setFillMode:kCAFillModeForwards];
    anima.beginTime = AVCoreAnimationBeginTimeAtZero;
    [coverImgLayer addAnimation:anima forKey:@"opacityAniamtion"];
    
    composition.animationTool = [AVVideoCompositionCoreAnimationTool
                                 videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
}
 
//添加水印
- (void)applyVideoEffectsToComposition:(AVMutableVideoComposition *)composition WithWaterImg:(UIImage*)img  WithInfoDic:(NSDictionary*)infoDic  size:(CGSize)size {
    
    CGFloat fontSize = 46.0;
    CGFloat leftLength = 60;
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    CATextLayer *nameText = [[CATextLayer alloc] init];
    [nameText setFontSize:fontSize];
    [nameText setString:[infoDic objectForKey:@"name"]];
    [nameText setAlignmentMode:kCAAlignmentLeft];
    [nameText setForegroundColor:[[UIColor whiteColor] CGColor]];
    CGSize textSize = [[infoDic objectForKey:@"name"] sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    [nameText setFrame:CGRectMake(leftLength, size.height/2.0 +textSize.height/2.0 +(28+textSize.height)*2, textSize.width+10, textSize.height+10)];
    
    CATextLayer *shengaoText = [[CATextLayer alloc] init];
    [shengaoText setFontSize:fontSize];
    NSString *text3 =  [NSString stringWithFormat:@"%@cm",[infoDic objectForKey:@"shengao"]];
    [shengaoText setString:text3];
    [shengaoText setAlignmentMode:kCAAlignmentLeft];
    [shengaoText setForegroundColor:[[UIColor whiteColor] CGColor]];
    CGSize textSize3 = [text3 sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    [shengaoText setFrame:CGRectMake(leftLength, size.height/2.0 +textSize3.height/2.0 +28+textSize3.height, textSize3.width+10, textSize3.height+10)];
 
    CATextLayer *tizhongText = [[CATextLayer alloc] init];
    [tizhongText setFontSize:fontSize];
    NSString *text2 =  [NSString stringWithFormat:@"%@kg",[infoDic objectForKey:@"tizhong"]];
    [tizhongText setString:text2];
    [tizhongText setAlignmentMode:kCAAlignmentLeft];
    [tizhongText setForegroundColor:[[UIColor whiteColor] CGColor]];
    CGSize textSize2 = [text2 sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    [tizhongText setFrame:CGRectMake(leftLength, size.height/2.0 +textSize2.height/2.0, textSize2.width+10, textSize2.height+10)];
    
    CATextLayer *sanText = [[CATextLayer alloc] init];
    [sanText setFontSize:fontSize];
    NSString *text4 =  [NSString stringWithFormat:@"%@-%@-%@",[infoDic objectForKey:@"xiongwei"],[infoDic objectForKey:@"yaowei"],[infoDic objectForKey:@"tunwei"]];
    [sanText setString:text4];
    [sanText setAlignmentMode:kCAAlignmentLeft];
    [sanText setForegroundColor:[[UIColor whiteColor] CGColor]];
    CGSize textSize4 = [text4 sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    [sanText setFrame:CGRectMake(leftLength, size.height/2.0 -textSize4.height/2.0 -28, textSize4.width+10, textSize4.height+10)];
 
    CATextLayer *xiemaText = [[CATextLayer alloc] init];
    [xiemaText setFontSize:fontSize];
    NSString *text5 =  [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"xiema"]];
    [xiemaText setString:text5];
    [xiemaText setAlignmentMode:kCAAlignmentLeft];
    [xiemaText setForegroundColor:[[UIColor whiteColor] CGColor]];
    CGSize textSize5 = [text5 sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    [xiemaText setFrame:CGRectMake(leftLength, size.height/2.0 -textSize4.height/2.0 -28 -textSize4.height-28, textSize5.width+10, textSize5.height+10)];
 
 
    //水印
    CALayer *imgLayer = [CALayer layer];
    imgLayer.contents = (id)img.CGImage;
    imgLayer.bounds = CGRectMake(0, 0, img.size.width, img.size.height);
    imgLayer.position = CGPointMake(size.width - img.size.width, img.size.height+10);
    
    // 2 - The usual overlay
    CALayer *overlayLayer = [CALayer layer];
    [overlayLayer addSublayer:nameText];
    [overlayLayer addSublayer:shengaoText];
    [overlayLayer addSublayer:tizhongText];
    [overlayLayer addSublayer:sanText];
    [overlayLayer addSublayer:xiemaText];
    [overlayLayer addSublayer:imgLayer];
    overlayLayer.frame = CGRectMake(0, 0, size.width, size.height);
    
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, size.width, size.height);
    videoLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:overlayLayer];
    
    //设置动画
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anima.fromValue = [NSNumber numberWithFloat:0.0f];
    anima.toValue = [NSNumber numberWithFloat:1.0f];
    anima.repeatCount = 0;
    anima.duration = 3.0f;  //5s之后消失
    [anima setRemovedOnCompletion:NO];
    [anima setFillMode:kCAFillModeForwards];
    anima.beginTime = AVCoreAnimationBeginTimeAtZero;
    [overlayLayer addAnimation:anima forKey:@"opacityAniamtion"];
    
    composition.animationTool = [AVVideoCompositionCoreAnimationTool
                                 videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    
}
 
//保存视频到相册
- (void)exportDidFinish:(AVAssetExportSession*)session {
    if (session.status == AVAssetExportSessionStatusCompleted) {
        NSURL *outputURL = session.outputURL;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __block PHObjectPlaceholder *placeholder;
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(outputURL.path)) {
                NSError *error;
                [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                    PHAssetChangeRequest* createAssetRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:outputURL];
                    placeholder = [createAssetRequest placeholderForCreatedAsset];
                } error:&error];
                if (error) {
                    //[SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error]];
                }
                else{
                    //[SVProgressHUD showSuccessWithStatus:@"视频已经保存到相册"];
                }
            }else {
                //[SVProgressHUD showErrorWithStatus:NSLocalizedString(@"视频保存相册失败，请设置软件读取相册权限", nil)];
            }
        });
    }
}
 
//视频合成，添加背景音乐
-(void)addFirstVideo:(NSURL*)firstVideoPath andSecondVideo:(NSURL*)secondVideo withMusic:(NSURL*)musicPath completion:(void (^)(NSURL *outputURL, BOOL isSuccess))completionHandle{
    
    AVAsset *firstAsset = [AVAsset assetWithURL:firstVideoPath];
    AVAsset *secondAsset = [AVAsset assetWithURL:secondVideo];
    AVAsset *musciAsset = [AVAsset assetWithURL:musicPath];
    
    // 1 - Create AVMutableComposition object. This object will hold your AVMutableCompositionTrack instances.
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    // 2 - Video track
    AVMutableCompositionTrack *firstTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    [firstTrack insertTimeRange:CMTimeRangeFromTimeToTime(kCMTimeZero, firstAsset.duration)
                        ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    [firstTrack insertTimeRange:CMTimeRangeFromTimeToTime(kCMTimeZero, secondAsset.duration)
                        ofTrack:[[secondAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:firstAsset.duration error:nil];
    
    
    if (musciAsset!=nil){//添加背景音乐
        AVMutableCompositionTrack *AudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                            preferredTrackID:kCMPersistentTrackID_Invalid];
        [AudioTrack insertTimeRange:CMTimeRangeFromTimeToTime(kCMTimeZero, CMTimeAdd(firstAsset.duration, secondAsset.duration))
                            ofTrack:[[musciAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    }else{//不添加背景音乐
#pragma 注意这里需要加上音频轨道信息，否则合成的视频没有声音
       //添加 by yang
        AVMutableCompositionTrack *AudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                            preferredTrackID:kCMPersistentTrackID_Invalid];
        [AudioTrack insertTimeRange:CMTimeRangeFromTimeToTime(kCMTimeZero, firstAsset.duration)
                            ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
        [AudioTrack insertTimeRange:CMTimeRangeFromTimeToTime(kCMTimeZero, secondAsset.duration)
                            ofTrack:[[secondAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:firstAsset.duration error:nil];
    }
    
    
    // 4 - Get path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:
                             [NSString stringWithFormat:@"mergeVideo-%d.mov",arc4random() % 1000]];
//    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:
//                             [NSString stringWithFormat:@"%@.mov",@"combinVideo"]];
    //如果文件已经存在，先移除，否则会报无法存储的错误
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager removeItemAtPath:myPathDocs error:nil];
    
    NSURL *videoUrl = [NSURL fileURLWithPath:myPathDocs];
    
    // 5 - Create exporter
    exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL=videoUrl;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self exportDidFinish:exporter];
//        });
        switch ([exporter status]) {
            case AVAssetExportSessionStatusFailed:
            {
                NSLog(@"视频拼接失败：%@", [[exporter error] description]);
                completionHandle(videoUrl, NO);
            }
                break;
            case AVAssetExportSessionStatusCancelled:
            {
                completionHandle(videoUrl, NO);
            }
                break;
            case AVAssetExportSessionStatusCompleted:
            {
                //成功
                NSLog(@"视频拼接成功");
                completionHandle(videoUrl, YES);
                
            }
                break;
            default:
            {
                completionHandle(videoUrl, NO);
            } break;
        }
 
    }];
}
 
//视频裁剪
- (void)cropWithVideoUrlStr:(NSURL *)videoUrl start:(CGFloat)startTime end:(CGFloat)endTime completion:(void (^)(NSURL *outputURL, Float64 videoDuration, BOOL isSuccess))completionHandle
{
    AVURLAsset *asset =[[AVURLAsset alloc] initWithURL:videoUrl options:nil];
    
    //获取视频总时长
    Float64 duration = CMTimeGetSeconds(asset.duration);
    
    //NSString *outputPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"dafei.mov"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *outputPath =  [documentsDirectory stringByAppendingPathComponent:
                             [NSString stringWithFormat:@"dafei-%d.mov",arc4random() % 1000]];
 
    
    NSURL *outputURL = [NSURL fileURLWithPath:outputPath];
    
    //如果文件已经存在，先移除，否则会报无法存储的错误
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager removeItemAtPath:outputPath error:nil];
    
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:asset];
    if ([compatiblePresets containsObject:AVAssetExportPresetMediumQuality])
    {
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]
                                               initWithAsset:asset presetName:AVAssetExportPresetPassthrough];
        
        exportSession.outputURL =  outputURL;
        //视频文件的类型
        exportSession.outputFileType = AVFileTypeQuickTimeMovie;
        //输出文件是否网络优化
        exportSession.shouldOptimizeForNetworkUse = YES;
        
        //要截取的开始时间
        CMTime start = CMTimeMakeWithSeconds(startTime, asset.duration.timescale);
        //要截取的总时长
        CMTime duration = CMTimeMakeWithSeconds(endTime - startTime,asset.duration.timescale);
        CMTimeRange range = CMTimeRangeMake(start, duration);
        exportSession.timeRange = range;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed:
                {
                    NSLog(@"合成失败：%@", [[exportSession error] description]);
                    completionHandle(outputURL, endTime, NO);
                }
                    break;
                case AVAssetExportSessionStatusCancelled:
                {
                    completionHandle(outputURL, endTime, NO);
                }
                    break;
                case AVAssetExportSessionStatusCompleted:
                {
                    //成功
                    completionHandle(outputURL, endTime, YES);
                    
                }
                    break;
                default:
                {
                    completionHandle(outputURL, endTime, NO);
                } break;
            }
        }];
    }
}
 
//展示进度
- (void)updateProgress{
    
}



@end
