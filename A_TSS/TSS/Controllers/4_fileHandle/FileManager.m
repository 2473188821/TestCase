//
//  FileManager.m
//  certManager
//
//  Created by Chenfy on 16/2/18.
//  Copyright © 2016年 BJCA. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager
/** 单例的实现 */
DEFINE_INSTANCE_CLASS(FileManager);

+(BOOL)fileExistValueInFile:(id)fileName {
    if (!fileName) {
        return NO;
    }
    NSString *filePath = [self documentPathForFile:fileName];
    NSDictionary *dicInfo = [[NSDictionary alloc]initWithContentsOfFile:filePath];
    if ([dicInfo count] == 0) {
        return NO;
    }
    return YES;
}
+(BOOL)fileContainValueForKey:(id)key  inFile:(id)fileName {
    if (!key || !fileName) {
        return  NO;
    }
    NSString *path = [self documentPathForFile:fileName];
    NSDictionary *dicInfo = [[NSDictionary alloc]initWithContentsOfFile:path];
    if ([dicInfo count] == 0) {
        return NO;
    }
    id obj = dicInfo[key];
    if (obj == nil) {
        return NO;
    }
    return YES;
}

+(NSDictionary *)fileValueInFile:(id)fileName {
    if (![self fileExistValueInFile:fileName]) {
        return nil;
    }
    NSString *filePath = [self documentPathForFile:fileName];
    NSDictionary *dicInfo = [[NSDictionary alloc]initWithContentsOfFile:filePath];
    return dicInfo;
}

+(id)fileValueForKey:(id)key  inFile:(id)fileName {
    if (![self fileContainValueForKey:key inFile:fileName]) {
        return nil;
    }
    NSString *filePath = [self documentPathForFile:fileName];
    NSDictionary *dicInfo = [[NSDictionary alloc]initWithContentsOfFile:filePath];
    id obj = dicInfo[key];
    return obj;
}

+(BOOL)fileSaveValue:(NSDictionary *)value inFile:(id)fileName {
    if (value == nil || fileName == nil || [value count] == 0) {
        return NO;
    }
    NSString *path = [self documentPathForFile:fileName];
    return [value writeToFile:path atomically:YES];
}
+(BOOL)fileSaveValue:(id)value forKey:(id)key inFile:(id)fileName {
    if (value == nil || key == nil || fileName == nil || [fileName length] == 0) {
        return NO;
    }
    NSMutableDictionary *dicInfo = [[self fileValueInFile:fileName] mutableCopy];
    if (dicInfo == nil) {
        dicInfo = [NSMutableDictionary dictionary];
    }
    [dicInfo setObject:value  forKey:key];
    NSString *filePath = [self documentPathForFile:fileName];
    return [dicInfo writeToFile:filePath atomically:YES];
}

+(BOOL)fileRemoveFileValue:(id)fileName {
    if (!fileName) {
        return NO;
    }
    NSDictionary *dic = [NSDictionary dictionary];
    NSString *filePath = [self documentPathForFile:fileName];
    return [dic writeToFile:filePath atomically:YES];
}
+(BOOL)fileRemoveValueForKey:(id)key  inFile:(id)fileName {
    if (key == nil || fileName == nil || [fileName length] == 0) {
        return NO;
    }
    NSMutableDictionary *dicInfo = [[self fileValueInFile:fileName] mutableCopy];
    if (dicInfo == nil) {
        dicInfo = [NSMutableDictionary dictionary];
    }
    [dicInfo removeObjectForKey:key];
    NSString *filePath = [self documentPathForFile:fileName];
    return [dicInfo writeToFile:filePath atomically:YES];
}

+(NSString *)documentPathForFile:(id)fileName {
    if (!fileName) {
        return  nil;
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path = [NSString stringWithFormat:@"%@/%@",paths[0],fileName];
    return path;
}



//---------------------保存错误日志-----------------
/**
 *  保存错误日志到一个文件
 *
 *  @param value    批量数据
 *  @param fileName 文件名
 *  存储过程以日期为Key
 *  @return 结果
 */
+(BOOL)fileSaveErrorValue:(NSArray *)value  inFile:(NSString *)fileName {
    if (value == nil || fileName == nil || [value count] == 0) {
        return NO;
    }
    if (![value isKindOfClass:[NSArray class]]) {
        return NO;
    }
    NSString *path = [self documentPathForFile:fileName];
    
    NSMutableDictionary *dicError = [[self fileValueInFile:fileName] mutableCopy];
    if (dicError == nil) {
        dicError = [NSMutableDictionary dictionary];
    }
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localeDate = [date  dateByAddingTimeInterval:interval];
    NSString *newKey = [NSString stringWithFormat:@"%@",localeDate];
    NSMutableDictionary *dic = [dicError mutableCopy];
    [dic setObject:value forKey:newKey];
    return [dic writeToFile:path atomically:YES];
}

/**
 *  获取错误日志信息
 *
 *  @param fileName 错误文件
 *
 *  @return 返回结果
 */
+(NSDictionary *)fileErrorInFile:(NSString *)fileName {
    if (!fileName) {
        return nil;
    }
    NSString *path = [self documentPathForFile:fileName];
    NSDictionary *dicError = [[NSDictionary alloc]initWithContentsOfFile:path];
    return dicError;
}






@end
