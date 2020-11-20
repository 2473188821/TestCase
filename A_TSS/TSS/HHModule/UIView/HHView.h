//
//  HHView.h
//  TSS
//
//  Created by Chenfy on 2020/10/12.
//  Copyright © 2020 Chenfy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHView : UIView
//1、展示
- (void)display;

//2、旋转
- (void)makeRotateLayer;
- (void)makeRotateLayerTest;

//3、缩放
- (void)makeScaleView;

- (void)makeScaleLayerTest;

// 打印view相关信息
- (void)printInfo;
@end

NS_ASSUME_NONNULL_END
