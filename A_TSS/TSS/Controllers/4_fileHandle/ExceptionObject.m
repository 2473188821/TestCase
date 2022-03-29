//
//  ExceptionObject.m
//  certManage
//
//  Created by Chenfy on 16/8/17.
//  Copyright © 2016年 BJCA. All rights reserved.
//

#import "ExceptionObject.h"

//错误文件名字
#define     ErrorFileName       @"bjcaErrorFileName.plist"

@implementation ExceptionObject

//静态全局变量
static ExceptionObject *instance = nil;

/** 单利声明 */
+ (instancetype)shareInstance {
    //异常捕获
    @try {
        if (instance == nil) {
            instance = [[self alloc]init];
        }
    } @catch (NSException *exception) {
        //存储异常日志
        NSString *errorMsg = [NSString stringWithFormat:@"%@",exception];
        NSArray *arrayError = @[errorMsg];
        [ExceptionObject exceptionErrorSave:arrayError];
        return nil;
    }
    return instance;
}


/** 存储捕获的异常 */
+ (BOOL)exceptionErrorSave:(NSArray *)arrayError {
    if ([arrayError count] == 0) {
        return NO;
    }
    if (![arrayError isKindOfClass:[NSArray class]]) {
        return NO;
    }
    NSLog(@"exceptionErrorSave-:%@",arrayError);
    NSString *path = [self p_documentPathForFile:ErrorFileName];
    NSMutableDictionary *dicError = [[self p_fileValueInFile:ErrorFileName] mutableCopy];
    if (dicError == nil) {
        dicError = [NSMutableDictionary dictionary];
    }
    //存储日期
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localeDate = [date  dateByAddingTimeInterval:interval];
    NSLog(@"enddate=%@",localeDate);
    NSString *newKey = [NSString stringWithFormat:@"%@",localeDate];
    NSMutableDictionary *dic = [dicError mutableCopy];
    [dic setObject:arrayError forKey:newKey];
    return [dic writeToFile:path atomically:YES];
}

/** 读取捕获的异常 */
+ (NSDictionary *)exceptionErrors {
    NSString *path = [self p_documentPathForFile:ErrorFileName];
    NSDictionary *dicError = [[NSDictionary alloc]initWithContentsOfFile:path];
    return dicError;
}

//******************** 辅助功能 **************
/** 文件路径 */
+ (NSString *)p_documentPathForFile:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path = [NSString stringWithFormat:@"%@/%@",paths[0],fileName];
    return path;
}
/** 返回文件内的数据 */
+ (NSDictionary *)p_fileValueInFile:(NSString *)fileName {
    if (![self p_fileExistValueInFile:fileName]) {
        return nil;
    }
    NSString *filePath = [self p_documentPathForFile:fileName];
    NSDictionary *dicInfo = [[NSDictionary alloc]initWithContentsOfFile:filePath];
    return dicInfo;
}
/** 判断文件是否存在数据 */
+ (BOOL)p_fileExistValueInFile:(NSString *)fileName {
    NSString *filePath = [self p_documentPathForFile:fileName];
    NSDictionary *dicInfo = [[NSDictionary alloc]initWithContentsOfFile:filePath];
    if ([dicInfo count] == 0) {
        return NO;
    }
    return YES;
}




@end
