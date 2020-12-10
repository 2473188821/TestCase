//
//  HHBaseViewController.h
//  TSS
//
//  Created by Chenfy on 2020/11/23.
//  Copyright © 2020 Chenfy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//SCREEN_SIZE 屏幕尺寸
#define KSCREEN_WIDTH   ([UIScreen mainScreen].bounds.size.width)
#define KSCREEN_HEIGTH  ([UIScreen mainScreen].bounds.size.height)

//获取时间数据
typedef NS_ENUM(NSInteger,CCTimeType) {
    CCTimeTypeYear,
    CCTimeTypeMonth,
    CCTimeTypeDay,
    CCTimeTypeHour,
    CCTimeTypeMin,
    CCTimeTypeSecond,
    CCTimeTypeTimeStamp
};

//获取系统目录路径
typedef NS_ENUM(NSInteger,CCDirectoryRootType) {
    CCDirectoryRootTypeHome,
    CCDirectoryRootTypeDocuments,
    CCDirectoryRootTypeLibrary,
    CCDirectoryRootTypeCache,
    CCDirectoryRootTypeTemp,
    CCDirectoryDayTypeCCInfo
};


@interface HHBaseViewController : UIViewController

- (void)fun_addControllerBackGesture;
- (void)fun_redirectNSLog;
- (void)fun_addDataToFile;
- (void)fun_getAppContainnerPath;

@end

NS_ASSUME_NONNULL_END
