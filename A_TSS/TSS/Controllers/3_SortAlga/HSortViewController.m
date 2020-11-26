//
//  HSortViewController.m
//  TSS
//
//  Created by Chenfy on 2020/11/23.
//  Copyright © 2020 Chenfy. All rights reserved.
//

#import "HSortViewController.h"
#import "RankObj.h"
#import "Person.h"

@interface HSortViewController ()

@end

@implementation HSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *arr = [RankObj makeArray];
    NSInteger size = [arr count];
    
    /*
     [self quickSort:arr leftIndex:0 rightIndex:size - 1];
     [self bubbleSortFalse:arr];
     [self bubbleSortTrue:arr];
     [self bubbleSortTrueBetter:arr];
     [self selectSort:arr];
     [self insertSort:arr];
     [self shellSort:arr];
     [self heapSort:arr];
     [self mergeSort:arr];

     [self logArray:arr];
     */

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


- (void)logArray:(NSMutableArray *)arr {
    NSLog(@"array---:%@",arr);
}

//7、归并排序
- (void)mergeSort:(NSMutableArray *)array {
    NSMutableArray *tempArr = [NSMutableArray array];
    
    for (NSNumber *num in array) {
        NSArray *arr = @[num];
        [tempArr addObject:arr];
    }
    
    while ([tempArr count] != 1) {
        NSInteger i = 0;
        
        while (i < [tempArr count] - 1) {
            tempArr[i] = [self megeListA:tempArr[i] list:tempArr[i + 1]];
            [tempArr removeObjectAtIndex:i + 1];
            i++ ;
        }
    }
    NSLog(@"array---:%@",tempArr);
}

- (NSMutableArray *)megeListA:(NSMutableArray *)listA list:(NSMutableArray *)listB {
    
    NSInteger aIndex = 0;
    NSInteger bIndex = 0;
    NSMutableArray *temp = [NSMutableArray array];
    
    while (aIndex < listA.count && bIndex < listB.count) {
        if ([listA[aIndex]integerValue] < [listB[bIndex]integerValue]) {
            [temp addObject:listA[aIndex]];
            aIndex++;
        } else {
            [temp addObject:listB[bIndex]];
            bIndex++;
        }
    }
    
    while (aIndex < listA.count) {
        [temp addObject:listA[aIndex]];
        aIndex++;
    }
    while (bIndex < listB.count) {
        [temp addObject:listB[bIndex]];
        bIndex++;
    }
    return temp;
}


//6、堆排序
- (void)heapSort:(NSMutableArray *)array {
    NSInteger size = [array count];
    
    for (NSInteger i = size/2 -1; i >= 0; i--) {
        [self makeBiggestHeap:array size:size beIndex:i];
    }
    
    while (size > 0) {
        [array exchangeObjectAtIndex:0 withObjectAtIndex:size - 1];
        size --;
        [self makeBiggestHeap:array size:size beIndex:0];
    }
}

- (void)makeBiggestHeap:(NSMutableArray *)list size:(NSInteger)size beIndex:(NSInteger)index {
    NSInteger element = index;
    NSInteger lchild = element * 2 + 1;
    NSInteger rchild = lchild + 1;
    
    while (rchild < size) {
        NSInteger eValue = [list[element]integerValue];
        NSInteger lValue = [list[lchild]integerValue];
        NSInteger rValue = [list[rchild]integerValue];
        
        if (eValue >= lValue && eValue >= rValue) return;
        
        if (lValue > rValue) {
            [list exchangeObjectAtIndex:element withObjectAtIndex:lchild];
            element = lchild;
        } else {
            [list exchangeObjectAtIndex:element withObjectAtIndex:rchild];
            element = rchild;
        }
        lchild = element * 2 + 1;
        rchild = lchild + 1;
    }
    
    if (lchild < size && [list[lchild]integerValue] > [list[element]integerValue]) {
        [list exchangeObjectAtIndex:lchild withObjectAtIndex:element];
    }
}

//5、希尔排序
- (void)shellSort:(NSMutableArray *)array {
    NSInteger size = [array count];
    NSInteger gap = size/2;
    
    while (gap > 0) {
        for (NSInteger i = gap; i < size; i++) {
            
            NSInteger key = [array[i]integerValue];
            NSInteger j = i;
            if (key < [array[j - gap]integerValue]) {
                
                while (j >= gap && [array[j - gap]integerValue] > key) {
                    array[j] = array[j - gap];
                    j = j - gap;
                }
                array[j] = @(key);
            }
        }
        gap = gap/2;
    }
}

//4、插入排序
- (void)insertSort:(NSMutableArray *)array {
    NSInteger size = [array count];
    
    for (NSInteger i = 1; i < size; i++) {
        NSInteger key = [array[i]integerValue];
        NSInteger j = i;
        
        if ([array[j]integerValue] < [array[j - 1]integerValue]) {
            while (j > 0 && [array[j - 1]integerValue] > key) {
                array[j] = array[j - 1];
                j--;
            }
            array[j] = @(key);
        }
    }
}

//3、选择排序
- (void)selectSort:(NSMutableArray *)array {
    NSInteger size = [array count];
    
    for (NSInteger i = 0; i < size; i++) {
        NSInteger min = i;
        
        for (NSInteger j = i; j < size; j++) {
            if ([array[min]integerValue] > [array[j]integerValue]) {
                min = j;
            }
        }
        if (min != i) {
            [array exchangeObjectAtIndex:min withObjectAtIndex:i];
        }
    }
}

//2-2 冒泡排序优化
- (void)bubbleSortTrueBetter:(NSMutableArray *)array {
    NSInteger size = [array count];
    
    BOOL flag = YES;
    for (NSInteger i = 0; i < size && flag; i++) {
        flag = NO;
        for (NSInteger j = size - 2; j >= i; j--) {
            if ([array[j + 1]integerValue] <= [array[j]integerValue]) {
                [array exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                flag = YES;
            }
        }
    }
}

//2-1 真冒泡排序
- (void)bubbleSortTrue:(NSMutableArray *)array {
    NSInteger size = [array count];
    
    for (NSInteger i = 0; i < size; i++) {
        
        for (NSInteger j = size - 2; j >= i; j--) {
            if ([array[j + 1]integerValue] <= [array[j]integerValue]) {
                [array exchangeObjectAtIndex:j withObjectAtIndex:j+1];
            }
        }
    }
}

//2、伪冒泡排序
- (void)bubbleSortFalse:(NSMutableArray *)array {
    NSInteger size = [array count];
    for (NSInteger i = 0; i < size; i++) {
        for (NSInteger j = i + 1; j < size; j++) {
            if ([array[i]integerValue] > [array[j]integerValue]) {
                [array exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
}

//1、快速排序
- (void)quickSort:(NSMutableArray *)list leftIndex:(NSInteger)left rightIndex:(NSInteger)right {
    if ([list count] < 2 || left >= right) {
        return;
    }
    NSInteger i = left;
    NSInteger j = right;
    NSInteger key = [list[i]integerValue];
    
    while (i < j) {
        
        while (i < j && [list[j]integerValue] >= key) {
            j--;
        }
        list[i] = list[j];
        
        while (i < j && [list[i]integerValue] <= key) {
            i++;
        }
        list[j] = list[i];
    }
    list[i] = @(key);
    [self quickSort:list leftIndex:left rightIndex:i -1];
    [self quickSort:list leftIndex:i + 1 rightIndex:right];
}

@end
