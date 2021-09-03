//
//  HCodeFuncViewController.h
//  TSS
//
//  Created by Chenfy on 2020/11/25.
//  Copyright © 2020 Chenfy. All rights reserved.
//

#import "HHBaseViewController.h"
#import "MMThread.h"

NS_ASSUME_NONNULL_BEGIN

@interface HCodeFuncViewController : HHBaseViewController

@property(nonatomic,strong)MMThread *thread;

@property(nonatomic,assign,getter=isStop)BOOL stop;

@end

NS_ASSUME_NONNULL_END
