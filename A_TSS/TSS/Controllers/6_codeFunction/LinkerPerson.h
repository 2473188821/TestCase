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

@interface LinkerPerson : NSObject

//位运算
@property(nonatomic,assign)PFoodType food;
- (void)showFood;

- (void)lock;

//函数编程
- (void)setName:(NSString *)name;

#pragma mark -- localfunction
- (LinkerPerson *)eat;
- (LinkerPerson *)drink;

#pragma mark -- block 返回值：void
- (void(^)(void))smile;
- (void(^)(void))laugh;

#pragma mark -- block chain 返回值：self对象
- (LinkerPerson *(^)(NSString *name))nameCall;
- (LinkerPerson *(^)(int age))ageCall;


- (LinkerPerson *(^)(NSString *name))name;
- (LinkerPerson *(^)(int age))age;

id createPerson();
static id createPerson_static();



#pragma mark -- mask 位与
@property(nonatomic,assign,getter=isTall)BOOL tall;
@property(nonatomic,assign,getter=isRich)BOOL rich;

- (void)setTall:(BOOL)tall;
- (BOOL)isTall;

- (void)setRich:(BOOL)rich;
- (BOOL)isRich;


@end

NS_ASSUME_NONNULL_END
