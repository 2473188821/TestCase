//
//  HDrawViewController.m
//  TSS
//
//  Created by Chenfy on 2020/11/26.
//  Copyright © 2020 Chenfy. All rights reserved.
//

#import "HDrawViewController.h"

#import "HSDrawView.h"
#import "HSDrawViewMulti.h"
#import "HSDrawViewBezier.h"
#import "SignatureViewQuartz.h"
#import "SignatureViewQuartzQuadratic.h"

/************ README ***********
 * 图形绘制并移动，规则如下 ：
 * 1、根据点集合识别当前点击是否在已经绘制的路径图形上；
 * 2、根据UIBezierPath path 识别当前点击是否在已绘制路径上；
 *
 * HSDrawView : 绘制单个图形，可拖拽
 * HSDrawViewMulti：绘制多个图形，可同时拖拽
 * HSDrawViewBezier：绘制贝塞尔曲线，可拖拽
 * SignatureViewQuartz：利用手势绘图，长按清除
 * SignatureViewQuartzQuadratic：利用手势绘图（贝塞尔优化），长按清除
 *
 ***/

@interface HDrawViewController ()
@property(nonatomic,strong)HSDrawView *drawView;
@property(nonatomic,strong)HSDrawViewMulti *drawViewMulti;
@property(nonatomic,strong)HSDrawViewBezier *drawViewBezier;


@property(nonatomic,strong)SignatureViewQuartz *signNormal;
@property(nonatomic,strong)SignatureViewQuartzQuadratic *signBezier;

@end

@implementation HDrawViewController

- (HSDrawView *)drawView {
    if (!_drawView) {
        _drawView = [[HSDrawView alloc]initWithFrame:self.view.bounds];
    }
    return _drawView;
}

- (HSDrawViewMulti *)drawViewMulti {
    if (!_drawViewMulti) {
        _drawViewMulti = [[HSDrawViewMulti alloc]initWithFrame:self.view.bounds];
    }
    return _drawViewMulti;
}

- (HSDrawViewBezier *)drawViewBezier {
    if (!_drawViewBezier) {
        _drawViewBezier = [[HSDrawViewBezier alloc]initWithFrame:self.view.bounds];
    }
    return _drawViewBezier;
}

- (SignatureViewQuartz *)signNormal {
    if (!_signNormal) {
        _signNormal = [[SignatureViewQuartz alloc]initWithFrame:self.view.bounds];
        _signNormal.backgroundColor = UIColor.lightGrayColor;
    }
    return _signNormal;
}

- (SignatureViewQuartzQuadratic *)signBezier {
    if (!_signBezier) {
        _signBezier = [[SignatureViewQuartzQuadratic alloc]initWithFrame:self.view.bounds];
        _signBezier.backgroundColor = UIColor.lightGrayColor;
    }
    return _signBezier;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading t
    self.view.backgroundColor = UIColor.greenColor;
    self.drawView.backgroundColor = UIColor.lightGrayColor;
    self.drawViewMulti.backgroundColor = UIColor.lightGrayColor;
    self.drawViewBezier.backgroundColor = UIColor.lightGrayColor;

    [self.view addSubview:self.signNormal];

    /**
     [self.view addSubview:self.drawView];
     [self.view addSubview:self.drawViewMulti];
     [self.view addSubview:self.drawViewBezier];
     [self.view addSubview:self.signNormal];
     [self.view addSubview:self.signBezier];

     */
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
