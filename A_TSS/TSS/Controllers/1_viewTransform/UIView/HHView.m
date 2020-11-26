//
//  HHView.m
//  TSS
//
//  Created by Chenfy on 2020/10/12.
//  Copyright © 2020 Chenfy. All rights reserved.
//

#import "HHView.h"

@interface HHView ()
@property(nonatomic,strong)CAShapeLayer *borderLayer;
@property(nonatomic,strong)CAShapeLayer *displayLayer;

@end

@implementation HHView

+ (Class)layerClass
{
    return ([CAShapeLayer class]);
}

- (CAShapeLayer *)borderLayer {
    if (!_borderLayer) {
        _borderLayer = [CAShapeLayer layer];
        //虚线的颜色
        _borderLayer.strokeColor = [UIColor greenColor].CGColor;
        //填充的颜色
        _borderLayer.fillColor = [UIColor clearColor].CGColor;
    }
    return _borderLayer;
}

- (CAShapeLayer *)displayLayer {
    if (!_displayLayer) {
        _displayLayer = [CAShapeLayer layer];
        //虚线的颜色
        _displayLayer.strokeColor = [UIColor redColor].CGColor;
        //填充的颜色
        _displayLayer.fillColor = [UIColor redColor].CGColor;
    }
    return _displayLayer;
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = UIColor.clearColor;
        
        CGRect frm = self.bounds;
        CGFloat offset = 2.0;
        CGFloat w_offset = offset * 2;
        CGRect frm_inner = CGRectMake(offset, offset, frm.size.width - w_offset , frm.size.height - w_offset);
        
        UIBezierPath *pathBorder = [UIBezierPath bezierPathWithRect:frm];
        UIBezierPath *pathContent = [UIBezierPath bezierPathWithRect:frm_inner];
        
        CAShapeLayer *border = self.borderLayer;
        //设置路径
        border.path = pathBorder.CGPath;
        border.frame = self.bounds;
        //虚线的宽度
        border.lineWidth = 1.f;
        
        //设置线条的样式
        //    border.lineCap = @"square";
        //虚线的间隔
        border.lineDashPattern = @[@2];
        [self.layer addSublayer:border];
        
        self.displayLayer.frame = self.bounds;
        self.displayLayer.path = pathContent.CGPath;
        [self.layer addSublayer:self.displayLayer];
    }
    return self;
}

- (void)display {
    UIColor *fillColor = UIColor.greenColor;
    UIColor *strokeColor = UIColor.cyanColor;
    
    UIBezierPath *bezier = [UIBezierPath bezierPathWithRect:CGRectMake(20, 20, 50, 50)];
    
    CAShapeLayer *shapeLayer = (CAShapeLayer *)self.layer;
    shapeLayer.fillColor = fillColor.CGColor;
    shapeLayer.lineWidth = 15.0;
    shapeLayer.strokeColor = strokeColor.CGColor;
    
    ((CAShapeLayer *)self.layer).path = bezier.CGPath;
}

- (void)makeRotateLayer {
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI_4);
    ((CAShapeLayer *)self.layer).affineTransform = transform;
}

- (void)makeScaleView {
    CGAffineTransform scale = CGAffineTransformMakeScale(2.0, 2.0);
    self.transform = scale;
}

- (void)makeScaleLayerTest {
    //一、缩放 display 内容
    CGFloat svalue = 2.0;
    CGAffineTransform scale = CGAffineTransformMakeScale(svalue, svalue);
    self.displayLayer.affineTransform = scale;
    
    //二、计算刷新边框的frame、path
    CGRect frm = self.frame;
    
    //1、view 本身宽、高
    CGFloat ww = frm.size.width;
    CGFloat hh = frm.size.height;
    
    //2、缩放后的宽、高
    CGFloat r_ww = ww * svalue;
    CGFloat r_hh = hh * svalue;
    
    //3、计算 scale 后 displayLayer 偏移量
    CGFloat left =  - (r_ww - ww)/2.0;
    CGFloat top = - (r_hh - hh)/2.0;
    
    //4、呈现内容的layer的frame
    CGRect newFrm = CGRectMake(left, top, r_ww, r_hh);
    
    //5、重新计算边线 path
    UIBezierPath *pathBorder = [UIBezierPath bezierPathWithRect:newFrm];
    self.borderLayer.path = pathBorder.CGPath;
}

- (void)makeRotateLayerTest {
    self.displayLayer.affineTransform = CGAffineTransformIdentity;
    self.borderLayer.affineTransform = CGAffineTransformIdentity;
    
    CGFloat svalue = 2.0;
    CGAffineTransform scale = CGAffineTransformMakeScale(svalue, svalue);
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI_4);
    
    CGAffineTransform con = CGAffineTransformConcat(scale, transform);
    ((CAShapeLayer *)self.displayLayer).affineTransform = con;
    ((CAShapeLayer *)self.borderLayer).affineTransform = transform;
}

- (void)printInfo {
    //当前 view 的frame
    CGRect frm = self.frame;
    
    NSString *frmString = NSStringFromCGRect(self.frame);
    NSLog(@"Frame View ---:%@",frmString);
    
    //缩放比例
    CGFloat svalue = 2.0;
    //view的左上角坐标
    CGPoint origin = frm.origin;
    
    //view的宽高
    CGFloat ww = frm.size.width;
    CGFloat hh = frm.size.height;
    
    //displayLayer的实际宽高
    CGFloat r_ww = ww * svalue;
    CGFloat r_hh = hh * svalue;
    
    //displayLayer 的左上角坐标相对于 view 左上角的偏移
    CGFloat left =  (r_ww - ww)/2.0;
    CGFloat top = (r_hh - hh)/2.0;
    
    //displayLayer 在坐标系统的 frame
    CGRect fff = CGRectMake(origin.x - left, origin.y - top, r_ww, r_hh);
    NSLog(@"Frame rLayer real frame ---:%@",NSStringFromCGRect(fff));
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
