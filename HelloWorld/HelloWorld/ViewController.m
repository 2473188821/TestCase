//
//  ViewController.m
//  HelloWorld
//
//  Created by Chenfy on 16/3/24.
//  Copyright © 2016年 Chenfy. All rights reserved.
//

#import "ViewController.h"
#import "HMenuTool.h"

//SCREEN_SIZE 屏幕尺寸
#define KSCREEN_WIDTH   ([UIScreen mainScreen].bounds.size.width)
#define KSCREEN_HEIGTH  ([UIScreen mainScreen].bounds.size.height)

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation ViewController

- (void)envInitView {
    self.title = @"Root Controller";
    self.navigationController.navigationBar.backgroundColor = UIColor.whiteColor;
    self.view.backgroundColor = UIColor.lightGrayColor;
}

- (void)injected
{
    NSLog(@"I've been injected: %@", self);
    self.view.backgroundColor = UIColor.whiteColor;
}

- (void)buttonClicked {
    NSLog(@"button clicked!");
    NSLog(@"button clicked!");

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self envInitView];
    
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [[HMenuTool menusArray]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    NSString *title = [HMenuTool menusArray][indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld-%@",(long)indexPath.row,title];
    return cell;
}

-  (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = [HMenuTool menusArray][indexPath.row];
    NSString *vcString = [[title componentsSeparatedByString:@"-"]firstObject];
    
    Class class = NSClassFromString(vcString);
    UIViewController *vc = [class new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
