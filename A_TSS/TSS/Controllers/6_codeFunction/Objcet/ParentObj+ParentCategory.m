//
//  ParentObj+ParentCategory.m
//  TSS
//
//  Created by Chenfy on 2021/4/6.
//  Copyright © 2021 Chenfy. All rights reserved.
//

#import "ParentObj+ParentCategory.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation ParentObj (ParentCategory)

- (void)setName:(NSString *)name {

}


- (void)hk_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context {
    //动态生成一个类
    NSString *oldClassName = NSStringFromClass([self class]);
    NSString *newClassName = [NSString stringWithFormat:@"HKKVO_%@",oldClassName];

    const char *newName = [newClassName UTF8String];
    
    Class newClass = objc_allocateClassPair([self class], newName, 0);
    
    class_addMethod(newClass, @selector(setName:), (IMP)setName, "v@:@");
    
    objc_registerClassPair(newClass);
    
    object_setClass(self, newClass);
    
    objc_setAssociatedObject(self, "objc", observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

void setName(id self ,SEL _cmd ,NSString *newName) {
    //记录当前类，类型
    Class class = [self class];
    object_setClass(self, class_getSuperclass(class));
    
    /*
    objc_msgSend(self,@selector(setName:),newName);
    
    id observe = objc_getAssociatedObject(self, "objc");
    
    if (observe) {
        objc_msgSend(observe,@selector(observeValueForKeyPath:ofObject:change:context:),nil);
    }
     */
    
    //改回子类class类型
    object_setClass(self, class);
    
}
@end
