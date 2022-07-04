//
//  HGCDViewController.m
//  TSS
//
//  Created by Chenfy on 2022/4/18.
//  Copyright © 2022 Chenfy. All rights reserved.
//

#pragma mark -- 1、iOS线程同步方案性能比较
/*
 性能从高到低排序
 os_unfair_lock
 OSSpinLock
 dispatch_semaphore
 pthread_mutex
 dispatch_queue(DISPATCH_QUEUE_SERIAL)
 NSLock
 NSCondition
 pthread_mutex(recursive)
 NSRecursiveLock
 NSConditionLock
 @synchronized
 */

#pragma mark -- 2、自旋锁、互斥锁比较
/*
 什么情况使用自旋锁比较划算？
 预计线程等待锁的时间很短
 加锁的代码（临界区）经常被调用，但竞争情况很少发生
 CPU资源不紧张
 多核处理器

 什么情况使用互斥锁比较划算？
 预计线程等待锁的时间较长
 单核处理器
 临界区有IO操作
 临界区代码复杂或者循环量大
 临界区竞争非常激烈
 */

#pragma mark -- 3、atomic
/*
 atomic用于保证属性setter、getter的原子性操作，相当于在getter和setter内部加了线程同步的锁
 可以参考源码objc4的objc-accessors.mm
 它并不能保证使用属性的过程是线程安全的
 */

#pragma mark -- 4、iOS中的读写安全方案
/*
 思考如何实现以下场景
 同一时间，只能有1个线程进行写的操作
 同一时间，允许有多个线程进行读的操作
 同一时间，不允许既有写的操作，又有读的操作

 上面的场景就是典型的“多读单写”，经常用于文件等数据的读写操作，iOS中的实现方案有
 pthread_rwlock：读写锁
 dispatch_barrier_async：异步栅栏调用
 
 #### dispatch_barrier_async ####
 这个函数传入的并发队列必须是自己通过dispatch_queue_cretate创建的
 如果传入的是一个串行或是一个全局的并发队列，那这个函数便等同于dispatch_async函数的效果
 
 - (void)test_dispatch_barrier_async {
     //初始化队列
     dispatch_queue_t queue = dispatch_queue_create("rw_queue", DISPATCH_QUEUE_CONCURRENT);
     //读
     dispatch_async(queue, ^{
         NSLog(@"---read------");
     });
     //写
     dispatch_barrier_async(queue, ^{
         NSLog(@"---write-----");
     });
 }
 */


#import "HGCDViewController.h"
#import <libkern/OSAtomic.h>
#import <os/lock.h>

@interface HGCDViewController ()
@property(nonatomic,assign)BOOL isShow;

@end

static HGCDViewController *gl_liveRoom = nil;
static dispatch_once_t gl_onceToken;

@implementation HGCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self test_thread];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -- 1、单例创建、销毁测试

+ (instancetype)sharedLiveRoom {
    dispatch_once(&gl_onceToken, ^{
        gl_liveRoom = [[HGCDViewController alloc]init];
    });
    return gl_liveRoom;
}

- (void)setbackGroundColor:(UIColor *)color {
    self.view.backgroundColor = color;
}

- (void)openLiveRoomWithModelPush:(UINavigationController *)navVC animated:(BOOL)animated {
    if (_isShow) {
        return;
    }
    _isShow = YES;
    [navVC pushViewController:self animated:YES];
}

- (void)openLiveRoomWithModelPresent:(UIViewController *)present animated: (BOOL)flag completion:(void (^ __nullable)(void))completion {
    if (_isShow) {
        return;
    }
    _isShow = YES;
    
    [present presentViewController:self animated:YES completion:^{
            
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    _isShow = NO;
    
    gl_onceToken = 0;
    gl_liveRoom = nil;
}

+ (void)destroy {
    gl_onceToken = 0;
}

- (void)dealloc {
    NSLog(@"---dealloc-------------%s---",__func__);
}

#pragma mark -- 2、GCD performSelector 测试
- (void)logMessage {
    NSLog(@"---hello----%s----",__func__);
}

- (void)test_performSelector {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        NSLog(@"------1----");
        //向runloop添加定时器
        [self performSelector:@selector(logMessage) withObject:nil afterDelay:0];
        NSLog(@"----3-----");
    });
}

- (void)test_thread {
    if (@available(iOS 10.0, *)) {
        NSThread *th = [[NSThread alloc]initWithBlock:^{
            NSLog(@"---11---");
        }];
        [th start];
        
        [self performSelector:@selector(logMessage) onThread:th withObject:nil waitUntilDone:YES];
    } else {
        // Fallback on earlier versions
    }
}

#pragma mark -- 3、GCD 队列组的使用
- (void)test_gcd_group {
    dispatch_queue_t queue = dispatch_queue_create("gcd_group", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"--group-----1----");
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"--group-----2----");
    });
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"--group-----3----");

        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"--group-----4----");
        });
    });
}

#pragma mark -- 4、osspinlock
/*
 OSSpinLock叫做”自旋锁”，等待锁的线程会处于忙等（busy-wait）状态，一直占用着CPU资源
 目前已经不再安全，可能会出现优先级反转问题
 如果等待锁的线程优先级较高，它会一直占用着CPU资源，优先级低的线程就无法释放锁
 需要导入头文件#import <libkern/OSAtomic.h>
 */
- (void)test_osspinlock {
    OSSpinLock lock = OS_SPINLOCK_INIT;
    //尝试加锁
    __unused bool result = OSSpinLockTry(&lock);
    //加锁
    OSSpinLockLock(&lock);
    //解锁
    OSSpinLockUnlock(&lock);
}

#pragma mark -- 5、os_unfair_lock
/*
 os_unfair_lock用于取代不安全的OSSpinLock ，从iOS10开始才支持
 从底层调用看，等待os_unfair_lock锁的线程会处于休眠状态，并非忙等
 需要导入头文件#import <os/lock.h>
 */
- (void)test_os_unfair_lock {
    if (@available(iOS 10, *)) {
        os_unfair_lock lock = OS_UNFAIR_LOCK_INIT;
        //尝试加锁
        __unused bool result = os_unfair_lock_trylock(&lock);
        //加锁
        os_unfair_lock_lock(&lock);
        //解锁
        os_unfair_lock_unlock(&lock);
    }
}

#pragma mark -- 6、mutex
/*
 mutex叫做”互斥锁”，等待锁的线程会处于休眠状态
 需要导入头文件#import <pthread.h>
 
 NSLock是对mutex普通锁的封装
 NSRecursiveLock也是对mutex递归锁的封装，API跟NSLock基本一致
 NSCondition是对mutex和cond的封装
 NSConditionLock是对NSCondition的进一步封装，可以设置具体的条件值
 */
- (void)test_pthread {
    
}

#pragma mark -- 7、dispatch_semaphore
/*
 semaphore叫做”信号量”
 信号量的初始值，可以用来控制线程并发访问的最大数量
 信号量的初始值为1，代表同时只允许1条线程访问资源，保证线程同步
 */
- (void)test_dispatch_semaphore {
    //信号量的初始值
    int value = 1;
    //初始化信号量
    dispatch_semaphore_t semph = dispatch_semaphore_create(value);
    //如果信号量的值<=0,当前线程就会进入休眠等待（直到信号量的值>0）
    //如果信号量的值>0 ,就减1 ,然后往下执行后面的代码
    dispatch_semaphore_wait(semph, DISPATCH_TIME_FOREVER);
    //让信号量的值+1
    dispatch_semaphore_signal(semph);
}

#pragma mark -- 8、dispatch_queue
/*
 直接使用GCD的串行队列，也是可以实现线程同步的
 */
- (void)test_dispatch_queue {
    dispatch_queue_t queue = dispatch_queue_create("queque", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue, ^{
        NSLog(@"--直接使用GCD的串行队列，也是可以实现线程同步的");
    });
}

#pragma mark -- 9、@synchronized
/*
 @synchronized是对mutex递归锁的封装
 源码查看：objc4中的objc-sync.mm文件
 @synchronized(obj)内部会生成obj对应的递归锁，然后进行加锁、解锁操作
 */
- (void)test_synchronized {
    NSObject *obj = [[NSObject alloc]init];
    @synchronized (obj) {
        //任务
    }
}

#pragma mark -- 10、线程安全 <iOS中的读写安全方案>
- (void)test_dispatch_barrier_async {
    //初始化队列
    dispatch_queue_t queue = dispatch_queue_create("rw_queue", DISPATCH_QUEUE_CONCURRENT);
    //读
    dispatch_async(queue, ^{
        NSLog(@"---read------");
    });
    //写
    dispatch_barrier_async(queue, ^{
        NSLog(@"---write-----");
    });
}




@end
