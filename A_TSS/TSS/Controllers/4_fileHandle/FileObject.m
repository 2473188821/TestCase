//
//  FileObject.m
//  ObjectiveBridge
//
//  Created by Chenfy on 2019/10/9.
//  Copyright © 2019 Chenfy. All rights reserved.
//

#import "FileObject.h"
#import <sandbox.h>

@implementation FileObject

+ (NSString *)filePath
{
    //首先在本地创建一个文件（测试使用）
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *Path = [[paths lastObject] stringByAppendingFormat:@"/test12.txt"];
    NSLog(@"paht ---:%@",Path);
    return Path;
}

+ (void)initFile
{
    NSString *Path = [FileObject filePath];
    NSString *string = @"123456789";
    
    NSData *data=[string dataUsingEncoding:NSUTF8StringEncoding];
    
    [data writeToFile:Path atomically:YES];
}

+ (void)appendData
{
    NSString *Path = [FileObject filePath];
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
@end
