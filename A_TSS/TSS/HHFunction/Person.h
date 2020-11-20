//
//  Person.h
//  TSS
//
//  Created by Chenfy on 2020/9/2.
//  Copyright © 2020 Chenfy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSInteger, PFoodType) {
    PFoodType_none = 0,
    PFoodType_orange = 1 << 0,
    PFoodType_apple = 1 << 1,
    PFoodType_banana = 1 << 2,
    PFoodType_watermellon = 1 << 3,
};

@interface Person : NSObject

@property(nonatomic,assign)PFoodType food;

- (void)lock;

- (void)showFood;

- (NSString *)hexStringFromColor:(UIColor *)color xxalpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
