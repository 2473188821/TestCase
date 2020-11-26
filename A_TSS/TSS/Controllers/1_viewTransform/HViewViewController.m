//
//  HViewViewController.m
//  TSS
//
//  Created by Chenfy on 2020/11/23.
//  Copyright © 2020 Chenfy. All rights reserved.
//

#import "HViewViewController.h"
#import "AppDelegate.h"

#import "HHView.h"
#import "DragView.h"

@interface HViewViewController ()
@property(nonatomic,strong)HHView *hView;
@property(nonatomic,strong)UIPanGestureRecognizer *panges;

@property(nonatomic,strong)DragView *dragV;

@end

@implementation HViewViewController

- (DragView *)dragV {
    if (!_dragV) {
        _dragV = [[DragView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        _dragV.layer.cornerRadius = 5.0;
        _dragV.backgroundColor = [UIColor purpleColor];
    }
    return _dragV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.lightGrayColor;
    
    self.panges = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(onHHViewPan:)];
    [self.hView addGestureRecognizer:self.panges];
    
    [self.view addSubview:self.hView];
    

    // Do any additional setup after loading the view.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"FFFF--001--:%@",NSStringFromCGRect(self.hView.frame));
    self.hView.transform = CGAffineTransformMakeScale(3.0, 3.0);
    NSLog(@"FFFF--002--:%@",NSStringFromCGRect(self.hView.frame));
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


#pragma mark -- view transform
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


bool gl_land = YES;
- (void)buttonClick
{
    NSLog(@"buttonClick");
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    BOOL land = !app.shouldNeedLandscape;
    app.shouldNeedLandscape = land;
    
    if(land)
    {
        NSLog(@"buttonClick-------land--");
        NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    }
    else
    {
        NSLog(@"buttonClick-------portrait--");
        NSNumber *orientationTarget = [NSNumber numberWithInt:UIDeviceOrientationPortrait];
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:UIDeviceOrientationDidChangeNotification object:nil];
}



@end
