//
//  HMenuTool.m
//  HelloWorld
//
//  Created by Chenfy on 2022/3/31.
//  Copyright © 2022 Chenfy. All rights reserved.
//

#import "HMenuTool.h"

@interface HMenuTool()
@property(nonatomic,strong)NSArray *menus;

@end

@implementation HMenuTool

+ (NSArray *)menusArray {
    return @[@"TestViewController-测试页面",
             @"HFuncReactiveController-函数响应式编程"];
}


#pragma mark -- Button Create
- (UIButton *)createButton:(NSString *)title frame:(CGRect)frame
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor orangeColor];
    return btn;
}


@end
