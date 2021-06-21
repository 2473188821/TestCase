//
//  HNetworkViewController.m
//  TSS
//
//  Created by Chenfy on 2021/6/21.
//  Copyright © 2021 Chenfy. All rights reserved.
//

#import "HNetworkViewController.h"
#import "HFileUpload.h"

//https://www.cnblogs.com/lyz0925/p/11609273.html

#define kBoundary @"----WebKitFormBoundaryXGAyMbuVkeaFc916"
#define kNewLine  [@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]
#define kNewLine_string  @"\r\n"

@interface HNetworkViewController ()

@end

@implementation HNetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSString *url = @"https://liveclass.oss-cn-beijing.aliyuncs.com";
    NSDictionary *par = @{
        @"OSSAccessKeyId" : @"LTAI4GCbBa6UVcWSVTWfM94F",
        @"policy": @"eyJjb25kaXRpb25zIjogW1sic3RhcnRzLXdpdGgiLCAiJGtleSIsICJjaGF0L2NXYWhpeXJvaUsyWkllTFkvNzk2NkYyNjg0MzdEOTBDMzlDMzNEQzU5MDEzMDc0NjEiXV0sICJleHBpcmF0aW9uIjogIjIwMjEtMDYtMjFUMTA6MTE6MzNaIn0=",
        @"signature": @"uiQt34LMCfJ8kLTqPL/ES47kUQA=",
        @"key": @"chat/cWahiyroiK2ZIeLY/7966F268437D90C39C33DC5901307461/1624241463.626637.jpg",
        @"success_action_status": @"200",
    };
    
    UIImage *img = [UIImage imageNamed:@"1.jpg"];
    
    [self uploadFile_61:url par:par img:img];

    [[HFileUpload new]uploadFile:url param:par image:img completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

    }];
}



#pragma mark -- 61

- (NSMutableString *)addParamForKey_61:(NSString *)key info:(NSDictionary *)par data:(NSMutableString *)data {
    //错误格式--设置请求体,拼接文件传输格式
//    NSString *s1 = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
//    NSString *s2 = [NSString stringWithFormat:@"%@\r\n",par[key]];
    
    //正确格式--设置请求体,拼接文件传输格式
    NSString *s1 = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"",key];
    NSString *s2 = [NSString stringWithFormat:@"%@",par[key]];

    NSLog(@"sssss1-----:%@",s1);
    NSLog(@"sssss2-----:%@",s2);
    
    [data appendString:[NSString stringWithFormat:@"--%@",kBoundary]];
    [data appendString:kNewLine_string];
    [data appendString:s1];
    [data appendString:kNewLine_string];
    [data appendString:kNewLine_string];
    [data appendString:s2];
    [data appendString:kNewLine_string];
    
    return data;
}

- (void)uploadFile_61:(NSString *)url par:(NSDictionary *)par img:(UIImage *)img {
    //（2）创建“可变”请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    //（3）修改请求方法为POST
    request.HTTPMethod = @"POST";
    // --设置请求头信息，告诉服务器这是一个文件上传请求
    //Content-Type: multipart/form-data; boundary=----WebKitFormBoundaryXGAyMbuVkeaFc916
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", kBoundary] forHTTPHeaderField:@"Content-Type"];
    
    //--按照固定的格式拼接数据  ----这个放在bodyData中拼接
    //（4）设置请求体信息（文件参数）  ----这个放在bodyData中拼接
    //（5）创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    //（6）根据会话对象来创建uploadTask
    /**
     第一个参数:请求对象
     第二个参数：本应该放在请求体中的信息，如果放在请求头中，会被忽略
     */
    NSMutableString *string = [NSMutableString string];
    //02 拼接非文件参数--如果有非文件的数据，就加上这个拼接的格式
    /**
     --分隔符
     Content-Dispositon: form-data; name="useruame"
     空行
     abcdf(输入的内容)
     */
    // 设置请求体,拼接文件传输格式
    string = [self addParamForKey_61:@"OSSAccessKeyId" info:par data:string];
    string = [self addParamForKey_61:@"policy" info:par data:string];
    string = [self addParamForKey_61:@"signature" info:par data:string];
    string = [self addParamForKey_61:@"key" info:par data:string];
    string = [self addParamForKey_61:@"success_action_status" info:par data:string];

    [string appendString:[NSString stringWithFormat:@"--%@",kBoundary]];
    [string appendString:kNewLine_string];
    
    [string appendString:@"Content-Disposition: form-data; name=\"file\"; filename=\"22e93acbcced42dbb319a2fc0ecdcec9.jpeg\""];
    [string appendString:kNewLine_string];
    //要上传文件的而进士数据类型，组成：大类型/小类型
    [string appendString:@"Content-Type: image/jpeg"];
    [string appendString:kNewLine_string];
    [string appendString:kNewLine_string];

    
    NSMutableData *data = [NSMutableData data];
    [data appendData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    //01 拼接文件参数
    /**
     --分隔符
     Content-Disposition: form-data; name="file"; filename="22e93acbcced42dbb319a2fc0ecdcec9.jpg"
     Content-Type: image/jpeg
     空行
     文件数据
     --分隔符--
     */
    NSData *imageData = [self zipImageWithImage:img];
    
    [data appendData:imageData];
    [data appendData:kNewLine];
    
    //03 结尾表示
    [data appendData:[[NSString stringWithFormat:@"--%@--",kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        NSLog(@"NSURLSessionUploadTask---%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    //（7）执行task发送请求上传文件
    [uploadTask resume];

    
//    request.HTTPBody = data;
//    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//
//        NSString *sss = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"complite-----------:%@",sss);
//    }];
//    [task resume];

}



#pragma mark -- 4

//https://www.cnblogs.com/lyz0925/p/11609273.html

- (void)uploadFile_4:(NSString *)url par:(NSDictionary *)par img:(UIImage *)img {
    
    //（2）创建“可变”请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    //（3）修改请求方法为POST
    request.HTTPMethod = @"POST";
    // --设置请求头信息，告诉服务器这是一个文件上传请求
    //Content-Type: multipart/form-data; boundary=----WebKitFormBoundaryXGAyMbuVkeaFc916
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", kBoundary] forHTTPHeaderField:@"Content-Type"];
    //--按照固定的格式拼接数据  ----这个放在bodyData中拼接
    //（4）设置请求体信息（文件参数）  ----这个放在bodyData中拼接
    //（5）创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    //（6）根据会话对象来创建uploadTask
    /**
     第一个参数:请求对象
     第二个参数：本应该放在请求体中的信息，如果放在请求头中，会被忽略
     */
    NSMutableData *data = [NSMutableData data];
    //01 拼接文件参数
    /**
     --分隔符
     Content-Disposition: form-data; name="file"; filename="22e93acbcced42dbb319a2fc0ecdcec9.jpg"
     Content-Type: image/jpeg
     空行
     文件数据
     --分隔符--
     */
    //02 拼接非文件参数--如果有非文件的数据，就加上这个拼接的格式
    /**
     --分隔符
     Content-Dispositon: form-data; name="useruame"
     空行
     abcdf(输入的内容)
     */
    // 设置请求体,拼接文件传输格式
    NSArray *keys = [par allKeys];
    for (NSString *key in keys) {
        NSString *s1 = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"",key];
        NSString *s2 = [NSString stringWithFormat:@"%@",par[key]];
        
        NSLog(@"sssss1-----:%@",s1);
        NSLog(@"sssss2-----:%@",s2);
        
        [data appendData:[[NSString stringWithFormat:@"--%@",kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:kNewLine];
        [data appendData:[s1 dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:kNewLine];
        [data appendData:kNewLine];
        [data appendData:[s2 dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:kNewLine];
    }

    [data appendData:[[NSString stringWithFormat:@"--%@",kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:kNewLine];
    //name=file，其中file是不能随便写的，服务器要求写什么就写什么
    [data appendData:[@"Content-Disposition: form-data; name=\"file\"; filename=\"22e93acbcced42dbb319a2fc0ecdcec9.jpg\"" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:kNewLine];
    //要上传文件的而进士数据类型，组成：大类型/小类型
    [data appendData:[@"Content-Type: image/jpeg" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:kNewLine];
    [data appendData:kNewLine];
    NSData *imageData = [self zipImageWithImage:img];
    
    [data appendData:imageData];
    [data appendData:kNewLine];
    
    //03 结尾表示
    [data appendData:[[NSString stringWithFormat:@"--%@--",kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"NSURLSessionUploadTask---%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    //（7）执行task发送请求上传文件
    [uploadTask resume];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (NSData *)zipImageWithImage:(UIImage *)image {
    if (!image) return nil;
    
    CGFloat maxFileSize = 1*1024;
    CGFloat compression = 0.9f;
    NSData *compressedData = UIImageJPEGRepresentation(image, compression);
    while ([compressedData length] > maxFileSize) {
        compression *= 0.9;
        compressedData = UIImageJPEGRepresentation([[self class] compressImage:image newWidth:image.size.width*compression], compression);
    }
    return compressedData;
}
+ (UIImage *)compressImage:(UIImage *)image newWidth:(CGFloat)newImageWidth
{
    if (!image) return nil;
    float imageWidth = image.size.width;
    float imageHeight = image.size.height;
    float width = newImageWidth;
    float height = image.size.height/(image.size.width/width);
    
    float widthScale = imageWidth /width;
    float heightScale = imageHeight /height;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    
    if (widthScale > heightScale) {
        [image drawInRect:CGRectMake(0, 0, imageWidth /heightScale , height)];
    }
    else {
        [image drawInRect:CGRectMake(0, 0, width , imageHeight /widthScale)];
    }
    // 从当前context中创建一个改变大小后的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    return newImage;
}


@end
