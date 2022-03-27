//
//  KKPlayRecord.m
//  TSS
//
//  Created by Chenfy on 2021/1/15.
//  Copyright © 2021 Chenfy. All rights reserved.
//

#import "KKPlayRecord.h"
#import <AudioUnit/AudioUnit.h>
#import <AVFoundation/AVFoundation.h>

//const uint32_t PR_CONST_BUFFER_SIZE = 0x10000;

#define INPUT_BUS   1
#define OUTPUT_BUS  0

#define PR_CONST_BUFFER_SIZE 2048*2*10

@interface KKPlayRecord()
{
    AudioUnit audioUnit;
    AudioBufferList *bufferList;
    
    NSInputStream *inputStream;
    
    Byte *buffer;
}
@property(nonatomic,copy)NSString *address;

@end

@implementation KKPlayRecord

- (void)play:(NSString *)address {
    _address = address;
    if (!address) {
        NSLog(@"ERROR___address play nil!");
        return;
    }
    
    [self initPlayer];
    AudioOutputUnitStart(audioUnit);
}


- (void)initPlayer {
    NSString *address = self.address;
    NSURL *url = [NSURL fileURLWithPath:address];
    ///Users/chenfy/Library/Developer/CoreSimulator/Devices/AB4B4E0E-1D5A-4A76-9163-190EF7D38F2D/data/Containers/Bundle/Applic ... /441.pcm
    
    //    NSURL *url = [[NSBundle mainBundle] URLForResource:@"441" withExtension:@"pcm"];
    //file:///Users/chenfy/Library/Developer/CoreSimulator/Devices/AB4B4E0E-1D5A-4A76-9163-190EF7D38F2D/data/Containers/Bundle/Application/5504B0DD-7053-420A-BAC1-C46636BB20CD/TSS.app/441.pcm
    
    inputStream = [NSInputStream inputStreamWithURL:url];
    if (!inputStream) {
        NSLog(@"ERROR__打开文件失败 %@", url);
        return;
    } else {
        [inputStream open];
    }
    
    NSError *error = nil;
    OSStatus status;
    
    // set audio session
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    
    //设置硬件IO缓存持续时间 0.05秒
    [audioSession setPreferredIOBufferDuration:0.05 error:&error];
    
    // 给 buffer 开辟空间
    buffer = malloc(PR_CONST_BUFFER_SIZE);
    
    // 创建 AudioComponentDescription 
    AudioComponentDescription   audioDesc;
    audioDesc.componentType = kAudioUnitType_Output;
    audioDesc.componentSubType = kAudioUnitSubType_RemoteIO;
    audioDesc.componentManufacturer = kAudioUnitManufacturer_Apple;
    audioDesc.componentFlags = 0;
    audioDesc.componentFlagsMask = 0;
    
    // 创建 AudioComponent
    AudioComponent inputComponent = AudioComponentFindNext(NULL, &audioDesc);
    AudioComponentInstanceNew(inputComponent, &audioUnit);
     
    // bufferList
    UInt32 numberBuffers = 2;
    size_t bufferSize = sizeof(AudioBufferList) + (numberBuffers - 1) * sizeof(AudioBuffer);

    bufferList = (AudioBufferList *) malloc(bufferSize);
    bufferList->mNumberBuffers = numberBuffers;

    for (int i = 0 ; i < numberBuffers; i++) {
        bufferList->mBuffers[i].mNumberChannels = 1;
        bufferList->mBuffers[i].mDataByteSize = PR_CONST_BUFFER_SIZE;
        bufferList->mBuffers[i].mData = malloc(PR_CONST_BUFFER_SIZE);
    }
        
    buffer = malloc(PR_CONST_BUFFER_SIZE);

    // 设置输入输出格式
    //输入格式
    AudioStreamBasicDescription inputFormat;    
    inputFormat.mSampleRate = 44100; //采样率
    inputFormat.mFormatID = kAudioFormatLinearPCM; //PCM 格式
    inputFormat.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsNonInterleaved; //整形
    inputFormat.mFramesPerPacket = 1; // 每帧只有一个packet
    inputFormat.mChannelsPerFrame = 1; // 声道数
    inputFormat.mBytesPerFrame    = 2; // 每帧只有2个byte 声道*位深*Packet数
    inputFormat.mBytesPerPacket   = 2; // 每个Packet只有2个byte
    inputFormat.mBitsPerChannel   = 16; // 位深
    
    [self printAudioStreamBasicDescription:inputFormat];
    
    status = AudioUnitSetProperty(audioUnit,
                                  kAudioUnitProperty_StreamFormat,
                                  kAudioUnitScope_Output,
                                  INPUT_BUS,
                                  &inputFormat,
                                  sizeof(inputFormat));
    if (status != noErr) {
        NSLog(@"ERROR__kAudioUnitProperty_StreamFormat with status:%d", status);
        return;
    }
    
    //输出格式
    AudioStreamBasicDescription outputFormat = inputFormat;
    outputFormat.mChannelsPerFrame = 2; // 声道数

    [self printAudioStreamBasicDescription:outputFormat];
    
    status = AudioUnitSetProperty(audioUnit,
                                  kAudioUnitProperty_StreamFormat,
                                  kAudioUnitScope_Input,
                                  OUTPUT_BUS,
                                  &outputFormat,
                                  sizeof(outputFormat));
    if (status != noErr) {
        NSLog(@"ERROR__kAudioUnitProperty_StreamFormat with status:%d", status);
        return;
    }
    
    // audio property
    UInt32 flag = 1;
    if (flag) {
        status = AudioUnitSetProperty(audioUnit,
                                      kAudioOutputUnitProperty_EnableIO,
                                      kAudioUnitScope_Input,
                                      INPUT_BUS,
                                      &flag,
                                      sizeof(flag));
    }
    if (status != noErr) {
        NSLog(@"ERROR__kAudioOutputUnitProperty_EnableIO with status:%d", status);
        return;
    }

    
    // call back
    AURenderCallbackStruct playCallback;
    playCallback.inputProc = PlayCallback;
    playCallback.inputProcRefCon = (__bridge void *)self;
    
    status =  AudioUnitSetProperty(audioUnit,
                                   kAudioUnitProperty_SetRenderCallback,
                                   kAudioUnitScope_Input,
                                   OUTPUT_BUS,
                                   &playCallback,
                                   sizeof(playCallback));

    if (status != noErr) {
        NSLog(@"ERROR__kAudioUnitProperty_SetRenderCallback with status:%d", status);
        return;
    }
    
    // call back
    AURenderCallbackStruct recordCallback;
    recordCallback.inputProc = RecordCallback;
    recordCallback.inputProcRefCon = (__bridge void *)self;
    
    status = AudioUnitSetProperty(audioUnit,
                                  kAudioOutputUnitProperty_SetInputCallback,
                                  kAudioUnitScope_Output,
                                  INPUT_BUS,
                                  &recordCallback,
                                  sizeof(recordCallback ));
    
    if (status != noErr) {
        NSLog(@"ERROR__kAudioUnitProperty_SetRenderCallback with status:%d", status);
        return;
    }
    status = AudioUnitInitialize(audioUnit);
}

static OSStatus PlayCallback(void *inRefCon,
                             AudioUnitRenderActionFlags *ioActionFlags,
                             const AudioTimeStamp *inTimeStamp,
                             UInt32 inBusNumber,
                             UInt32 inNumberFrames,
                             AudioBufferList *ioData) {
    
    KKPlayRecord *player = (__bridge KKPlayRecord *)inRefCon;
    memcpy(ioData->mBuffers[0].mData, player->bufferList->mBuffers[0].mData, player->bufferList->mBuffers[0].mDataByteSize);
    
    ioData->mBuffers[0].mDataByteSize = player->bufferList->mBuffers[0].mDataByteSize;
    
    NSInteger bytes = PR_CONST_BUFFER_SIZE < ioData->mBuffers[1].mDataByteSize * 2 ? PR_CONST_BUFFER_SIZE : ioData->mBuffers[1].mDataByteSize * 2;
    bytes = [player->inputStream read:player->buffer maxLength:bytes];
    
    for (int i = 0 ; i < bytes; ++i) {
        ((Byte *)ioData->mBuffers[1].mData)[i/2] = player->buffer[i];
    }
    ioData->mBuffers[1].mDataByteSize = (UInt32)bytes/2;
    
    if (ioData->mBuffers[0].mDataByteSize > ioData->mBuffers[1].mDataByteSize) {
        ioData->mBuffers[0].mDataByteSize = ioData->mBuffers[1].mDataByteSize;
    }
    
    return noErr;
}

static OSStatus RecordCallback(void *inRefCon,
                               AudioUnitRenderActionFlags *ioActionFlags,
                               const AudioTimeStamp *inTimeStamp,
                               UInt32 inBusNumber,
                               UInt32 inNumberFrames,
                               AudioBufferList *ioData) {
    
    KKPlayRecord *player = (__bridge KKPlayRecord *)inRefCon;
    player->bufferList->mNumberBuffers = 1;
    
    OSStatus status = AudioUnitRender(player->audioUnit, ioActionFlags, inTimeStamp, inBusNumber, inNumberFrames, player->bufferList);
    if (status != noErr) {
        NSLog(@"ERROR__AudioUnitRender");
        return -1;
    }
    
    [player writePCMData:player->bufferList->mBuffers[0].mData size:player->bufferList->mBuffers[0].mDataByteSize];
    
    return noErr;
}

- (void)writePCMData:(Byte *)data size:(UInt32)size {
    static FILE *file = NULL;
    NSString *path = [NSTemporaryDirectory() stringByAppendingString:@"/record.pcm"];
    
    NSLog(@"record path :%@",path);
    
    if (!file) {
        file = fopen(path.UTF8String,"w");
    }
    fwrite(buffer, size, 1, file);
}



- (void)stop {
    AudioOutputUnitStop(audioUnit);
    if (bufferList != NULL) {
        if (bufferList->mBuffers[0].mData) {
            free(bufferList->mBuffers[0].mData);
            bufferList->mBuffers[0].mData = NULL;
        }
        
        free(bufferList);
        bufferList = NULL;
    }
    
    [inputStream close];
}

- (void)dealloc {
    AudioOutputUnitStop(audioUnit);
    AudioUnitUninitialize(audioUnit);
    AudioComponentInstanceDispose(audioUnit);
    
    if (bufferList != NULL) {
        free(bufferList);
        bufferList = NULL;
    }
}

- (void)printAudioStreamBasicDescription:(AudioStreamBasicDescription)asbd {
    char formatID[5];
    UInt32 mFormatID = CFSwapInt32HostToBig(asbd.mFormatID);
    bcopy (&mFormatID, formatID, 4);
    formatID[4] = '\0';
    printf("Sample Rate:         %10.0f\n",  asbd.mSampleRate);
    printf("Format ID:           %10s\n",    formatID);
    printf("Format Flags:        %10X\n",    (unsigned int)asbd.mFormatFlags);
    printf("Bytes per Packet:    %10d\n",    (unsigned int)asbd.mBytesPerPacket);
    printf("Frames per Packet:   %10d\n",    (unsigned int)asbd.mFramesPerPacket);
    printf("Bytes per Frame:     %10d\n",    (unsigned int)asbd.mBytesPerFrame);
    printf("Channels per Frame:  %10d\n",    (unsigned int)asbd.mChannelsPerFrame);
    printf("Bits per Channel:    %10d\n",    (unsigned int)asbd.mBitsPerChannel);
    printf("\n");
}


@end
