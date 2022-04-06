//
//  TestViewController.m
//  HelloWorld
//
//  Created by Chenfy on 2022/4/1.
//  Copyright © 2022 Chenfy. All rights reserved.
//

#import "TestViewController.h"
#import "HSUserListView.h"

@interface TestViewController ()<HSUserListViewDelegate>
@property(nonatomic,strong)HSUserListView *listView;

@end

@implementation TestViewController

- (void)injected
{
    NSLog(@"I've been injected: %@", self);
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self.view addSubview:self.listView];
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(50);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    [self.listView showListView:@[@"zhagn--"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.listView];
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(50);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    // Do any additional setup after loading the view.
}

- (HSUserListView *)listView {
    if (!_listView) {
        _listView = [HSUserListView new];
        _listView.delegate = self;
    }
    return _listView;
}

- (void)listCallBack:(BOOL)selected index:(NSInteger)index list:(NSArray *)list {
    NSLog(@"--%d-----<%ld>------%@-----------",selected,(long)index,list);
    
    
    [self.listView removeFromSuperview];
    _listView = nil;
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
