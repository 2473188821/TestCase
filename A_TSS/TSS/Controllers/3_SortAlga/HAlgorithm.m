//
//  HAlgorithm.m
//  TSS
//
//  Created by Chenfy on 2021/9/27.
//  Copyright © 2021 Chenfy. All rights reserved.
//

#import "HAlgorithm.h"

@implementation HAlgorithm

- (void)testKillNumber:(int)killNumber list:(NSArray *)list {
    NSMutableArray *temp = [NSMutableArray array];
    for (int i = 1; i < 101; i ++) {
        [temp addObject:@(i)];
    }
    // 3 6 1 5 2 8
    NSMutableArray *op = temp;
    NSInteger count = [op count];

    NSInteger killNum = 5;
    NSInteger killIndex = 1;
    
    NSInteger index = 0;
    
    while (count > 1) {
        if (index == count) {
            index = 0;
        }
        
        if (killIndex == killNum) {
            killIndex = 0;
            
            NSInteger ttp = [[op objectAtIndex:index]integerValue];
            NSLog(@"removeObjectAtIndex---index:<%ld>---value:(%ld)-",(long)index,ttp);
            [op removeObjectAtIndex:index];

            index--;
            count--;
        }
        killIndex++;
        index++;
    }
    
    NSLog(@"live ---- :%@",temp);

}

@end
