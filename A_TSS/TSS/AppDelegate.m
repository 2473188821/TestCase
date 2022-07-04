//
//  AppDelegate.m
//  TSS
//
//  Created by Chenfy on 2020/8/24.
//  Copyright © 2020 Chenfy. All rights reserved.
//

#import "AppDelegate.h"
#import "LinkerPerson.h"
#import "KMacro.h"

//int sum(int a, int b);

@interface AppDelegate ()
//此处是一个坑
@property(nonatomic,copy)NSMutableArray *array;

@end

@implementation AppDelegate

@synthesize name = _name;

- (NSString *)name {
    return _name;
}

- (void)setName:(NSString *)name {
    _name = name;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    
//    NSLog(@"汇编--sum--:%d",sum(3, 5));
    return YES;
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window
{
    NSLog(@"call---%d",self.shouldNeedLandscape);
    if (self.shouldNeedLandscape)
    {
        return UIInterfaceOrientationMaskLandscapeRight;
    }
    else
    {
        return UIInterfaceOrientationMaskPortrait;
    }
}




@end
