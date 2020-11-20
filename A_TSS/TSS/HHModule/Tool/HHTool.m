
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


@end
