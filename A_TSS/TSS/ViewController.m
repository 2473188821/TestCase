//
//  ViewController.m
//  TSS
//
//  Created by Chenfy on 2020/8/24.
//  Copyright © 2020 Chenfy. All rights reserved.
//

#import "ViewController.h"

//SCREEN_SIZE 屏幕尺寸
#define KSCREEN_WIDTH   ([UIScreen mainScreen].bounds.size.width)
#define KSCREEN_HEIGTH  ([UIScreen mainScreen].bounds.size.height)

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *datasource;

@end

@implementation ViewController

- (NSArray *)datasource {
    NSArray *data = @[
        @"ViewTest -HViewViewController",
        @"音视频捕捉 -HVideoCaptureViewController",
        @"排序算法 -HSortViewController",
        @"文件句柄的使用 -HFileViewController",
        @"OC、CPP混编 -HCPPViewController",
        @"链式、函数编程测试 -HCodeFuncViewController",
        @"view绘制相关 -HDrawViewController",
        @"Layer 测试 -HLayerViewController",
        @"Block 相关 -HBlockViewController",
        @"AudioUnit Test -HAudioUnitViewController",
        @"GCD Test -GCDViewController",
        @"文件上传 -HNetworkViewController",
        @"单例释放 -HGCDViewController",
        @"Memory（内存相关）-HMemoryViewController",
        @"Lifecycle -HLifecycleViewController",
    ];
    return data;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.
}


#pragma mark --
#pragma mark -- tableView
- (UITableView *)tableView {
    if (!_tableView) {
        CGRect fm = CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGTH);
        _tableView = [[UITableView alloc]initWithFrame:fm style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.datasource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    NSString *text = self.datasource[indexPath.row];
    
    NSString *textString = [NSString stringWithFormat:@"%ld、 %@",(long)indexPath.row,text];
    cell.textLabel.text = textString;
    return cell;
}

-  (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *funString = self.datasource[indexPath.row];
    NSString *funVC = [[funString componentsSeparatedByString:@"-"]lastObject];
    Class cls = NSClassFromString(funVC);
    id controller = [[cls alloc]init];
    
    [self presentViewController:controller animated:YES completion:^{
        
    }];
}


@end
