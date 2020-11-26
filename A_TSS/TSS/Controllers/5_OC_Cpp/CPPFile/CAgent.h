//
//  CAgent.h
//  ObjectiveBridge
//
//  Created by Chenfy on 2019/8/25.
//  Copyright © 2019 Chenfy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CAgentDelegate <NSObject>

- (void)renderComplete:(NSString *)str;

@end

@interface CAgent : NSObject

@property(nonatomic,weak)id<CAgentDelegate>delegate;

- (void)initEngine;
- (void)startEngine:(NSString *)str;
- (int)getChannelList;
- (void)callbackInner;

@end

NS_ASSUME_NONNULL_END
