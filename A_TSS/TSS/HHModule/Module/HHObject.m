//
//  HHObject.m
//  TSS
//
//  Created by Chenfy on 2020/10/12.
//  Copyright © 2020 Chenfy. All rights reserved.
//

#import "HHObject.h"

@implementation HHObject

+ (UIColor *)colorWithHexARGBString:(NSString *)color {
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6 && [cString length] != 8)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //a
    NSString *aString = [cString substringWithRange:range];
    //r
    range.location = 2;
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 4;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 6;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int a, r, g, b;
    [[NSScanner scannerWithString:aString] scanHexInt:&a];
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:a];
}

+ (NSString *)numberToHex:(long long int)tmpid {
    NSString *nLetterValue;
    NSString *str =@"";
    long long int tempValue = tmpid;
    long long int temp_left;
    for (int i =0; i<9; i++) {
        temp_left = tempValue%16;
        tempValue = tempValue/16;
        switch (temp_left)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:nLetterValue=[[NSString alloc] initWithFormat:@"%lli",temp_left];
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
    }
    if (str.length%2 == 1)
    {
        //补上0,写成偶数位
        str = [NSString stringWithFormat:@"0%@", str];
    }
    return str;
}

+ (long int)rgbaValue:(CGFloat)rgba {
    return lroundf(rgba * 255);
}

//把颜色转为16进制的代码
+ (NSString *)hexColorFromUIColor:(UIColor*)color {
    if(CGColorGetNumberOfComponents(color.CGColor) < 4) {
        return @"#FFFFFF";
    }
    if(CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) !=kCGColorSpaceModelRGB) {
        return @"#FFFFFF";
    }
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    CGFloat a = components[3];
    
    long int rr = [self rgbaValue:r];
    long int gg = [self rgbaValue:g];
    long int bb = [self rgbaValue:b];
    __unused long int aa = [self rgbaValue:a];
    
    NSString *cstring = [NSString stringWithFormat:@"%02lX%02lX%02lX",rr,gg,bb];
    return cstring;
}

@end
