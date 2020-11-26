//
//  HCodeFuncViewController.m
//  TSS
//
//  Created by Chenfy on 2020/11/25.
//  Copyright © 2020 Chenfy. All rights reserved.
//

#import "HCodeFuncViewController.h"
#import "Person.h"

@interface HCodeFuncViewController ()

@end

@implementation HCodeFuncViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self testCodeBinary];
    [self testCodeFunction];
    [self testCodeChain];
    // Do any additional setup after loading the view.
}

//位运算
- (void)testCodeBinary {
    Person *pp = [Person new];
    pp.food = PFoodType_apple | PFoodType_banana;
    
    [pp showFood];
}
//函数式编程
- (void)testCodeFunction {
    Person *pp = [Person new];
    [pp setName:@"hello zhagnsan!"];
}
//链式编程
- (void)testCodeChain {
    Person *pp = [Person new];
    [[pp eat]drink];

    [pp smile];
    pp.smile();
    
    pp.nameCall(@"hello").ageCall(25);
    pp.name(@"zhangsan").age(22);
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
