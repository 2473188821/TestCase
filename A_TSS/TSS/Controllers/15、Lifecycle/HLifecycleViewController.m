//
//  HLifecycleViewController.m
//  TSS
//
//  Created by Chenfy on 2022/5/7.
//  Copyright © 2022 Chenfy. All rights reserved.
//

#import "HLifecycleViewController.h"

@interface HLifecycleViewController ()
@property(nonatomic,strong)UILabel *label;
@property(nonatomic,strong)UIButton *button;

@end

@implementation HLifecycleViewController


#pragma mark -- Lifecycle
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}

- (void)loadView {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.orangeColor;
    // Do any additional setup after loading the view.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -- Property
- (UILabel *)label {
    if (!_label) {
        _label = [UILabel new];
    }
    return _label;
}
/** 按钮懒加载 */
- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _button;
}

#pragma mark -- delegate
/*
 代理分段
 建议为每一个代理添加一个分段，并且分段的名称应该是代理名称
 */

#pragma mark -- Inherit
/*
 Inherit分段
 对从父类继承的方法，单独添加一个inherit分段，示例如下:
 */

#pragma mark -- Events
/*
 Events分段
 为button的点击事件，geture的响应方法，KVO的回调，Notification的 回调方法添加一个
    events分段，在该分段的方法中，调用对应业务的 方法，对应业务的方法放在对应业务的分段。
 */

#pragma mark -- Public Methods
/*
 Public分段 public段的方法，为需要暴露给其他类，供其他类调用的方法，根据
 具体情况决定是否添加该分段。
 */

#pragma mark -- Private Method
/*
 Private分段
 private段的方法，是为实现本类业务而添加的方法，不需要暴露接又 给其他类，只提供给本 类的方法调用。根据具体情况决定是否需要 添加该分段。
 */
@end
