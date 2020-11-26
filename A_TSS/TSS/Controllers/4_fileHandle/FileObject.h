//
//  FileObject.h
//  ObjectiveBridge
//
//  Created by Chenfy on 2019/10/9.
//  Copyright © 2019 Chenfy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FileObject : NSObject

+ (NSString *)filePath;
+ (void)initFile;
+ (void)appendData;

@end

NS_ASSUME_NONNULL_END
