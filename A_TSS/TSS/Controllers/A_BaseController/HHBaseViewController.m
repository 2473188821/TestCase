//
//  HHBaseViewController.m
//  TSS
//
//  Created by Chenfy on 2020/11/23.
//  Copyright © 2020 Chenfy. All rights reserved.
//

#import "HHBaseViewController.h"


@interface HHBaseViewController ()

@end

@implementation HHBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.lightGrayColor;
    
    [self fun_addControllerBackGesture];
    
    // Do any additional setup after loading the view.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -- function 添加回退手势
- (void)fun_addControllerBackGesture {
    UIScreenEdgePanGestureRecognizer *edgeGes = [[UIScreenEdgePanGestureRecognizer alloc]  initWithTarget: self  action:@selector(edgePan:)];
    edgeGes.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:edgeGes];
}

-(void)edgePan:(UIPanGestureRecognizer *)recognizer{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
 
#pragma mark -- function
- (void)fun_getAppContainnerPath {
    
}

#pragma mark -- 文件路径
- (NSString *)rootDirectory:(CCDirectoryRootType)type
{
    switch (type) {
        case CCDirectoryRootTypeHome:
            return [self homeDirectory];
            break;
        case CCDirectoryRootTypeDocuments:
            return [self documentDirectory];
            break;
        case CCDirectoryRootTypeLibrary:
            return [self libraryDirectory];
            break;
        case CCDirectoryRootTypeTemp:
            return [self tempDirectory];
            break;
        case CCDirectoryRootTypeCache:
            return [self cacheDirectory];
            break;
        case CCDirectoryDayTypeCCInfo:
            return [self directoryCCInfo];
    }
    return nil;
}

#pragma mark -- 根路径
- (NSString *)homeDirectory {
    // 获取沙盒根目录路径
    NSString*homeDir = NSHomeDirectory();
    return homeDir;
}
- (NSString *)documentDirectory {
    // 获取Documents目录路径
    NSString*docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject];
    return docDir;
}
- (NSString *)libraryDirectory {
    //获取Library的目录路径
    NSString*libDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES) lastObject];
    return libDir;
}
- (NSString *)cacheDirectory {
    // 获取cache目录路径
    NSString *cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) firstObject];
    return cachesDir;
}
- (NSString *)tempDirectory {
    // 获取tmp目录路径
    NSString*tmpDir =NSTemporaryDirectory();
    return tmpDir;
}

// CCInfo
- (NSString *)directoryCCInfo {
    //获取Document文件
    NSString * docsdir = [self documentDirectory];
    //在Document目录下创建 "CCInfo" 文件夹
    NSString *filePath = [docsdir stringByAppendingPathComponent:@"CCInfo"];
    return filePath;
}

- (void)createDirectoryCCInfo {
    //获取Document文件
    NSString *docsdir = [self documentDirectory];
    //在Document目录下创建 "CCInfo" 文件夹
    NSString *dataFilePath = [docsdir stringByAppendingPathComponent:@"CCInfo"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDir = NO;
    // fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
    BOOL existed = [fileManager fileExistsAtPath:dataFilePath isDirectory:&isDir];
    if (!(isDir && existed))
    {
        // 在Document目录下创建一个archiver目录
        [fileManager createDirectoryAtPath:dataFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

//日期格式化
- (NSString*)currentTimeString:(CCTimeType)type {
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *fm = @"";
    switch (type) {
        case CCTimeTypeYear: fm = @"yyyy";  break;
        case CCTimeTypeMonth: fm = @"yyyyMM"; break;
        case CCTimeTypeDay: fm = @"yyyyMMdd"; break;
        case CCTimeTypeHour: fm = @"yyyy-MM-dd HH"; break;
        case CCTimeTypeMin: fm = @"yyyy-MM-dd HH:mm"; break;
        case CCTimeTypeSecond: fm = @"yyyy-MM-dd HH:mm:ss"; break;
        case CCTimeTypeTimeStamp: fm = nil; break;
    }
    if (!fm) {
        NSTimeInterval timestamp = [[NSDate date]timeIntervalSince1970];
        NSString *str = [NSString stringWithFormat:@"%f",timestamp];
        return str;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:fm];
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    //----------将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
//    XXLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
}

#pragma mark -- 日志上报文件名
- (NSString*)fileNameTimeStringMIN {
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *fm = @"yyyyMMdd_HHmm";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:fm];
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    //----------将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
//    XXLog(@"currentTimeString =  %@",currentTimeString);
    return currentTimeString;
}


#pragma mark -- function 向文件写入数据
- (void)fun_addDataToFile {
    
}
- (void)fileAppendData:(NSData *)data path:(NSString *)path
{
    @try {
        NSString *Path = path;
        //追加数据
        NSFileHandle *fileHandle=[NSFileHandle fileHandleForWritingAtPath:Path];
        if (!fileHandle)
        {
            NSString *ss = @"-----start:----------";
            NSData *data = [ss dataUsingEncoding:NSUTF8StringEncoding];
            [data writeToFile:Path atomically:YES];
            fileHandle=[NSFileHandle fileHandleForWritingAtPath:Path];
        }
        [fileHandle seekToEndOfFile];//跳到文件末尾
        [fileHandle writeData:data];//写入
        [fileHandle closeFile];//关闭
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

#pragma mark -- function NSLog文件重定向
- (void)fun_redirectNSLog {
    
}

- (void)redirectNSLogToDocumentFolder {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *fileName =[NSString stringWithFormat:@"%@.log",[NSDate date]];
    NSString *logFilePath = [documentDirectory stringByAppendingPathComponent:fileName];
    NSLog(@"redirectNSLogToDocumentFolder-----:%@",logFilePath);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
}


- (void)nullCheck {
    
}

- (id)hhNullCheckValue:(id)value key:(NSString *)key {
    id tmp = value;
    if ([tmp isKindOfClass:[NSNull class]]) {
        NSLog(@"null---:%@",key);
        tmp = nil;
    } else {
        tmp = value[key];
    }

    return tmp;
}



@end
