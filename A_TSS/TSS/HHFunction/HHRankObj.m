//
//  HHRankObj.m
//  TSS
//
//  Created by Chenfy on 2020/10/12.
//  Copyright © 2020 Chenfy. All rights reserved.
//

#import "RankObj.h"

@implementation RankObj

//+ 1.2 获取一个随机数范围在：[100,200]，包括100，包括200
+ (int)

//```objc
//int y =100 +  (arc4random() % 101);
//

+ (NSMutableArray *)makeArray {
    NSMutableArray *arr = [@[@9  , @3 , @1 ,@7 ,@2 ,  @0 , @6] mutableCopy];
    return arr;
}

+ (void)quickSortArray:(NSMutableArray *)array leftIndex:(NSInteger)leftIndex rightIndex:(NSInteger)rightIndex {
    
    if (leftIndex >= rightIndex) {//如果数组长度为0或1时返回
        return ;
    }
    NSInteger i = leftIndex;
    NSInteger j = rightIndex;
    //记录比较基准数
    NSInteger key = [array[i] integerValue];
    
    while (i < j) {
        /**** 首先从右边j开始查找比基准数小的值 ***/
        while (i < j && [array[j] integerValue] >= key) {//如果比基准数大，继续查找
            j--;
        }
        //如果比基准数小，则将查找到的小值调换到i的位置
        array[i] = array[j];
        
        /**** 当在右边查找到一个比基准数小的值时，就从i开始往后找比基准数大的值 ***/
        while (i < j && [array[i] integerValue] <= key) {//如果比基准数小，继续查找
            i++;
        }
        //如果比基准数大，则将查找到的大值调换到j的位置
        array[j] = array[i];
        
    }
    
    //将基准数放到正确位置
    array[i] = @(key);
    
    /**** 递归排序 ***/
    //排序基准数左边的
    [self quickSortArray:array leftIndex:leftIndex rightIndex:i - 1];
    //排序基准数右边的
    [self quickSortArray:array leftIndex:i + 1 rightIndex:rightIndex];
}

@end
