//
//  HCreditSubject.m
//  HelloWorld
//
//  Created by Chenfy on 2022/3/31.
//  Copyright © 2022 Chenfy. All rights reserved.
//

#import "HCreditSubject.h"

@interface HCreditSubject()
@property (nonatomic, assign) NSUInteger credit;
@property (nonatomic, strong) NSMutableArray *blockArray;
@end

@implementation HCreditSubject

+ (HCreditSubject *)create {
    HCreditSubject *subject = [[self alloc] init];
    return subject;
}

- (HCreditSubject *)sendNext:(NSUInteger)credit {
    self.credit = credit;
    if (self.blockArray.count > 0) {
        for (SubscribeNextActionBlock block in self.blockArray) {
            block(self.credit);
        }
    }
    return self;
}

- (HCreditSubject *)subscribeNext:(SubscribeNextActionBlock)block {
    if (block) {
        block(self.credit);
    }
    [self.blockArray addObject:block];
    return self;
}

#pragma mark - Getter
- (NSMutableArray *)blockArray {
    if (!_blockArray) {
        _blockArray = [NSMutableArray array];
    }
    return _blockArray;
}

@end
