//
//  KKK.h
//  TestDoc
//
//  Created by Chenfy on 2021/4/26.
//  Copyright © 2021 Chenfy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface HFileUpload : NSObject

- (void)uploadFile:(NSString *)url param:(NSDictionary *)info image:(UIImage *)image completionHandler:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler;;

@end

NS_ASSUME_NONNULL_END
