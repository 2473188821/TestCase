//
//  HMediaTool.h
//  TSS
//
//  Created by Chenfy on 2021/1/21.
//  Copyright © 2021 Chenfy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMediaTool : NSObject

/** 视频添加音频 - 将音频、视频合并（原视频声音不会保留）*/
+ (void)mergeAudio:(NSURL *)audioPATH
             video:(NSURL *)videoPATH
            output:(NSURL *)output
          complete:(void(^)(BOOL result ,NSURL *path))complete;

/*!
 @method
 @brief  视频添加音频
 @discussion null
 @param videoUrl 视频URL
 @param audioUrl 音频URL
 @param startTime 音频插入开始时间
 @param endTime 音频插入结束时间
 @param isOrignal 是否保留原声
 @param completionHandle   完成回调
 */
+ (void)addBackgroundMiusicWithVideoUrlStr:(NSURL *)videoUrl
                                  audioUrl:(NSURL *)audioUrl
                                     start:(CGFloat)startTime
                                       end:(CGFloat)endTime
                            isOrignalSound:(BOOL)isOrignal
                                completion:(void (^)(NSString *outPath,BOOL isSuccess))completionHandle;
/*!
 @method
 @brief  剪辑视频
 @discussion null
 @param videoUrl 视频URL
 @param audioUrl 音频URL
 @param startTime 剪辑开始时间
 @param endTime 剪辑结束时间
 @param isOrignal 是否保留原声
 @param completionHandle   完成回调
 */
+ (void)cropWithVideoUrlStr:(NSURL *)videoUrl
                   audioUrl:(NSURL *)audioUrl
                      start:(CGFloat)startTime
                        end:(CGFloat)endTime
             isOrignalSound:(BOOL)isOrignal
                 completion:(void (^)(NSString *outPath,BOOL isSuccess))completionHandle;


///使用AVfoundation添加水印
- (void)AVsaveVideoPath:(NSURL*)videoPath WithWaterImg:(UIImage*)img WithInfoDic:(NSDictionary*)infoDic WithFileName:(NSString*)fileName completion:(void (^)(NSURL *outputURL, BOOL isSuccess))completionHandle;
 
//视频合成，添加背景音乐
-(void)addFirstVideo:(NSURL*)firstVideoPath andSecondVideo:(NSURL*)secondVideo withMusic:(NSURL*)musicPath completion:(void (^)(NSURL *outputURL, BOOL isSuccess))completionHandle;
 
//视频裁剪
- (void)cropWithVideoUrlStr:(NSURL *)videoUrl start:(CGFloat)startTime end:(CGFloat)endTime completion:(void (^)(NSURL *outputURL, Float64 videoDuration, BOOL isSuccess))completionHandle;


@end

NS_ASSUME_NONNULL_END
