//
//  FileManager.h
//  certManager
//
//  Created by Chenfy on 16/2/18.
//  Copyright © 2016年 BJCA. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 单例文件声明 */
//单例宏文件头
#define DEFINE_INSTANCE_HEALDER(className)\
\
+(className *)shared##className;

//单例宏文件实现
#define DEFINE_INSTANCE_CLASS(className)\
\
+(className *)shared##className { \
static className *shared##className = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared##className = [[self alloc] init]; \
}); \
return shared##className; \
}


@interface FileManager : NSObject
/** 单例声明 */
DEFINE_INSTANCE_HEALDER(FileManager);

/**
 *  检测对应文件是否存在数据
 *
 *  @param fileName 文件名
 *
 *  @return 结果
 */
+(BOOL)fileExistValueInFile:(id)fileName;

/**
 *  检测对应文件，相对于key是否存在数据
 *
 *  @param key      关键字 key
 *  @param fileName 文件名
 *
 *  @return 结果
 */
+(BOOL)fileContainValueForKey:(id)key  inFile:(id)fileName;

/**
 *  得到对应文件下的所有数据
 *
 *  @param fileName 文件名
 *
 *  @return 数据
 */
+(NSDictionary *)fileValueInFile:(id)fileName;

/**
 *  根据文件名和关键字取值
 *
 *  @param key      关键字key
 *  @param fileName 文件名
 *
 *  @return 获取的数据
 */
+(id)fileValueForKey:(id)key  inFile:(id)fileName;

/**
 *  保存批量数据到一个文件
 *
 *  @param value    批量数据
 *  @param fileName 文件名
 *
 *  @return 结果
 */
+(BOOL)fileSaveValue:(id)value  inFile:(id)fileName;

/**
 *  保存单个数据到一个文件下
 *
 *  @param value    数据
 *  @param key      关键字key
 *  @param fileName 文件名
 *
 *  @return 结果
 */
+(BOOL)fileSaveValue:(id)value forKey:(id)key  inFile:(id)fileName;

/**
 *  移除某个文件下的数据
 *
 *  @param fileName 文件名
 *
 *  @return 结果
 */
+(BOOL)fileRemoveFileValue:(id)fileName;

/**
 *  移除单个数据
 *
 *  @param key      关键字
 *  @param fileName 文件名
 *
 *  @return 结果
 */
+(BOOL)fileRemoveValueForKey:(id)key  inFile:(id)fileName;

/**
 *  得到对应文件的路径
 *
 *  @param fileName 文件名
 *
 *  @return 路径
 */
+(NSString *)documentPathForFile:(id)fileName;

//---------------------保存错误日志-----------------
/**
 *  保存错误日志到一个文件
 *
 *  @param value    批量数据
 *  @param fileName 文件名
 *
 *  @return 结果
 */
+(BOOL)fileSaveErrorValue:(NSArray *)value  inFile:(id)fileName;

/**
 *  获取错误日志信息
 *
 *  @param fileName 错误文件
 *
 *  @return 返回结果
 */
+(NSDictionary *)fileErrorInFile:(id)fileName;




@end
