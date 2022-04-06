//
//  Student.h
//  HelloWorld
//
//  Created by Chenfy on 2022/3/31.
//  Copyright © 2022 Chenfy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCreditSubject.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,HGender) {
    HGender_Male,
    HGender_Femal
};

typedef BOOL(^SatisfyActionBlock)(NSUInteger credit);

@interface Student : NSObject
@property(nonatomic,strong)HCreditSubject *creditSubject;


+ (Student *)create;
- (Student *)name:(NSString *)name;
- (Student *)gender:(HGender)gender;
- (Student *)number:(NSInteger)number;

//积分相关
- (Student *)sendCredit:(NSUInteger(^)(NSUInteger credit))updateCreditBlock;
- (Student *)filterIsASatisfyCredit:(SatisfyActionBlock)satisfyBlock;

@end

NS_ASSUME_NONNULL_END
