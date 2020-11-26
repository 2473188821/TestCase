//
//  HFileViewController.m
//  TSS
//
//  Created by Chenfy on 2020/11/23.
//  Copyright © 2020 Chenfy. All rights reserved.
//

#import "HFileViewController.h"
#import "FileObject.h"

@interface HFileViewController ()

@end

@implementation HFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"NSFileHandle Test!");
    
    
    [self fileHandleTest];
    // Do any additional setup after loading the view.
}

- (void)fileHandleTest {
    //首先在本地创建一个文件（测试使用）
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *Path = [[paths lastObject] stringByAppendingFormat:@"/test12.txt"];
    NSLog(@"paht ---:%@",Path);

    NSString *string = @"123456789";
    NSData *data=[string dataUsingEncoding:NSUTF8StringEncoding];
    [data writeToFile:Path atomically:YES];

    //追加数据
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:Path];
    if (!fileHandle)
    {
        NSString *ss = @"start:";
        NSData *data = [ss dataUsingEncoding:NSUTF8StringEncoding];
        [data writeToFile:Path atomically:YES];
        fileHandle=[NSFileHandle fileHandleForWritingAtPath:Path];
    }
    [fileHandle seekToEndOfFile];//跳到文件末尾
    
    NSString *string1 = @"\n abcdefg";
    
    NSData *data1=[string1 dataUsingEncoding:NSUTF8StringEncoding];

    [fileHandle writeData:data1];//写入
    [fileHandle closeFile];//关闭
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)messTest {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:2];
    [arr addObject:@"123"];
    [arr addObject:@"234"];
    
    NSLog(@"arr---:%@",arr);
    
    NSString *new = @"789";
    NSMethodSignature *sig = [NSMutableArray instanceMethodSignatureForSelector:@selector(addObject:)];
    
    NSInvocation *inv =  [NSInvocation invocationWithMethodSignature:sig];
    [inv setTarget:arr];
    [inv setSelector:@selector(addObject:)];
    [inv setArgument:&new atIndex:2];
    [inv  invoke];
    
    NSLog(@"arr---:%@",arr);
}


@end
