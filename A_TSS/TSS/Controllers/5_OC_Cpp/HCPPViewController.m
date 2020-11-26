//
//  HCPPViewController.m
//  TSS
//
//  Created by Chenfy on 2020/11/23.
//  Copyright © 2020 Chenfy. All rights reserved.
//

#import "HCPPViewController.h"
#import "CAgent.h"

@interface HCPPViewController ()<CAgentDelegate>
@property(nonatomic,strong)CAgent *agent;

@end

@implementation HCPPViewController

- (CAgent *)agent {
    if (!_agent) {
        _agent = [[CAgent alloc]init];
        _agent.delegate = self;
    }
    return _agent;
}

- (void)renderComplete:(NSString *)str
{
    NSLog(@"render OK---:%@",str);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)cplusplusTest {
    [self.agent initEngine];
    [self.agent startEngine:@"hello world!"];
    [self.agent getChannelList];
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
