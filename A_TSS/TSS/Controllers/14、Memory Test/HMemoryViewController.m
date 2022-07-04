//
//  HMemoryViewController.m
//  TSS
//
//  Created by Chenfy on 2022/4/21.
//  Copyright © 2022 Chenfy. All rights reserved.
//

#import "HMemoryViewController.h"
#import <objc/runtime.h>
#import <malloc/malloc.h>

#import "Person.h"
#import "Student.h"

@interface HMemoryViewController ()
@property(nonatomic,copy)NSString *name;
//打印自动释放池的情况
extern void _objc_autoreleasePoolPrint(void);

@end

@implementation HMemoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
#pragma mark -- 1、test print
    id cls = [Person class];
    void *obj = &cls;
    [(__bridge id)obj print];
    
    self.view.backgroundColor = UIColor.whiteColor;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    NSLog(@"-----------%s---------------",__func__);
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    return;
    Student *st = [[Student alloc]init];
    [st test];
    [st testAge:12 name:@"123"];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -- NSObject size
- (void)test_memory_size {
    NSLog(@"######## NSObject ############################################");
    NSObject *obj = [[NSObject alloc]init];
    NSLog(@"----%@-----",obj);
    NSLog(@"----%p-----",obj);
    
    NSLog(@"-------------%zu-----------",sizeof(obj));
    NSLog(@"-------------%zu-----------",class_getInstanceSize([NSObject class]));
    NSLog(@"-------------%zu-----------",malloc_size((__bridge void *)obj));
    
    NSLog(@"######## Person ############################################");
    Person *pern = [[Person alloc]init];
    NSLog(@"----%@-----",pern);
    NSLog(@"----%p-----",pern);
    
    NSLog(@"-------------%zu-----------",sizeof(pern));
    NSLog(@"-------------%zu-----------",class_getInstanceSize([Person class]));
    NSLog(@"-------------%zu-----------",malloc_size((__bridge void *)pern));
    
    NSLog(@"######## Student ############################################");

    Student *st = [[Student alloc]init];
    
    NSLog(@"-------------%zu-----------",sizeof(st));
    NSLog(@"-------------%zu-----------",class_getInstanceSize([Student class]));
    NSLog(@"-------------%zu-----------",malloc_size((__bridge void *)st));
}

+ (BOOL)accessInstanceVariablesDirectly {
    return YES;
}

- (void)test_self_class {
    Student *st = [[Student alloc]init];
    
    [self test_class];
}

- (void)test_class {
    BOOL res1 = [[NSObject class] isKindOfClass:[NSObject class]];
    BOOL res2 = [[NSObject class] isMemberOfClass:[NSObject class]];
    BOOL res3 = [[Person class] isKindOfClass:[Person class]];
    BOOL res4 = [[Person class] isMemberOfClass:[Person class]];
    BOOL res5 =  [[Person class] isKindOfClass:[NSObject class]];
    BOOL res6 = [[Person class] isMemberOfClass:[NSObject class]];
    NSLog(@"--%d--%d--%d--%d--%d--%d--",res1,res2,res3,res4,res5,res6);
    // 1 0 0 0 1 0
}

#pragma mark -- 1、CADisplayLink、NSTimer使用注意
/*
 CADisplayLink、NSTimer会对target产生强引用，如果target又对它们产生强引用，那么就会引发循环引用

 解决方案
 使用block
 使用代理对象（NSProxy）
 */

#pragma mark -- 2、GCD定时器
/*
 NSTimer依赖于RunLoop，如果RunLoop的任务过于繁重，可能会导致NSTimer不准时
 而GCD的定时器会更加准时
 */
- (void)test_GCD_Timer {
    //创建一个定时器
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //设置时间 （start是几秒后开始执行，interval是时间间隔）
    NSTimeInterval start = 0.0,interval = 0.0;
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, start * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0);
    //设置回调
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"call back");
    });
    //启动定时器
    dispatch_resume(timer);
}

#pragma mark -- 3、iOS程序的内存布局
/*
 代码段：编译之后的代码

 数据段
 字符串常量：比如NSString *str = @"123"
 已初始化数据：已初始化的全局变量、静态变量等
 未初始化数据：未初始化的全局变量、静态变量等

 栈：函数调用开销，比如局部变量。分配的内存空间地址越来越小
 
 堆：通过alloc、malloc、calloc等动态分配的空间，分配的内存空间地址越来越大
 */

#pragma mark -- 4、Tagged Pointer
/*
 从64bit开始，iOS引入了Tagged Pointer技术，用于优化NSNumber、NSDate、NSString等小对象的存储

 在没有使用Tagged Pointer之前， NSNumber等对象需要动态分配内存、维护引用计数等，NSNumber指针存储的是堆中NSNumber对象的地址值

 使用Tagged Pointer之后，NSNumber指针里面存储的数据变成了：Tag + Data，也就是将数据直接存储在了指针中

 当指针不够存储数据时，才会使用动态分配内存的方式来存储数据

 objc_msgSend能识别Tagged Pointer，比如NSNumber的intValue方法，直接从指针提取数据，节省了以前的调用开销

 如何判断一个指针是否为Tagged Pointer？
 iOS平台，最高有效位是1（第64bit）
 Mac平台，最低有效位是1
 */
- (void)test_nsstring {
//    [self test_nsstring_1];
    [self test_nsstring_2];
}

- (void)test_nsstring_1 {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    for (int i = 0; i < 1000; i++) {
        dispatch_async(queue, ^{
            self.name = [NSString stringWithFormat:@"qwertyuiopasdfasd"];
        });
    }
    NSLog(@"-----%s------",__func__);
}

- (void)test_nsstring_2 {
    dispatch_queue_t queue = dispatch_queue_create(0, 0);
    for (int i = 0; i < 1000; i++) {
        dispatch_async(queue, ^{
            self.name = [NSString stringWithFormat:@"abc"];
        });
    }
    NSLog(@"-----%s------",__func__);
}

#pragma mark -- 5、OC对象的内存管理
/*
 在iOS中，使用引用计数来管理OC对象的内存

 一个新创建的OC对象引用计数默认是1，当引用计数减为0，OC对象就会销毁，释放其占用的内存空间

 调用retain会让OC对象的引用计数+1，调用release会让OC对象的引用计数-1

 内存管理的经验总结
 当调用alloc、new、copy、mutableCopy方法返回了一个对象，在不需要这个对象时，要调用release或者autorelease来释放它
 想拥有某个对象，就让它的引用计数+1；不想再拥有某个对象，就让它的引用计数-1

 可以通过以下私有函数来查看自动释放池的情况
 extern void _objc_autoreleasePoolPrint(void);
 */

#pragma mark -- 6、引用计数的存储
/*
 在64bit中，引用计数可以直接存储在优化过的isa指针中，也可能存储在SideTable类中

 struct SideTable {
     spinlock_t      slock;
     RefcountMap     refcnts;
     weak_table_t    weak_table;
 }
 
 refcnts是一个存放着对象引用计数的散列表
 */

#pragma mark -- 7、dealloc
/*
 当一个对象要释放时，会自动调用dealloc，接下的调用轨迹是
 dealloc
 _objc_rootDealloc
 rootDealloc
 object_dispose
 objc_destructInstance、free
 */

#pragma mark -- 8、自动释放池
/*
 ## 自动释放池的主要底层数据结构是：__AtAutoreleasePool、AutoreleasePoolPage

 调用了autorelease的对象最终都是通过AutoreleasePoolPage对象来管理的

 源码分析
 clang重写@autoreleasepool
 objc4源码：NSObject.mm
 
 ## AutoreleasePoolPage的结构
 
 每个AutoreleasePoolPage对象占用4096字节内存，除了用来存放它内部的成员变量，剩下的空间用来存放autorelease对象的地址
 所有的AutoreleasePoolPage对象通过双向链表的形式连接在一起
 
 调用push方法会将一个POOL_BOUNDARY入栈，并且返回其存放的内存地址

 调用pop方法时传入一个POOL_BOUNDARY的内存地址，会从最后一个入栈的对象开始发送release消息，直到遇到这个POOL_BOUNDARY

 id *next指向了下一个能存放autorelease对象地址的区域

 ## Runloop和Autorelease
 iOS在主线程的Runloop中注册了2个Observer
 第1个Observer监听了kCFRunLoopEntry事件，会调用objc_autoreleasePoolPush()
 第2个Observer
 监听了kCFRunLoopBeforeWaiting事件，会调用objc_autoreleasePoolPop()、objc_autoreleasePoolPush()
 监听了kCFRunLoopBeforeExit事件，会调用objc_autoreleasePoolPop()
 */



@end
