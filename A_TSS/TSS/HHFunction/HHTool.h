//
//  HHTool.h
//  TSS
//
//  Created by Chenfy on 2020/10/12.
//  Copyright © 2020 Chenfy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHTool : NSObject

+ (WKWebView *)makeWebView:(CGRect)frame;



+ (NSString *)numberToHex:(long long int)tmpid;
+ (UIColor *)colorWithHexARGBString:(NSString *)color;
+ (NSString *)hexColorFromUIColor:(UIColor*)color;

@end

NS_ASSUME_NONNULL_END
