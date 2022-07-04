//
//  Student.m
//  TSS
//
//  Created by Chenfy on 2022/4/25.
//  Copyright © 2022 Chenfy. All rights reserved.
//

#import "Student.h"
#import <objc/runtime.h>

@implementation Student

- (instancetype)init {
    self = [super init];
    if (self) {
        [self test_class];
    }
    return self;
}
#pragma mark --
#pragma mark -- super 本质
/*
 super调用，底层会转换为objc_msgSendSuper2函数的调用，接收2个参数
 struct objc_super2
 SEL
 
 struct objc_super2 {
    id receiver;
    Class current_class;
 }
 
 receiver是消息接收者
 current_class是receiver的Class对象
 */
- (void)test_class {
    NSLog(@"--self class---<%@>---",[self class]);
    NSLog(@"--super class---<%@>---",[super class]);
    NSLog(@"--self superclass---<%@>---",[self superclass]);
    NSLog(@"--super superclass---<%@>---",[super superclass]);
}

#pragma mark --
#pragma mark -- objc_msgSend执行流程
/*
 1、消息发送；
 2、动态方法解析；
 3、消息转发；
 */
#pragma mark --《一》、消息发送
#pragma mark --《二》、动态方法解析
#pragma mark -- OC fun
- (void)other_oc {
    NSLog(@"--%@--%s--%s--",self,sel_getName(_cmd),__func__);
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == @selector(test)) {
        Method method = class_getInstanceMethod(self, @selector(other_oc));
        class_addMethod(self,
                        sel,
                        method_getImplementation(method),
                        method_getTypeEncoding(method));
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

#pragma mark -- C fun

void other(id self, SEL _cmd) {
    NSLog(@"--%@--%s--%s--",self,sel_getName(_cmd),__func__);
}

//+ (BOOL)resolveInstanceMethod:(SEL)sel {
//    if (sel == @selector(test)) {
//        class_addMethod(self, sel, (IMP)(other), "v@:");
//        return YES;
//    }
//    return [super resolveInstanceMethod:sel];
//}

#pragma mark --《三》、消息转发
//1、实例函数
- (id)forwardingTargetForSelector:(SEL)aSelector {
    return [super forwardingTargetForSelector:aSelector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    
    NSMethodSignature *msg1 = [NSMethodSignature signatureWithObjCTypes:"i@:i"];
    NSMethodSignature *msg2 = [[[Student alloc]init]methodSignatureForSelector:@selector(test:)];
    
    return [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
}

- (void)doesNotRecognizeSelector:(SEL)aSelector {

}

//2、类函数
+ (id)forwardingTargetForSelector:(SEL)aSelector {
    return [super forwardingTargetForSelector:aSelector];
}

+ (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [super methodSignatureForSelector:aSelector];
}

+ (void)forwardInvocation:(NSInvocation *)anInvocation {
    
}

+ (void)doesNotRecognizeSelector:(SEL)aSelector {
    
}


#pragma mark -- 运行时用途
/*
 1、查看私有成员变量；
 2、遍历所有属性及成员变量；
 3、利用KVC设值；
 4、class_replaceMethod
 5、method_exchangeImplementations

 */

@end
