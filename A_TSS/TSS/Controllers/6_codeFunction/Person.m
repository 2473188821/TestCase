//
//  Person.m
//  TSS
//
//  Created by Chenfy on 2020/9/2.
//  Copyright © 2020 Chenfy. All rights reserved.
//

#import "Person.h"
#import <libkern/OSAtomic.h>


@interface Person ()
{
    union {
           char bits;
           
           struct {
               char tall : 1;
               char rich : 1;
           };
       } _P_tallRich;
}
//自旋锁
@property(nonatomic,assign)OSSpinLock pinlock;

#define MASK_tall   (1<<0)
#define MASK_rich   (1<<1)


@end

@implementation Person

- (void)lock {
    self.pinlock = OS_SPINLOCK_INIT;
    
    // 初始化
    OSSpinLock lock = self.pinlock;
    //尝试加锁(如果不需要等待，就直接加锁，返回true。如果需要等待，就不加锁，返回false)
    __unused BOOL res = OSSpinLockTry(&lock);
    //加锁s
    OSSpinLockLock(&lock);
    //解锁
    OSSpinLockUnlock(&lock);
}

- (void)showFood {
// 1、初始化赋值
    self.food = PFoodType_none;
// 2、设置食物类型
    self.food = PFoodType_orange | PFoodType_apple;
// 3、取值状态
    __unused BOOL hasApple = (self.food & PFoodType_apple) == PFoodType_apple;
// 4、取消选择 apple 食物
    self.food = self.food ^ PFoodType_apple;
// 5、判断是否选择apple
    hasApple = (self.food & PFoodType_apple) == PFoodType_apple;
}


- (void)setName:(NSString *)name
{
    NSLog(@"person name --:%@",name);
}

- (Person *)eat
{
    NSLog(@"person eat!");
    return self;
}

- (Person *)drink
{
    NSLog(@"person drink!");
    return self;
}

- (void (^)(void))smile
{
    NSLog(@"person smile!");
    void(^smile)(void) = ^{
        NSLog(@"person block smile!");
        NSLog(@"%s",__FUNCTION__);
    };
    return smile;
}

- (void (^)(void))laugh
{
    NSLog(@"person laugh!");
    return ^{
        NSLog(@"person block laugh!");
        NSLog(@"%s",__FUNCTION__);
    };
}

- (Person * _Nonnull (^)(NSString *))nameCall
{
    Person *(^nameBlock)(NSString *name) = ^(NSString *name){
        if (!name)
        {
            name = @"1234567";
        }
        NSLog(@"person block name--:%@",name);
        return self;
    };
    return nameBlock;
}

- (Person * _Nonnull (^)(int))ageCall
{
    return ^(int age){
        NSLog(@"person block age--:%d",age);
        return self;
    };
}


- (Person *(^)(NSString *))name
{
    Person *(^nameBlock)(NSString *name) = ^(NSString *name){
        if (!name)
        {
            name = @"1234567";
        }
        NSLog(@"person block name--:%@",name);
        return self;
    };
    return nameBlock;
}

- (Person *(^)(int))age
{
    return ^(int age){
        NSLog(@"person block age--:%d",age);
        return self;
    };
}


id createPerson()
{
    return [Person new];
}

static id createPerson_static()
{
    return [Person new];
}

#pragma mark -- 方法解析
- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return [super forwardingTargetForSelector:aSelector];
}

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    return [super resolveInstanceMethod:sel];
}


#pragma mark -- 位与

- (void)setTall:(BOOL)tall {
    if (tall) {
        _P_tallRich.bits |= MASK_tall;
    } else {
        _P_tallRich.bits &= ~MASK_tall;
    }
}

- (BOOL)isTall {
    return !!(_P_tallRich.bits & MASK_tall);
}

- (void)setRich:(BOOL)rich {
    if (rich) {
        _P_tallRich.bits |= MASK_rich;
    } else {
        _P_tallRich.bits &= ~MASK_rich;
    }
}

- (BOOL)isRich {
    return !!(_P_tallRich.bits & MASK_rich);
}


@end
