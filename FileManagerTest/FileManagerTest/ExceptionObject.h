//
//  ExceptionObject.h
//  certManage
//
//  Created by Chenfy on 16/8/17.
//  Copyright © 2016年 BJCA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExceptionObject : NSObject

/**
 *  单例
 *
 *  @return 实例对象
 */
+(instancetype)shareInstance;

/**
 *  存储捕获的异常
 *
 *  @param arrayError 一个异常数组
 *
 *  @return 存储状态－成功｜失败
 */
+ (BOOL)exceptionErrorSave:(NSArray *)arrayError;

/**
 *  读取捕获的异常
 *
 *  @return 异常数据
 */
+ (NSDictionary *)exceptionErrors;


@end
