//
//  HGCDViewController.h
//  TSS
//
//  Created by Chenfy on 2022/4/18.
//  Copyright © 2022 Chenfy. All rights reserved.
//

#import "HHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HGCDViewController : HHBaseViewController

+ (instancetype)sharedLiveRoom;

- (void)setbackGroundColor:(UIColor *)color;

- (void)openLiveRoomWithModelPush:(UINavigationController *)navVC animated:(BOOL)animated;
- (void)openLiveRoomWithModelPresent:(UIViewController *)present animated: (BOOL)flag completion:(void (^ __nullable)(void))completion;

+ (void)destroy;


@end

NS_ASSUME_NONNULL_END
