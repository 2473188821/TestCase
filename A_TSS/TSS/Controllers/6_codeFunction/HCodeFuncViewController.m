//
//  HCodeFuncViewController.m
//  TSS
//
//  Created by Chenfy on 2020/11/25.
//  Copyright © 2020 Chenfy. All rights reserved.
//

#import "HCodeFuncViewController.h"
#import "LinkerPerson.h"

@interface HCodeFuncViewController ()
@property(nonatomic,strong)UIView *eView;

@property(nonatomic,copy)NSString *nameCopy;
@property(nonatomic,strong)NSString *nameStrong;

@property(nonatomic,strong)NSMutableString *muteName;

@property(nonatomic,copy)NSNumber *number;

@end

@implementation HCodeFuncViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self testCodeBinary];
    [self testCodeFunction];
    [self testCodeChain];
    // Do any additional setup after loading the view.
}

//位运算
- (void)testCodeBinary {
    LinkerPerson *pp = [LinkerPerson new];
    pp.food = PFoodType_apple | PFoodType_banana;
    
    [pp showFood];
}
//函数式编程
- (void)testCodeFunction {
    LinkerPerson *pp = [LinkerPerson new];
    [pp setName:@"hello zhagnsan!"];
}
//链式编程
- (void)testCodeChain {
    LinkerPerson *pp = [LinkerPerson new];
    [[pp eat]drink];

    [pp smile];
    pp.smile();
    
    pp.nameCall(@"hello").ageCall(25);
    pp.name(@"zhangsan").age(22);
}

//copy 、strong、weak
- (void)testRetainCount {
     //strong UIView
     NSLog(@"retainCount--UIView--%d",[[UIView new] retainCount]);
     self.eView = [UIView new];
     NSLog(@"retainCount--UIView--%d",[_eView retainCount]);
     [self.view addSubview:self.eView];
     NSLog(@"retainCount--UIView--%d",[_eView retainCount]);
    
     //strong NSMutableString
     NSLog(@"retainCount--NSMutableString--%d",[[[NSMutableString alloc]initWithString:@"hook"] retainCount]);
     self.muteName = [[NSMutableString alloc]initWithString:@"hook"];
     NSLog(@"retainCount--NSMutableString--%d",[_muteName retainCount]);

     //copy NSString
     NSLog(@"retainCount--NSString--%d",[[[NSString alloc]initWithFormat:@"hello"] retainCount]);
     self.nameCopy = [[NSString alloc]initWithFormat:@"hello"];
     [self.nameCopy retain];
     [self.nameCopy retain];

     NSLog(@"retainCount--NSString--%d",[_nameCopy retainCount]);

     //copy NSNumber
     NSLog(@"retainCount--NSNumber--%d",[[NSNumber numberWithInt:5] retainCount]);
     self.number = [NSNumber numberWithInt:4];
     NSLog(@"retainCount--NSNumber--%d",[self.number retainCount]);

    NSString *string = nil;
    @autoreleasepool {
         string = [[NSString alloc]initWithFormat:@"hello"];
    }
    
    NSLog(@"viewDidLoad--@autoreleasepool--%@",string);

    /* result
     2021-04-08 12:47:49.953058+0800 TestDoc[32442:770268] retainCount--UIView--1
     2021-04-08 12:47:49.953212+0800 TestDoc[32442:770268] retainCount--UIView--2
     2021-04-08 12:47:49.953333+0800 TestDoc[32442:770268] retainCount--UIView--3
     2021-04-08 12:47:49.953416+0800 TestDoc[32442:770268] retainCount--NSMutableString--1
     2021-04-08 12:47:49.953506+0800 TestDoc[32442:770268] retainCount--NSMutableString--2
     2021-04-08 12:47:49.953600+0800 TestDoc[32442:770268] retainCount--NSString---1
     2021-04-08 12:47:49.953686+0800 TestDoc[32442:770268] retainCount--NSString---1
     2021-04-08 12:47:49.953760+0800 TestDoc[32442:770268] retainCount--NSNumber---1
     2021-04-08 12:47:49.953845+0800 TestDoc[32442:770268] retainCount--NSNumber---1
     2021-04-08 12:47:49.953936+0800 TestDoc[32442:770268] viewDidLoad--@autoreleasepool--hello
     2021-04-08 12:47:49.963187+0800 TestDoc[32442:770268] viewWillAppear----(null)
     2021-04-08 12:47:49.978636+0800 TestDoc[32442:770268] viewDidAppear----(null)
     */
    
    int index[10];
    int indexA[10] = {0};
    int indexB[10] = {-1};

    int i = 0;
    while ( i < 10) {
        NSLog(@"-index---:%d",index[i]);
        NSLog(@"-indexA---:%d",indexA[i]);
        NSLog(@"-indexB---:%d",indexB[i]);
        
        i++;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)testRunLoop {
    self.stop = NO;
    
    __weak typeof (self)weakself = self;
    self.thread = [[MMThread alloc]initWithBlock:^{
        NSLog(@"--MMThread-------begin-----%@--",[NSThread currentThread]);
          
        [[NSRunLoop currentRunLoop]addPort:[NSPort new] forMode:NSDefaultRunLoopMode];

        NSLog(@"weakself--01---:%@",weakself);
        while (weakself && !weakself.isStop) {
            NSLog(@"weakself--02---:%@",weakself);

            [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        
        NSLog(@"--MMThread-------end-----%@--",[NSThread currentThread]);
    }];
    [self.thread start];
}

- (void)runInThread {
    NSLog(@"---------runInThread-----%@--",[NSThread currentThread]);
}

- (void)stopThread {
    if (self.thread) {
        [self performSelector:@selector(exitThread) onThread:self.thread withObject:nil waitUntilDone:YES];
    }
}

- (void)exitThread {
    self.stop = YES;
    CFRunLoopStop(CFRunLoopGetCurrent());
    self.thread = nil;
    NSLog(@"---------exitThread-----%@--",[NSThread currentThread]);
}

- (void)dealloc {
    NSLog(@"-----%s---",__func__);
    [self stopThread];
}


- (void)predicate_Test {
    UIButton *d = nil;
    NSPredicate *pr = [NSPredicate predicateWithFormat:@"name=%@",@"lisi"];
    NSArray *arr = @[];
    NSArray *res = [arr filteredArrayUsingPredicate:pr];
    
}
@end
