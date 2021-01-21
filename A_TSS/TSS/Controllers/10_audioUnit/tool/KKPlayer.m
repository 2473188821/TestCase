//
//  KKPlayer.m
//  TSS
//
//  Created by Chenfy on 2021/1/12.
//  Copyright © 2021 Chenfy. All rights reserved.
//

#import "KKPlayer.h"
#import <AudioUnit/AudioUnit.h>
#import <AVFoundation/AVFoundation.h>

const uint32_t CONST_BUFFER_SIZE = 0x10000;

#define INPUT_BUS   1
#define OUTPUT_BUS  0


@interface KKPlayer()
{
    AudioUnit audioUnit;
    AudioBufferList *bufferList;
    
    NSInputStream *inputStream;
}

@property(nonatomic,copy)NSString *address;

@end

@implementation KKPlayer

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
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:&error];

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
    bufferList = (AudioBufferList *)malloc(sizeof(AudioBufferList));
    bufferList->mNumberBuffers = 1;
    bufferList->mBuffers[0].mNumberChannels = 1;
    bufferList->mBuffers[0].mDataByteSize = CONST_BUFFER_SIZE;
    bufferList->mBuffers[0].mData = malloc(CONST_BUFFER_SIZE);
    
    // audio property
    UInt32 flag = 1;
    if (flag) {
        status = AudioUnitSetProperty(audioUnit,
                                      kAudioOutputUnitProperty_EnableIO,
                                      kAudioUnitScope_Output,
                                      OUTPUT_BUS,
                                      &flag,
                                      sizeof(flag));
    }
    if (status != noErr) {
        NSLog(@"ERROR__kAudioOutputUnitProperty_EnableIO with status:%d", status);
        return;
    }
    
    // format
//    AudioStreamBasicDescription outputFormat = {0};
    AudioStreamBasicDescription outputFormat;
    memset(&outputFormat, 0, sizeof(outputFormat));
    
    outputFormat.mSampleRate = 44100; //采样率
    outputFormat.mFormatID = kAudioFormatLinearPCM; //PCM 格式
    outputFormat.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger; //整形
    outputFormat.mFramesPerPacket = 1; // 每帧只有一个packet
    outputFormat.mChannelsPerFrame = 1; // 声道数
    outputFormat.mBytesPerFrame    = 2; // 每帧只有2个byte 声道*位深*Packet数
    outputFormat.mBytesPerPacket   = 2; // 每个Packet只有2个byte
    outputFormat.mBitsPerChannel   = 16; // 位深
    
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
    
    // call back
    AURenderCallbackStruct playCallback;
    playCallback.inputProc = PlayCallback;
    playCallback.inputProcRefCon = (__bridge void *)self;
    
    AudioUnitSetProperty(audioUnit,
                         kAudioUnitProperty_SetRenderCallback,
                         kAudioUnitScope_Input,
                         OUTPUT_BUS,
                         &playCallback,
                         sizeof(playCallback));
    
    
    status = AudioUnitInitialize(audioUnit);

    if (status != noErr) {
        NSLog(@"ERROR__kAudioUnitProperty_SetRenderCallback with status:%d", status);
        return;
    }
}


static OSStatus PlayCallback(void *inRefCon,
                             AudioUnitRenderActionFlags *ioActionFlags,
                             const AudioTimeStamp *inTimeStamp,
                             UInt32 inBusNumber,
                             UInt32 inNumberFrames,
                             AudioBufferList *ioData) {
    
    KKPlayer *player = (__bridge KKPlayer *)inRefCon;
    NSInputStream *inputStream = player->inputStream;
    
    NSInteger mDataSize = ioData->mBuffers[0].mDataByteSize;
    
    UInt32 readSize = (UInt32)[inputStream read:ioData->mBuffers[0].mData maxLength:mDataSize];
    ioData->mBuffers[0].mDataByteSize = readSize;
        
    NSLog(@"out size: %ld", (long)readSize);
    
    if (readSize <= 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [player stop];
        });
    }
    return noErr;
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
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onPlayToEnd:)]) {
        [self.delegate onPlayToEnd:self];
    }
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
