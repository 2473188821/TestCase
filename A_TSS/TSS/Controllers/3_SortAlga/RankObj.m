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
+ (int)getRandomNumber:(int)limit {
    if (limit < 0) {
        limit = 1;
    }
    int y = (arc4random() % limit);
    return y;
}

+ (NSMutableArray *)makeArray {
    NSMutableArray *arr = [@[@3 , @1 ,@7 ,@2 ,  @0 , @6 ,@9 ,@12 ,@8 ,@4 ,@5] mutableCopy];
    
    return arr;
}

+ (NSMutableArray *)makeRandomArray {
    int count = 10;
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count ; i++ ) {
        int rv = [self getRandomNumber:20];
        if (![arr containsObject:@(rv)]) {
            [arr addObject:@(rv)];
        }
    }
    NSLog(@"Product Random Array: %@ ",arr);
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

+ (void)bubbleSortArrayFalse:(NSMutableArray *)array {
    NSMutableArray * arr = array;
    for (int i = 0; i < arr.count; i++) {
        for (int j = i+1; j < arr.count; j++) {
            if ([arr[i] intValue] > [arr[j] intValue]) {
                [arr exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
}

+ (void)bubbleSortArrayFalseTrue:(NSMutableArray *)array {
    int count  = 0;
    int forcount  = 0;
    NSMutableArray * arr = array;
    
    for (int i = 0; i < arr.count; i++) {
        forcount++;
        // 依次定位左边的
        for (int j = (int)arr.count-2; j >= i; j--) {
            count++;
            if ([arr[j] intValue]< [arr[j+1] intValue]) {
                [arr exchangeObjectAtIndex:j withObjectAtIndex:j+1];
            }
        }
    }
    NSLog(@"循环次数：%d",forcount);
    NSLog(@"共%d次比较",count);
}

+ (void)bubbleSortArrayFalseTrueBetter:(NSMutableArray *)array {
    int count  = 0;
    int forcount  = 0;
    BOOL flag = YES;
    NSMutableArray * arr = array;
    
    for (NSInteger i = 0; i < arr.count && flag; i++) {
        forcount++;
        flag = NO;
        for (NSInteger j = arr.count-2; j >= i; j--) {
            count++;
            if ([arr[j] intValue]< [arr[j+1] intValue]) {
                [arr exchangeObjectAtIndex:j withObjectAtIndex:j+1];
                flag = YES;
            }
        }
    }
    NSLog(@"循环次数：%d",forcount);
    NSLog(@"共%d次比较",count);
    
    NSLog(@"final----:%@",arr);
}

+ (void)selectSortArray:(NSMutableArray *)array {
    NSMutableArray *arr = array;
    int min = 0, arrCount = (int)arr.count;
    for (int i = 0; i < arrCount-1; i++) {
        min = i;
        for (int j = i + 1; j < arrCount; j++) {
            if ([arr[min]integerValue] > [arr[j] integerValue]) {  /*如果有小于当前的最小值的关键字*/
                min = j;  /*将此关键字的下标赋值给min*/
            }
        }
        if (i != min) {  /*若min不等于i，说明找到最小值，交换*/
            [arr exchangeObjectAtIndex:i withObjectAtIndex:min];
        }
    }
    NSLog(@"final----:%@",arr);
}


+ (void)insertSortArray:(NSMutableArray *)array {
    NSMutableArray * arr = array;
    for (int i = 1; i < arr.count; i++) {
        int j = i;  /* j是一个坑， 确定坑的位置，再把数从坑里取出来，注意顺序*/
        id temp = arr[i]; /* temp 是从坑里取数*/
        if ([arr[i] intValue] < [arr[i-1] intValue]) {
            /* j > 0 防止越界。写&&前面效率更高
             * 与前面的元素逐个比较，如果当前元素小于前面元素，则将前面元素后移一位
             
             *从第二个开始，取出该位置的值为临时值temp，位置为j，
             此时j的位置为空，叫做坑，
             然后temp依次往前比较，直到找到比temp小，
             把temp插入该的位置，完成一次循环。
             */
            while (j > 0 && [temp intValue] < [arr[j-1] intValue]) {
                arr[j] = arr[j-1];
                j--;
            }
            arr[j] = temp;
        }
    }
}

//起始间隔值gap设置为总数的一半，直到gap==1结束
+ (void)shellSortArray:(NSMutableArray *)list {
    int times = 2;
    int gap = (int)list.count / times ;
    while (gap >= 1) {
        for(int i = gap ; i < [list count]; i++) {
            int j = i;
            NSInteger temp = [list[i] intValue];
            
            while (j >= gap && temp < [list[(j - gap)] intValue]) {
                list[j] = list[j - gap];
                j -= gap;
            }
            list[j] = @(temp);
        }
        gap = gap / times;
    }
}

+ (void)heapSort:(NSMutableArray *)list
{
    NSInteger i ,size;
    size = list.count;
    //找出最大的元素放到堆顶
    for (i= list.count/2-1; i>=0; i--) {
        [self createBiggesHeap:list withSize:size beIndex:i];
    }
     
    while(size > 0){
        [list exchangeObjectAtIndex:size-1 withObjectAtIndex:0]; //将根(最大) 与数组最末交换
        size -- ;//树大小减小
        [self createBiggesHeap:list withSize:size beIndex:0];
    }
    NSLog(@"%@",list);
}

+ (void)createBiggesHeap:(NSMutableArray *)list withSize:(NSInteger) size beIndex:(NSInteger)element
{
    //左右子树
    NSInteger lchild = element * 2 + 1;
    NSInteger rchild = lchild + 1;
    
    //子树均在范围内
    while (rchild < size) {
        //如果root节点比左右子树都大，完成整理
        if ([list[element] integerValue] >= [list[lchild] integerValue] &&
            [list[element] integerValue] >= [list[rchild]integerValue])
            return;
        
        //如果左边最大
        if ([list[lchild] integerValue] > [list[rchild] integerValue]) {
            //把左面的提到上面
            [list exchangeObjectAtIndex:element withObjectAtIndex:lchild];
            element = lchild; //循环时整理子树
            
        } else {//否则右面最大
            [list exchangeObjectAtIndex:element withObjectAtIndex:rchild];
            element = rchild;
        }
        
        //重新计算子树位置
        lchild = element * 2 + 1;
        rchild = lchild + 1;
    }
    //只有左子树且子树大于自己root节点
    if (lchild < size && [list[lchild] integerValue] > [list[element] integerValue]) {
        [list exchangeObjectAtIndex:lchild withObjectAtIndex:element];
    }
}


+ (void)megerSortAscendingOrderSort:(NSMutableArray *)ascendingArr {
    //tempArray数组里存放ascendingArr个数组，每个数组包含一个元素
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:1];
    for (NSNumber *num in ascendingArr) {
        NSMutableArray *subArray = [NSMutableArray array];
        [subArray addObject:num];
        [tempArray addObject:subArray];
    }
    //开始合并为一个数组
    while (tempArray.count != 1) {
        NSInteger i = 0;
        while (i < tempArray.count - 1) {
            tempArray[i] = [self mergeArrayFirstList:tempArray[i] secondList:tempArray[i + 1]];
            [tempArray removeObjectAtIndex:i + 1];
            i++;
        }
    }
    NSLog(@"归并升序排序结果：%@", tempArray[0]);
}

+ (NSArray *)mergeArrayFirstList:(NSArray *)array1 secondList:(NSArray *)array2 {
    NSMutableArray *resultArray = [NSMutableArray array];
    NSInteger firstIndex = 0, secondIndex = 0;
    while (firstIndex < array1.count && secondIndex < array2.count) {
        if ([array1[firstIndex] floatValue] < [array2[secondIndex] floatValue]) {
            [resultArray addObject:array1[firstIndex]];
            firstIndex++;
        } else {
            [resultArray addObject:array2[secondIndex]];
            secondIndex++;
        }
    }
    while (firstIndex < array1.count) {
        [resultArray addObject:array1[firstIndex]];
        firstIndex++;
    }
    while (secondIndex < array2.count) {
        [resultArray addObject:array2[secondIndex]];
        secondIndex++;
    }
    return resultArray.copy;
}









@end
