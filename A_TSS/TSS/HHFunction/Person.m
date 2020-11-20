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
//自旋锁
@property(nonatomic,assign)OSSpinLock pinlock;

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

// UIColor转#ffffff格式的字符串
- (NSString *)hexStringFromColor:(UIColor *)color xxalpha:(CGFloat)alpha {
    const CGFloat *components = CGColorGetComponents(color.CGColor);

    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    CGFloat a = alpha;

    return [NSString stringWithFormat:@"#%02lX%02lX%02lX%02lX",lroundf(a * 255),lroundf(r * 255),lroundf(g * 255),lroundf(b * 255)];
    return [NSString stringWithFormat:@"#%02lX%02lX%02lX",lroundf(r * 255),lroundf(g * 255),lroundf(b * 255)];
}


@end
