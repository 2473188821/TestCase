//
//  GCDViewController.m
//  TSS
//
//  Created by Chenfy on 2021/3/24.
//  Copyright © 2021 Chenfy. All rights reserved.
//

#import "GCDViewController.h"

@interface GCDViewController ()
{
    dispatch_semaphore_t semaphore;
    NSInteger count;
}

@end

@implementation GCDViewController


- (void)viewDidLoad {
    [super viewDidLoad];
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

#pragma mark -- 1、保持线程同步（将异步任务转换为同步任务）

- (void)test {
     semaphore = dispatch_semaphore_create(0);
    
    __block NSInteger number = 0;

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        number = 100;
        
        dispatch_semaphore_signal(semaphore);
    });
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

    NSLog(@"dispatch_semaphore_t----:%ld",(long)number);
}

#pragma mark -- 2、保证线程安全（为线程加锁）

- (void)asynTrack:(void(^)(void))block {
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    count++;

    sleep(1);
    
    NSLog(@"执行任务---");
    if (block) {
        block();
    }
    
    dispatch_semaphore_signal(semaphore);
}

- (void)test1 {
    semaphore = dispatch_semaphore_create(1);
    
    for (NSInteger i = 0; i <100; i++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self asynTrack:^{
                NSLog(@"+++++--------:%ld",(long)i);
            }];
        });
    }
}

@end
