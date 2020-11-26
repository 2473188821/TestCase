
//
//  HHTool.m
//  TSS
//
//  Created by Chenfy on 2020/10/12.
//  Copyright © 2020 Chenfy. All rights reserved.
//

#import "HHTool.h"

@implementation HHTool

+ (WKWebView *)makeWebView:(CGRect)frame {
    //创建网页配置对象
    WKWebView *webview = nil;
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.allowsInlineMediaPlayback = YES;
    config.mediaPlaybackRequiresUserAction = false;
    config.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeNone;
    // 创建设置对象
    WKPreferences *preference = [[WKPreferences alloc]init];
    //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
    preference.minimumFontSize = 0;
    //设置是否支持javaScript 默认是支持的
    preference.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
    preference.javaScriptCanOpenWindowsAutomatically = YES;
    config.preferences = preference;
    
    // 是使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
    config.allowsInlineMediaPlayback = YES;
    //设置视频是否需要用户手动播放  设置为NO则会允许自动播放
    config.requiresUserActionForMediaPlayback = NO;
    //设置是否允许画中画技术 在特定设备上有效
    config.allowsPictureInPictureMediaPlayback = YES;
    //设置请求的User-Agent信息中应用程序名称 iOS9后可用
    config.applicationNameForUserAgent = @"ChinaDailyForiPad";
    //自定义的WKScriptMessageHandler 是为了解决内存不释放的问题
    
    //这个类主要用来做native与JavaScript的交互管理
    WKUserContentController * wkUController = [[WKUserContentController alloc] init];
    //注册一个name为jsToOcNoPrams的js方法
    config.userContentController = wkUController;
    
    webview = [[WKWebView alloc] initWithFrame:frame configuration:config];
    
    // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
    //可返回的页面列表, 存储已打开过的网页
    WKBackForwardList * backForwardList = [webview backForwardList];
    
    NSString *urlString = @"https://www.baidu.com";
    //    urlString = @"https://pic.ibaotu.com/01/38/48/03v888piCBC3.jpg-1.jpg!ww7002";
    //    urlString = @"https://www.bizhizu.cn/photoview/2140/3.html";
    //    urlString = @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3582955620,3662726234&fm=26&gp=0.jpg";
    //    urlString = @"https://people.mozilla.org/rnewman/fennec/mem.html";
    
    urlString = @"http://192.168.196.59:10001/";
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [webview loadRequest:request];
    
    return webview;
}



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


// UIColor转#ffffff格式的字符串
+ (NSString *)hexStringFromColor:(UIColor *)color alpha:(CGFloat)alpha {
    const CGFloat *components = CGColorGetComponents(color.CGColor);

    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    CGFloat a = alpha;
  
    NSString *hexColor = [NSString stringWithFormat:@"#%02lX%02lX%02lX%02lX",lroundf(a * 255),lroundf(r * 255),lroundf(g * 255),lroundf(b * 255)];
    return hexColor;
    return [NSString stringWithFormat:@"#%02lX%02lX%02lX%02lX",lroundf(a * 255),lroundf(r * 255),lroundf(g * 255),lroundf(b * 255)];
    return [NSString stringWithFormat:@"#%02lX%02lX%02lX",lroundf(r * 255),lroundf(g * 255),lroundf(b * 255)];
}

@end
