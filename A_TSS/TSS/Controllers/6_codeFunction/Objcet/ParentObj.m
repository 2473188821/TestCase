//
//  ParentObj.m
//  TSS
//
//  Created by Chenfy on 2021/4/6.
//  Copyright © 2021 Chenfy. All rights reserved.
//

#import "ParentObj.h"

@implementation ParentObj

- (NSMutableArray *)array {
    if (!_array) {
        _array = NSMutableArray.array;
    }
    return _array;
}

- (void)setName:(NSString *)name {
    
}

- (void)modifyArray:(NSString *)obj {
    //监听容器类的KVO
    NSMutableArray *tempArr = [self mutableArrayValueForKey:@"array"];
    [tempArr addObject:obj];
}
@end
