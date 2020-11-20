//
//  ViewController.m
//  TSS
//
//  Created by Chenfy on 2020/8/24.
//  Copyright © 2020 Chenfy. All rights reserved.
//

#import "ViewController.h"
#import "KMacro.h"
#import "Person.h"
#import "HHView.h"

@interface ViewController ()
@property(nonatomic,strong)HHView *hView;

@property(nonatomic,strong)UIPanGestureRecognizer *panges;


@end

@implementation ViewController

- (HHView *)hView {
    if (!_hView) {
        _hView = [[HHView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    }
    return _hView;
}

- (void)onHHViewPan:(UIPanGestureRecognizer *)rec {
    
    CGPoint touchPoint = [rec locationInView:self.view];
    if (touchPoint.x < 20) {
        rec.view.center = CGPointMake(20, rec.view.center.y);
    } else if (touchPoint.x > 600 - 20) {
        rec.view.center = CGPointMake(600 - 20, rec.view.center.y);
    } else {
        rec.view.center = CGPointMake(touchPoint.x, touchPoint.y);
    }
    
    [self.hView printInfo]; 
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.lightGrayColor;
    
    self.panges = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(onHHViewPan:)];
    [self.hView addGestureRecognizer:self.panges];
    
    [self.view addSubview:self.hView];
    
    [self hViewTest];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

}

- (void)hViewTest {
    [self.hView printInfo];
    
    //    [self.hView makeScaleViewTest];
    [self.hView makeScaleLayerTest];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.hView makeRotateLayerTest];
    });
    
    [self.hView printInfo];
}



@end
