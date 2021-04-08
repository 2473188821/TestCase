//
//  ParentObj+ParentCategory.h
//  TSS
//
//  Created by Chenfy on 2021/4/6.
//  Copyright © 2021 Chenfy. All rights reserved.
//

#import "ParentObj.h"

NS_ASSUME_NONNULL_BEGIN

@interface ParentObj (ParentCategory)

- (void)hk_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context;

@end

NS_ASSUME_NONNULL_END
