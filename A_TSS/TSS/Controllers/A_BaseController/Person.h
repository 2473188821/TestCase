//
//  Person.h
//  TSS
//
//  Created by Chenfy on 2022/4/25.
//  Copyright © 2022 Chenfy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject
@property(nonatomic,copy)NSString *name;

- (void)print;
@end

NS_ASSUME_NONNULL_END
