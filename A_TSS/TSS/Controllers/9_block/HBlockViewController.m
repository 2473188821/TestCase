//
//  HBlockViewController.m
//  TSS
//
//  Created by Chenfy on 2021/1/3.
//  Copyright © 2021 Chenfy. All rights reserved.
//

#import "HBlockViewController.h"

//无参数
typedef void(^BlockRetain)(void);
//有参数
typedef void(^BlockRetainCycle)(id obj);

@interface HBlockViewController ()
@property(nonatomic,copy)BlockRetain block;
@property(nonatomic,copy)BlockRetainCycle blockCycle;

@property(nonatomic,copy)NSString *name;

@end

@implementation HBlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    __block int a = 100;
    NSLog(@"进去前---：%@",&a);
    self.block = ^{
        NSLog(@"进去后---：%@",&a);
    };
    
    self.block();
    NSLog(@"出来后---：%@",&a);
    
    // Do any additional setup after loading the view.
}

#pragma mark -- Block 初探类型
- (void)demoBlockType {
    // __NSGlobalBlock__ 全局block
    void(^block1)(void) = ^{
        NSLog(@"hello---");
    };
    NSLog(@"__NSGlobalBlock__:%@",block1);
    
    //__NSMallocBlock__ 堆block 重写 = 做了copy操作
    int a = 1110;
    void(^block)(void) = ^{
        NSLog(@"hello---:%d",a);
    };
    NSLog(@"__NSMallocBlock__:%@",block);
    
    //__NSStackBlock__ 栈 block
    NSLog(@"---%@",^{
        NSLog(@"__NSStackBlock__:%d",a);
    });
}

#pragma mark -- Block 循环引用问题
//解法一
- (void)demoRetainCycle1 {
    __weak typeof(self)weakself = self;
    
    self.block = ^{
        __strong typeof(self) strongself = weakself;
        strongself.name = @"zhangsan";
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"name----:%@",strongself.name);
        });
    };
    
    self.block();
}

//解法二
- (void)demoRetainCycle2 {
    __block HBlockViewController *hblock = self;
    self.block = ^{
        hblock.name = @"zhangsan";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"name----:%@",hblock.name);
            
            hblock = nil;
        });
    };
    
    self.block();
}
//解法三
- (void)demoRetainCycle3 {
    self.blockCycle = ^(HBlockViewController *vc){
        vc.name = @"zhangsan";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"name----:%@",vc.name);
        });
    };
    
    self.blockCycle(self);
}


#pragma mark -- Block 底层
- (void)demoAddressChange {
    
}

- (void)dealloc {
    NSLog(@"dealloc 走了！--:%@",self);
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
