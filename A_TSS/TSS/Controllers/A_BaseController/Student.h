//
//  Student.h
//  TSS
//
//  Created by Chenfy on 2022/4/25.
//  Copyright © 2022 Chenfy. All rights reserved.
//

#import "Person.h"

NS_ASSUME_NONNULL_BEGIN

@interface Student : Person
@property(nonatomic,copy)NSString *name;
@property(nonatomic,assign)int age;

- (void)test;
- (void)testAge:(NSInteger)age name:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
