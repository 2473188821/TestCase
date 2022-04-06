//
//  HMenuTool.h
//  HelloWorld
//
//  Created by Chenfy on 2022/3/31.
//  Copyright © 2022 Chenfy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMenuTool : NSObject

+ (NSArray *)menusArray;

- (UIButton *)createButton:(NSString *)title frame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
