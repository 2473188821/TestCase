//
//  HFuncReactiveController.m
//  HelloWorld
//
//  Created by Chenfy on 2022/3/31.
//  Copyright © 2022 Chenfy. All rights reserved.
//

#import "HFuncReactiveController.h"
#import "Student.h"

int gl_credit = 50;

@interface HFuncReactiveController ()
@property(nonatomic,strong)Student *student;

@property(nonatomic,strong)UILabel *label;

@end

@implementation HFuncReactiveController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.cyanColor;
    
    CGRect frm = CGRectMake(100, 100, 100, 100);
    self.label = [[UILabel alloc]initWithFrame:frm];
    self.student = [[[[[Student create]name:@"zhangsan"]gender:HGender_Male]number:gl_credit]filterIsASatisfyCredit:^BOOL(NSUInteger credit) {
        if (credit < 60) {
            self.label.backgroundColor = UIColor.redColor;
        } else if (credit > 60 && credit < 90) {
            self.label.backgroundColor = UIColor.yellowColor;
        } else {
            self.label.backgroundColor = UIColor.greenColor;
        }
        
        return YES;
    }];
    
    [self.student.creditSubject subscribeNext:^(NSUInteger credit) {
        NSLog(@"--11------%s------",__func__);
    }];
    [self.student.creditSubject subscribeNext:^(NSUInteger credit) {
        NSLog(@"--22------%s------",__func__);
        self.label.text = [NSString stringWithFormat:@"%lu",(unsigned long)credit];
    }];
    [self.student.creditSubject subscribeNext:^(NSUInteger credit) {
        if (credit < 60) {
            self.label.backgroundColor = UIColor.redColor;
        } else if (credit > 60 && credit < 90) {
            self.label.backgroundColor = UIColor.yellowColor;
        } else {
            self.label.backgroundColor = UIColor.greenColor;
        }
    }];
    
    [self.view addSubview:self.label];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    gl_credit += 3;
    [self.student.creditSubject sendNext:gl_credit];
    
}

@end
