//
//  KKK.h
//  TestDoc
//
//  Created by Chenfy on 2021/4/5.
//  Copyright © 2021 Chenfy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKK : NSObject
@property(nonatomic,copy)NSString *name;

+ (id)shareInstance;
- (void)dellocInstance;

@end


NS_ASSUME_NONNULL_END
