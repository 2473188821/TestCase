//
//  ViewController.m
//  TSS
//
//  Created by Chenfy on 2020/8/24.
//  Copyright © 2020 Chenfy. All rights reserved.
//

#import "ViewController.h"
#import "HViewViewController.h"
#import "HVideoCaptureViewController.h"
#import "HSortViewController.h"
#import "HFileViewController.h"
#import "HCPPViewController.h"
#import "HCodeFuncViewController.h"
#import "HDrawViewController.h"
#import "HLayerViewController.h"
#import "HBlockViewController.h"
#import "HAudioUnitViewController.h"

typedef NS_ENUM(NSInteger ,VCType) {
    VCType_ViewTest,        //view test
    VCType_VideoCapture,    //音视频捕捉
    VCType_SortAlgor,       //排序算法
    VCType_FileHandle,      //文件句柄的使用
    VCType_OCWithCpp,       //OC、CPP混编
    VCType_CodeFuncTest,    //链式、函数编程测试
    VCType_DrawView,        //view绘制相关
    VCType_LayerTest,       //Layer 测试
    VCType_Block,           //Block 相关
    VCType_AudioUnit,       //AudioUnit test
};

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *datasource;

@end

@implementation ViewController

- (NSArray *)datasource {
    NSArray *data = @[
        @"View Test" ,
        @"Video Capture",
        @"Sort Algor",
        @"File Handler",
        @"OC with CPP",
        @"Code Function Test",
        @"Draw View About",
        @"Layer Test",
        @"Block Test",
        @"AudioUnit Test",
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
    HHBaseViewController *vcController = nil;
    switch (indexPath.row) {
        case VCType_ViewTest:
            vcController = [HViewViewController new];
            break;
        case VCType_VideoCapture:
            vcController = [HVideoCaptureViewController new];
            break;
        case VCType_SortAlgor:
            vcController = [HSortViewController new];
            break;
        case VCType_FileHandle:
            vcController = [HFileViewController new];
            break;
        case VCType_OCWithCpp:
            vcController = [HCPPViewController new];
            break;
        case VCType_CodeFuncTest:
            vcController = [HCodeFuncViewController new];
            break;
        case VCType_DrawView:
            vcController = [HDrawViewController new];
            break;
        case VCType_LayerTest:
            vcController = [HLayerViewController new];
            break;
        case VCType_Block:
            vcController = [HBlockViewController new];
            break;
        case VCType_AudioUnit:
            vcController = [HAudioUnitViewController new];
            break;
            
        default:
            break;
    }
    
    [self presentViewController:vcController animated:YES completion:^{
        
    }];
}


@end
