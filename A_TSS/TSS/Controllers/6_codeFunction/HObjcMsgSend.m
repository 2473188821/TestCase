//
//  HObjcMsgSend.m
//  TSS
//
//  Created by Chenfy on 2021/9/1.
//  Copyright © 2021 Chenfy. All rights reserved.
//

#import "HObjcMsgSend.h"

@interface HObjcMsgSend ()

@end

@implementation HObjcMsgSend

/*
//情况一、# getter / setter 生成
 
@synthesize age = _age;
 
//情况二、# 运行时生成 getter / setter
 
@dynamic age;
*/

/** 消息转发机制流程
 1、消息发送
 2、动态方法解析
 3、消息转发
 */

//阶段一
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    return [super resolveInstanceMethod:sel];
}

+ (BOOL)resolveClassMethod:(SEL)sel {
    return [super resolveClassMethod:sel];
}

//阶段二
//类
- (id)forwardingTargetForSelector:(SEL)aSelector {
    return [super forwardingTargetForSelector:aSelector];
}

//元类
+ (id)forwardingTargetForSelector:(SEL)aSelector {
    return [super forwardingTargetForSelector:aSelector];
}

//阶段三
//类
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
}

- (void)doesNotRecognizeSelector:(SEL)aSelector {
    
}

//元类
+ (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [super methodSignatureForSelector:aSelector];
}

+ (void)forwardInvocation:(NSInvocation *)anInvocation {
    
}

+ (void)doesNotRecognizeSelector:(SEL)aSelector {
    
}

/**
 1、拦截crash

 - (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
     return [NSMethodSignature signatureWithObjCTypes:"v@:"];
 }

 - (void)forwardInvocation:(NSInvocation *)anInvocation {
     id target = anInvocation.target;
     NSString *selector = NSStringFromSelector(anInvocation.selector);
     NSLog(@"SELECTOR_ERROR: <TARGET: %@>--<FUN: %@>--",NSStringFromClass([target class]),selector);
 }
 
*/

@end
