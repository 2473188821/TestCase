//
//  HSDrawViewBezier.m
//  TestDoc
//
//  Created by Chenfy on 2020/7/4.
//  Copyright © 2020 Chenfy. All rights reserved.
//

#import "HSDrawViewBezier.h"

@interface HSDrawViewBezier ()
@property(nonatomic,strong)CAShapeLayer *lShape;
@property(nonatomic,strong)UIBezierPath *path;

@property(nonatomic,assign)CGPoint pointStart;
@property(nonatomic,assign)CGPoint pointEnded;

@property(nonatomic,strong)NSMutableArray *arrayPoint;

@property(nonatomic,assign)BOOL inDraw;

@end

@implementation HSDrawViewBezier

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _lShape = [CAShapeLayer layer];
        _path = [UIBezierPath bezierPath];
        _path.lineWidth = 5.0;
        _pointStart = CGPointZero;
        _pointEnded = CGPointZero;
        _inDraw = NO;
        _arrayPoint = [NSMutableArray arrayWithCapacity:5];
        [self.layer addSublayer:_lShape];
        [self makeBezierPath];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

 - (void)makeBezierPath
 {
     UIBezierPath *path = [UIBezierPath bezierPath];
     path.lineWidth = 5.0;
     CGPoint pStart = CGPointMake(100, 100);
     CGPoint pEnd = CGPointMake(200, 200);
     
     [path moveToPoint:pStart];
     [path addLineToPoint:pEnd];
     
     _path = path;
     
     CAShapeLayer *shapeLayer = _lShape;
     shapeLayer.frame = self.bounds;
     shapeLayer.strokeColor = UIColor.redColor.CGColor;
     shapeLayer.lineWidth = 5.0;
     shapeLayer.fillColor = [UIColor clearColor].CGColor;
     shapeLayer.lineJoin = kCALineJoinRound;
     shapeLayer.lineCap = kCALineCapRound;
     
     shapeLayer.path = path.CGPath;
 }

// 判断是否在这条线上
- (BOOL)judgePoint:(CGPoint)point isInPath:(UIBezierPath *)path {
    // 3-点到线的距离
    CGPathRef hitPath = CGPathCreateCopyByStrokingPath(path.CGPath, NULL, 50, kCGLineCapRound, kCGLineJoinRound, 0);
    BOOL isInPath = CGPathContainsPoint(hitPath, NULL, point, false);
    CGPathRelease(hitPath);
    return isInPath;
}

- (CGPoint)getPointFromTouches:(NSSet<UITouch *>*)touches {
    CGPoint point = [[touches anyObject] locationInView:self];
    return point;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [self  getPointFromTouches:touches];
    _pointStart = point;
    BOOL indraw = [self judgePoint:point isInPath:_path];
    NSLog(@"---%d---",indraw);
    self.inDraw = indraw;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [self getPointFromTouches:touches];
    if (!_inDraw) {
        return;
    }
    CGFloat x = point.x - _pointStart.x;
    CGFloat y = point.y - _pointStart.y;
    NSLog(@"----x:%f  ||  y:%f ---",x,y);

    CGAffineTransform transform = CGAffineTransformMakeTranslation(x, y);
    transform = CGAffineTransformTranslate(CGAffineTransformIdentity, x, y);
    [_path applyTransform:transform];
    
    _lShape.path = _path.CGPath;
    _pointStart = point;
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}


@end
