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

@interface HAudioUnitViewController ()
@property(nonatomic,strong)KKPlayer *kPlayer;
@property(nonatomic,strong)KKPlayRecord *kPlayerRecord;

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSMutableURLRequest *request = nil;
    request.HTTPBodyStream = [NSInputStream inputStreamWithFileAtPath:@""];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    [self playAudio];
    [self playRecord];
    
} 

- (void)playAudio {
    NSString *address = [[NSBundle mainBundle]pathForResource:@"441_30" ofType:@"pcm"];
    
    [self.kPlayer play:address];
}

- (void)playRecord {
    NSString *address = [[NSBundle mainBundle]pathForResource:@"441_30" ofType:@"pcm"];
    
    [self.kPlayerRecord play:address];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
