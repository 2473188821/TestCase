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


typedef NS_ENUM(NSInteger ,VCType) {
    VCType_ViewTest,        //view test
    VCType_VideoCapture,    //音视频捕捉
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
- (UITableView *)tableView
{
    if (!_tableView)
    {
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
            
        default:
            break;
    }
    
    [self presentViewController:vcController animated:YES completion:^{
        
    }];

//    [self.navigationController pushViewController:vcController animated:NO];
    
}


@end
