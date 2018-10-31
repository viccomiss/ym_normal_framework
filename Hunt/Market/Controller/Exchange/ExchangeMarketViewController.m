//
//  ExchangeMarketViewController.m
//  Hunt
//
//  Created by 杨明 on 2018/8/2.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "ExchangeMarketViewController.h"
#import "CoinMarketCell.h"
#import "WeightMenuView.h"

@interface ExchangeMarketViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) BaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
/* menu */
@property (nonatomic, strong) WeightMenuView *menuView;

@end

@implementation ExchangeMarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}

#pragma mark - table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return self.dataArray.count;
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CoinMarketCell *cell = [CoinMarketCell coinMarketCell:tableView];
    //    Exchange *model = self.dataArray[indexPath.row];
    //    model.index = indexPath.row;
    //    cell.model = model;
    return cell;
}

#pragma mark - table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return AdaptY(58);
}

#pragma mark - UI
- (void)createUI{
        
    [self.view addSubview:self.menuView];
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.right.mas_equalTo(self.view);
        make.height.equalTo(@(AdaptY(35)));
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.menuView.mas_bottom);
    }];
}

#pragma mark - init
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (BaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = WhiteTextColor;
    }
    return _tableView;
}

- (WeightMenuView *)menuView{
    if (!_menuView) {
        _menuView = [[WeightMenuView alloc] initWithMenuType:WeightMenuFourType titleArray:@[LocalizedString(@"市值"),LocalizedString(@"成交额"),LocalizedString(@"价格"),LocalizedString(@"今日涨幅")]];
    }
    return _menuView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
