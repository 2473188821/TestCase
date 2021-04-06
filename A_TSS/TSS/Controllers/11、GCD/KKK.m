//
//  KKK.m
//  TestDoc
//
//  Created by Chenfy on 2021/4/5.
//  Copyright © 2021 Chenfy. All rights reserved.
//

#import "KKK.h"

static KKK *_kk = nil;
static dispatch_once_t _token;

@implementation KKK

+ (id)shareInstance {
    dispatch_once(&_token, ^{
        _kk = [[super allocWithZone:NULL]init];
        NSLog(@"create 了！");
    });
    
    return _kk;
}

// 销毁单例对象
- (void)dellocInstance {
    // 设置为0，GCD会认为它从未执行过，这样才能保证下次调用 shareInstance 的时候，再次创建对象
    _token = 0;
    _kk = nil;
    
    NSLog(@"dealloc 了！");

}

// 【必不可少】重写 allocWithZone 方法
// 因为不使用 sharedInstance 进行创建对象的情况，也是有可能的
// 比如使用 alloc 进行创建， alloc 会调用 allocWithZone ,所以重写 allocWithZone，在内部手动调用 [self sharedInstance];
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self shareInstance];
}

// 【必不可少】当单例被 copy
// 外界有可能会对当前实例进行copy操作来创建一个对象，要保证一个对象在App生命周期内永远只能被创建一次，我们还需要重写 copyWithZone 方法
// 直接将 self 返回就可以了
- (id)copyWithZone:(nullable NSZone *)zone {
    return self;
}


- (void)dealloc {
    NSLog(@"hhhh------");
}


@end
