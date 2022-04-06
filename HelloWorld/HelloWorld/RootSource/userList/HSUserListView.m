//
//  HSUserListView.m
//  HSRoomUI
//
//  Created by Chenfy on 2022/4/1.
//  Copyright © 2022 刘强强. All rights reserved.
//

#import "HSUserListView.h"
#import <Masonry.h>

@interface HSUserListView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIButton *backBtn;
@property(nonatomic,strong)UILabel *labelTitle;

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *lists;

@end

@implementation HSUserListView

- (void)showListView:(NSArray *)users {
    _lists = users;
    [self configView];
}

- (void)configView {
    self.layer.backgroundColor = [UIColor colorWithRed:46/255.0 green:49/255.0 blue:56/255.0 alpha:1.0].CGColor;
    
    [self addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(5);
        make.top.mas_equalTo(self).offset(20);
//        make.width.height.mas_equalTo(24);
    }];
    
    [self addSubview:self.labelTitle];
    [self.labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backBtn.mas_right).offset(20);
        make.right.mas_equalTo(self);
        make.centerY.mas_equalTo(self.backBtn);
        make.height.mas_equalTo(35);
    }];
    [self addSubview:self.tableView];
    
    [self addSubview:self.tableView];
    int side_space = 20;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(side_space);
        make.right.bottom.mas_equalTo(-side_space);
        make.top.mas_equalTo(self.labelTitle.mas_bottom).offset(side_space/2);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *img = [UIImage imageNamed:@"chevron-left"];
        [_backBtn setBackgroundImage:img forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}
- (void)backButtonClicked {
    [self innerCallBack:HSListChooseType_None index:-1];
}
- (void)innerCallBack:(HSListChooseType)type index:(NSInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(listCallBack:index:list:)]) {
        [self.delegate listCallBack:type index:index list:_lists];
    }
}

- (UILabel *)labelTitle {
    if (!_labelTitle) {
        _labelTitle = [[UILabel alloc]init];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"选择一个联系人"attributes: @{NSFontAttributeName: [UIFont systemFontOfSize:15],NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];

        _labelTitle.attributedText = string;
        _labelTitle.textAlignment = NSTextAlignmentLeft;
        _labelTitle.alpha = 1.0;
    }
    return _labelTitle;
}

#pragma mark --
#pragma mark -- tableView
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = UIColor.lightGrayColor;

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
    return [_lists count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell)
    {
        UIColor *clor = [UIColor colorWithRed:46/255.0 green:49/255.0 blue:56/255.0 alpha:1.0];
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.backgroundColor = clor;
    }
   
    NSString *text = @"所有人";
    NSInteger row = indexPath.row;
    if (row > 0) {
        text = @"xxxx";
        cell.textLabel.textColor = UIColor.whiteColor;
    } else {
        UIColor *color = [UIColor colorWithRed:255/255.0 green:149/255.0 blue:2/255.0 alpha:1.0];
        cell.textLabel.textColor = color;
    }
    cell.textLabel.text = text;
    return cell;
}

-  (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSInteger index = indexPath.row - 1;
    HSListChooseType type = index == 0 ? HSListChooseType_All : HSListChooseType_User;
    [self innerCallBack:type index:index];
}

@end
