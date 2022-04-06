//
//  Student.m
//  HelloWorld
//
//  Created by Chenfy on 2022/3/31.
//  Copyright © 2022 Chenfy. All rights reserved.
//

#import "Student.h"

@interface Student()
@property(nonatomic,copy)NSString *name;
@property(nonatomic,assign)HGender gender;
@property(nonatomic,assign)NSInteger number;

@property (nonatomic, strong) SatisfyActionBlock satisfyBlock;

@end

@implementation Student

+ (Student *)create {
    Student *st = [Student new];
    return st;
}

- (Student *)name:(NSString *)name {
    _name = name;
    return self;
}

- (Student *)gender:(HGender)gender {
    _gender = gender;
    return self;
}

- (Student *)number:(NSInteger)number {
    _number = number;
    return self;
}

- (Student *)sendCredit:(NSUInteger (^)(NSUInteger))updateCreditBlock {
    if (updateCreditBlock) {
        self.number = updateCreditBlock(self.number);
        if (self.satisfyBlock) {
            self.satisfyBlock(self.number);
        }
    }
    return self;
}

- (Student *)filterIsASatisfyCredit:(SatisfyActionBlock)satisfyBlock {
    if (satisfyBlock) {
        self.satisfyBlock = satisfyBlock;
    }
    return self;
}

- (HCreditSubject *)creditSubject {
    if (!_creditSubject) {
        _creditSubject = [HCreditSubject create];
    }
    return _creditSubject;
}

@end
