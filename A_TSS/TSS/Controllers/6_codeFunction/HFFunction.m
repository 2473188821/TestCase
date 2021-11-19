//
//  HFFunction.m
//  TSS
//
//  Created by Chenfy on 2021/11/19.
//  Copyright © 2021 Chenfy. All rights reserved.
//

#import "HFFunction.h"

#define logNotify NSLog(@"--------------------%s--",__func__)

NSInteger gl_count = 0;

extern uintptr_t _objc_rootRetainCount(id obj);
extern void _objc_autoreleasePoolPrint(void);


@interface HFFunction ()
@property(nonatomic,copy)NSString *name;
@property(nonatomic,strong)NSObject *obj;

@property(nonatomic,strong)NSMutableDictionary *modify;
@property(nonatomic,strong)NSMutableArray *list;

@end

@implementation HFFunction


- (void)fun_t1 {
    gl_count++;
    // 1 ping 0 pong
    if (gl_count%2 == 1) {
        [self pingpongDetectionStart];
    } else {
        [self pingpongNotifyCancel];
    }
}

- (void)pingpongDetectionStart {
    logNotify;
    [self performSelector:@selector(pingpongNotify) withObject:nil afterDelay:3.0];
}
- (void)pingpongNotify {
    logNotify;
    gl_count++;
}
- (void)pingpongNotifyCancel {
    logNotify;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(pingpongNotify) object:nil];
}

- (void)test {
    [NSRunLoop currentRunLoop];
    [NSRunLoop mainRunLoop];
    
    CFRunLoopGetCurrent();
    CFRunLoopGetMain();
    
//    CFRunLoopRef
//    CFRunLoopMode
}

- (void)fun_t2 {
    NSThread *td = [[NSThread alloc]initWithBlock:^{
        NSLog(@"t2----1");
    }];
    [td start];
    
    NSLog(@"ttttt----001--%@--",td);

    [self performSelector:@selector(t2_log) onThread:td withObject:nil waitUntilDone:YES];
    
    NSLog(@"ttttt---002--%@--",td);
}
- (void)t2_log {
    NSLog(@"t2----2");
    
    
}

- (void)fun_t3 {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    for (int i = 0 ; i < 1000; i++ ) {
        dispatch_async(queue, ^{
            NSLog(@"index---%d--",i);
//            self.name = [NSString stringWithFormat:@"12345678906543idnkanjsdkfansldkfnalsdkf"];
            self.name = [NSString stringWithFormat:@"123"];

        });
    }
    
    
    NSObject *obj = [[NSObject alloc]init];
    
//    [self fun_t3];
    
    self.obj = obj;
    
    uint cc = _objc_rootRetainCount(obj);
    _objc_autoreleasePoolPrint();
}

- (void)fun_t4__dealloc {
    /*
     1、deallloc
     2、objc_rootDealloc
     3、rootDealloc
     4、object_dispose
     5、objc_destructInstance
     6、free
     */
}

- (void)fun_t5_modify {
    NSInteger kv = gl_count%3;
    gl_count++;
    NSString *key = [NSString stringWithFormat:@"key_%ld",(long)kv];
    
    NSInteger count = [_modify[key]integerValue];
    _modify[key] =  @(++count);
    
    NSLog(@"------%@----",_modify);
    
}

- (void)fun_t6_括号 {
    [self generateParenthesis:3];
    NSLog(@"----%@---",self.list);
}

/** lee 22 */
- (void)generateParenthesis:(int)n {
    self.list = [NSMutableArray array];

    [self gen:0 right:0 num:n result:@""];
}
    
- (void)gen:(int)left right:(int)right num:(int)n result:(NSString *)result {
    if (left == n && right == n) {
        [self.list addObject:result];
        return;
    }

    if (left < n) {
        NSString *new = [NSString stringWithFormat:@"%@(",result];
        [self gen:left+1 right:right num:n result:new];
    }
    if (left > right && right < n) {
        NSString *new = [NSString stringWithFormat:@"%@)",result];
        [self gen:left right:right+1 num:n result:new];
    }
}


- (void)fun_t7 {
    /*
     1 - 1
     2 - 10
     3 - 11
     4 - 100
     5 - 101
     6 - 110
     7 - 111
     8 - 1000
     9 - 1001
     10 - 1010
     */

    for (int i = 1; i <11; i++) {
        int temp = i;
        int a = temp, b = -temp;
        
        int c = a & 1;
        NSLog(@"-index-<%d>----<%d>--",i,c);
    }
}


@end
