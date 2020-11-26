//
//  AppDelegate.m
//  TSS
//
//  Created by Chenfy on 2020/8/24.
//  Copyright © 2020 Chenfy. All rights reserved.
//

#import "AppDelegate.h"
#import "Person.h"
#import "KMacro.h"

@interface AppDelegate ()
//此处是一个坑
@property(nonatomic,copy)NSMutableArray *array;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
   
    /*
    self.array = [NSMutableArray array];
    [self.array addObject:@"1"];
    [self.array removeAllObjects];
*/
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
