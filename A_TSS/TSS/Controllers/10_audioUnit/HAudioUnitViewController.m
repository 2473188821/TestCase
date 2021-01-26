//
//  HAudioUnitViewController.m
//  TSS
//
//  Created by Chenfy on 2021/1/12.
//  Copyright © 2021 Chenfy. All rights reserved.
//

#import "HAudioUnitViewController.h"
#import "KKPlayer.h"
#import "KKPlayRecord.h"

#import "HMediaTool.h"

@interface HAudioUnitViewController ()
@property(nonatomic,strong)KKPlayer *kPlayer;
@property(nonatomic,strong)KKPlayRecord *kPlayerRecord;

@property(nonatomic,strong)HMediaTool *mTool;

@end

@implementation HAudioUnitViewController

- (KKPlayer *)kPlayer {
    if (!_kPlayer) {
        _kPlayer = [[KKPlayer alloc]init];
    }
    return _kPlayer;
}

- (KKPlayRecord *)kPlayerRecord {
    if (!_kPlayerRecord) {
        _kPlayerRecord = [[KKPlayRecord alloc]init];
    }
    return _kPlayerRecord;
}

- (HMediaTool *)mTool {
    if (!_mTool) {
        _mTool = [[HMediaTool alloc]init];
    }
    return _mTool;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSMutableURLRequest *request = nil;
    request.HTTPBodyStream = [NSInputStream inputStreamWithFileAtPath:@""];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    [self playAudio];
//    [self playRecord];
    [self mediaMerge];
    
} 

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark -- 1、audioUnit play

- (void)playAudio {
    NSString *address = [[NSBundle mainBundle]pathForResource:@"441_30" ofType:@"pcm"];
    
    [self.kPlayer play:address];
}

#pragma mark -- 2、audioUnit 耳返效果

- (void)playRecord {
    NSString *address = [[NSBundle mainBundle]pathForResource:@"441_30" ofType:@"pcm"];
    
    [self.kPlayerRecord play:address];
}

#pragma mark -- 3、media merge

- (void)mediaMerge {
    NSURL *audioURL = [[NSBundle mainBundle]URLForResource:@"meetyou_30" withExtension:@"mp3"];
    NSURL *videoURL = [[NSBundle mainBundle]URLForResource:@"mayun" withExtension:@"mp4"];
        
    float ran = arc4random()%1000;
    NSString *saveName = [NSString stringWithFormat:@"Output_%f",ran];
    NSString *saveNameFull = [NSString stringWithFormat:@"%@.mp4",saveName];
    
    NSString *pathTemp = NSTemporaryDirectory();
    pathTemp =[pathTemp stringByAppendingPathComponent:saveNameFull];
    NSURL *outURL = [NSURL fileURLWithPath:pathTemp];
    
    int router = 1;
    
    if (router == 0)
    {
        [HMediaTool mergeAudio:audioURL video:videoURL output:outURL complete:^(BOOL result, NSURL * _Nonnull path) {
            NSLog(@"HMediaTool merge result: %d  %@",result,path);
        }];
    }
    else if (router == 1)
    {
        [HMediaTool addBackgroundMiusicWithVideoUrlStr:videoURL audioUrl:audioURL start:1 end:15 isOrignalSound:NO completion:^(NSString * _Nonnull outPath, BOOL isSuccess) {
            NSLog(@"HMediaTool merge result: %d  %@",isSuccess,outPath);
        }];
    }
    else if (router == 2)
    {

    }
}





@end
