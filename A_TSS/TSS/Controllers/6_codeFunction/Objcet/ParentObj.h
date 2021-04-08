//
//  ParentObj.h
//  TSS
//
//  Created by Chenfy on 2021/4/6.
//  Copyright © 2021 Chenfy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>


NS_ASSUME_NONNULL_BEGIN

@interface ParentObj : NSObject

@property(nonatomic,copy)NSString *name;
@property(nonatomic,strong)NSMutableArray *array;


@end

NS_ASSUME_NONNULL_END
