//
//  AppDelegate.h
//  TSS
//
//  Created by Chenfy on 2020/8/24.
//  Copyright © 2020 Chenfy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow * window;
@property (assign, nonatomic) BOOL shouldNeedLandscape;//是否需要横屏


@property(nonatomic,copy)NSString *name;

@end

