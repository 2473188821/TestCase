//
//  KKK.m
//  TestDoc
//
//  Created by Chenfy on 2021/4/26.
//  Copyright © 2021 Chenfy. All rights reserved.
//

#import "HFileUpload.h"

#define kBoundary @"----WebKitFormBoundaryXGAyMbuVkeaFc916"
#define kNewLine  [@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]
#define kNewLine_string  @"\r\n"


@interface HFileUpload ()

@end 

@implementation HFileUpload

- (void)callBack:(NSData *)data response:(NSURLResponse *)response error:(NSError *)error completionHandler:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completionHandler  {
    if (completionHandler) {
        completionHandler(data , response ,error);
    }
}

- (void)uploadFile:(NSString *)url param:(NSDictionary *)info image:(UIImage *)image completionHandler:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completionHandler {
    NSError *error = nil;
    //1、创建请求对峙
    NSURL *urlAddress = [NSURL URLWithString:url];
    if (!url) {
        error = [NSError errorWithDomain:@"url nil" code:400 userInfo:@{}];
        [self callBack:nil response:nil error:error completionHandler:completionHandler];
        return;
    }
    //2、创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    //3、创建“可变”请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlAddress];
    //4、修改请求方法为POST
    request.HTTPMethod = @"POST";
    // --设置请求头信息，告诉服务器这是一个文件上传请求
    //Content-Type: multipart/form-data; boundary=----WebKitFormBoundaryXGAyMbuVkeaFc916
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", kBoundary];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    //--按照固定的格式拼接数据  ----这个放在bodyData中拼接
    //01 拼接文件参数
    /**
     --分隔符
     Content-Disposition: form-data; name="file"; filename="22e93acbcced42dbb319a2fc0ecdcec9.jpg"
     Content-Type: image/jpeg
     空行
     文件数据
     --分隔符--
     */
    NSMutableString *string = [NSMutableString string];
    string = [self bodyAppendRequestInfo:info mutableString:string];

    //02 拼接非文件参数--如果有非文件的数据，就加上这个拼接的格式
    /**
     --分隔符
     Content-Dispositon: form-data; name="useruame"
     空行
     abcdf(输入的内容)
     */
    // 设置请求体,拼接文件传输格式
    string = [self bodyAppendFileInfo:@"file.jpeg" mutableString:string];
   
    //03 追加上传文件数据
    NSData *imageData = [self zipImageWithImage:image];

    NSMutableData *data = [NSMutableData data];
    [data appendData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    
    data = [self bodyAppendFile:imageData mutableData:data];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"NSURLSessionUploadTask---%@", response);
        [self callBack:data response:response error:error completionHandler:completionHandler];
    }];
    //（7）执行task发送请求上传文件
    [uploadTask resume];
}

- (NSMutableString *)bodyAppendRequestInfo:(NSDictionary *)info mutableString:(NSMutableString *)stringInfo {
    //01 拼接非文件参数--如果有非文件的数据，就加上这个拼接的格式
    /**
     --分隔符
     Content-Dispositon: form-data; name="useruame"
     空行
     abcdf(输入的内容)
     */
    NSMutableString *string = stringInfo;
    
    NSArray *keys = [info allKeys];
    for (NSString *key in keys) {
        //正确格式--设置请求体,拼接文件传输格式
        NSString *s1 = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"",key];
        NSString *s2 = [NSString stringWithFormat:@"%@",info[key]];
        
        [string appendString:[NSString stringWithFormat:@"--%@",kBoundary]];
        [string appendString:kNewLine_string];
        [string appendString:s1];
        [string appendString:kNewLine_string];
        [string appendString:kNewLine_string];
        [string appendString:s2];
        [string appendString:kNewLine_string];
    }
    return string;
}

- (NSMutableString *)bodyAppendFileInfo:(NSString *)fileName mutableString:(NSMutableString *)stringInfo {
    //02 拼接文件参数
    /**
     --分隔符
     Content-Disposition: form-data; name="file"; filename="22e93acbcced42dbb319a2fc0ecdcec9.jpg"
     Content-Type: image/jpeg
     空行
     文件数据
     --分隔符--
     */
    NSMutableString *string = stringInfo;

    NSString *fileInfoString = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"",fileName];

    [string appendString:[NSString stringWithFormat:@"--%@",kBoundary]];
    [string appendString:kNewLine_string];
    
    [string appendString:fileInfoString];
    [string appendString:kNewLine_string];
    //要上传文件的而进士数据类型，组成：大类型/小类型
    [string appendString:@"Content-Type: image/jpeg"];
    [string appendString:kNewLine_string];
    [string appendString:kNewLine_string];

    return string;
}

- (NSMutableData *)bodyAppendFile:(NSData *)imageData mutableData:(NSMutableData *)data {
    NSMutableData *tempData = data;
    
    [tempData appendData:imageData];
    [tempData appendData:kNewLine];
    
    //03 结尾表示
    NSString *endMark = [NSString stringWithFormat:@"--%@--",kBoundary];
    [tempData appendData:[endMark dataUsingEncoding:NSUTF8StringEncoding]];
    
    return tempData;
}


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
