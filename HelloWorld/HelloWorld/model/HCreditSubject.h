//
//  HCreditSubject.h
//  HelloWorld
//
//  Created by Chenfy on 2022/3/31.
//  Copyright © 2022 Chenfy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SubscribeNextActionBlock)(NSUInteger credit);

@interface HCreditSubject : NSObject
+ (HCreditSubject *)create;

- (HCreditSubject *)sendNext:(NSUInteger)credit;
- (HCreditSubject *)subscribeNext:(SubscribeNextActionBlock)block;

@end

NS_ASSUME_NONNULL_END
