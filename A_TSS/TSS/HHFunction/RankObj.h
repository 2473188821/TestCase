//
//  HHRankObj.h
//  TSS
//
//  Created by Chenfy on 2020/10/12.
//  Copyright © 2020 Chenfy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RankObj : NSObject
#pragma mark -- 获取随机数
+ (int)getRandomNumber:(int)limit;

#pragma mark -- 获取可变随机数据
+ (NSMutableArray *)makeArray;
+ (NSMutableArray *)makeRandomArray;

// 1、快速排序
+ (void)quickSortArray:(NSMutableArray *)array leftIndex:(NSInteger)leftIndex rightIndex:(NSInteger)rightIndex;
// 2、冒泡排序
+ (void)bubbleSortArrayFalse:(NSMutableArray *)array;
+ (void)bubbleSortArrayFalseTrue:(NSMutableArray *)array;
+ (void)bubbleSortArrayFalseTrueBetter:(NSMutableArray *)array;
// 3、选择排序
+ (void)selectSortArray:(NSMutableArray *)array;
// 4、插入排序
+ (void)insertSortArray:(NSMutableArray *)array;
// 5、希尔排序
+ (void)shellSortArray:(NSMutableArray *)list;
// 6、堆排序
+ (void)heapSort:(NSMutableArray *)list;
// 7、归并排序
+ (void)megerSortAscendingOrderSort:(NSMutableArray *)ascendingArr;

@end

NS_ASSUME_NONNULL_END
