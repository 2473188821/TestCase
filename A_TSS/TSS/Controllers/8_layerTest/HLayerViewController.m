//
//  HLayerViewController.m
//  TSS
//
//  Created by Chenfy on 2020/11/27.
//  Copyright © 2020 Chenfy. All rights reserved.
//

#import "HLayerViewController.h"

#define RGBA(r,g,b,a)       [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define MainColor2                 RGBA(255, 132, 23,  1)//主题橘色2
#define MainColor1                 RGBA(255, 132, 23,  0.3)//主题橘色1

@interface HLayerViewController ()
@property(nonatomic,strong)UIImageView  *imageTitle;
@property(nonatomic,strong)NSArray *data;

@end

@implementation HLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.imageTitle];
    
    [self test_CAGradientLayer];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self addMaskToImageTitle];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -- Layer CAShapeLayer mask

- (UIImageView *)imageTitle {
    if (!_imageTitle) {
        int ss = 200;
        int width = ss ,height = ss;
        CGRect frame = CGRectMake(0, 50, width, height);
        _imageTitle = [[UIImageView alloc]initWithFrame:frame];
        _imageTitle.image = [UIImage imageNamed:@"red_leaf"];
        _imageTitle.center = CGPointMake(KSCREEN_WIDTH/2, _imageTitle.center.y);
    }
    return _imageTitle;
}

- (void)addMaskToImageTitle {
    CGRect frm = CGRectMake(0, 0, 200, 100);
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = frm;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:frm cornerRadius:50];
    maskLayer.path = path.CGPath;
    self.imageTitle.layer.mask = maskLayer;
}


#pragma mark -- Layer CAGradientLayer test

- (NSArray *)data {
    return @[@"在线回放 >",@"离线回放 >",@"在线旁听 >"];
}
- (void)test_CAGradientLayer {
    int y = self.imageTitle.frame.origin.y + self.imageTitle.frame.size.height;
    y += 50;
    int btn_w = 260 ,btn_h = 50;
    
    int btn_x = (KSCREEN_WIDTH - btn_w)/2.0;
    int space = 30;
    for (int i = 0 ; i < 3; i++) {
        CGRect frame = CGRectMake(btn_x, y + space + (i * (btn_h + space)), btn_w, btn_h);
        NSString *title = self.data[i];
        
        UIButton *btn = [self createButton:title frame:frame];
        btn.tag = i;
        [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}

- (void)buttonClicked:(UIButton *)sender
{
    int tag = (int)sender.tag;
    NSLog(@"tag button :%d",tag);
}

#pragma mark -- Button Create
- (UIButton *)createButton:(NSString *)title frame:(CGRect)frame
{
    //渐变的按钮
    UIButton *lookBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    lookBtn.frame = frame;
    lookBtn.layer.cornerRadius = 3.0;
    lookBtn.clipsToBounds = YES;
    [lookBtn setTitle:title forState:(UIControlStateNormal)];
    lookBtn.layer.shadowColor   = MainColor2.CGColor;
    lookBtn.layer.shadowOffset  = CGSizeMake(4, 4);
    lookBtn.layer.shadowOpacity = 0.5;
    lookBtn.layer.shadowRadius  = 5;
    
    //渐变颜色
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors     = @[(__bridge id)MainColor2.CGColor ,(__bridge id)MainColor1.CGColor];
    gradientLayer.locations  = @[@0.3, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint   = CGPointMake(1.0, 0);
    gradientLayer.frame      = CGRectMake(0, 0,  frame.size.width, frame.size.height);
//    gradientLayer.cornerRadius = 50;
    [lookBtn.layer addSublayer:gradientLayer];
    
    return lookBtn;
}


@end
