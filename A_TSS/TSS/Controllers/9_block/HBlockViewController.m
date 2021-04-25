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

//retainCount test
@property(nonatomic,assign)NSInteger nnn;
@property(nonatomic,copy)NSString *string_value;
@property(nonatomic,strong)NSMutableString *stringMutable_value;

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


- (void)test5 {
    static NSInteger num = 5;
    
    void (^block)(void) = ^() {
        num = 12;
        self.nnn = 111;
        NSLog(@"value--nnn--:%ld",(long)num);
           
    };
    num = 8;
    
    block();
}

- (void)test4 {
    NSInteger num = 5;
    
    void (^block)(void) = ^() {
        NSLog(@"value---num----:%ld",(long)num);
           
    };
    num = 8;
    
    block();
}

//原因
//https://blog.csdn.net/bravegogo/article/details/50792437

- (void)test3 {
    NSMutableArray *Arr = [[NSMutableArray alloc]initWithObjects:@"1",@"2", nil];
    
    void (^block)(void) = ^() {
        
        NSLog(@"value---arr----:%@",Arr);

        [Arr addObject:@"4"];
    };
    
    [Arr addObject:@"3"];
    
    Arr = nil;
    
    block();
    
    NSLog(@"value---arr----:%@",Arr);
}

- (void)retainCountTest {
 //    self.nnn = 33;
    NSLog(@"pppp---nn--%p---",&_nnn);
    
    NSInteger mmm = 222;
    NSLog(@"pppp---mm--%p---",&mmm);

    
    NSString *s1 = @"xxx";
    NSLog(@"pppp---s1--%p---",s1);
    
    NSString *s2 = [[NSString alloc]initWithString:@"12"];
    NSLog(@"pppp---s2--%p---",s2);
    
    NSMutableString *s3 = [[NSMutableString alloc]initWithString:@"345"];
    NSLog(@"pppp---s3--%p---",s2);

    self.string_value = s2;
    
    NSLog(@"pppp---s4--%p---",_string_value);

    self.stringMutable_value = s3;
    
    NSLog(@"pppp---s5--%p---",_stringMutable_value);
}



@end
