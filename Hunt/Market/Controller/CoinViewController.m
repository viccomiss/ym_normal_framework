//
//  CoinViewController.m
//  Hunt
//
//  Created by 杨明 on 2018/8/2.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "CoinViewController.h"
#import "CoinMarketCell.h"
#import "WeightMenuView.h"
#import "KlineDetailViewController.h"
#import "CoinRanksModel.h"

@interface CoinViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) BaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
/* menu */
@property (nonatomic, strong) WeightMenuView *menuView;
/* orderType */
@property (nonatomic, copy) NSString *orderType;
/* sort */
@property (nonatomic, assign) NSInteger sort;

@end

@implementation CoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.orderType = [self weightArr][0];
    self.sort = 1;
    
    [self createUI];
    [self setRefresh];
}

#pragma mark - request
-(void)setRefresh{
    [[SERefresh sharedSERefresh] normalModelRefresh:self.tableView refreshType:RefreshTypeDropDown firstRefresh:YES timeLabHidden:YES stateLabHidden:YES dropDownBlock:^{
        [self.tableView.mj_footer resetNoMoreData];
        [self.tableView.mj_footer endRefreshing];
        [self loadDataWithLoadMore:NO];
    } upDropBlock:nil];
}

-(void)loadDataWithLoadMore:(BOOL)isMore{
    [CoinRanksModel coin_ranks:@{@"orderType" : self.orderType, @"sort" : [NSNumber numberWithInteger:self.sort]} Success:^(NSArray *list) {
        
        [self.tableView.mj_header endRefreshing];
        self.dataArray = [NSMutableArray arrayWithArray:list];
    
        if (self.dataArray.count == 0) {
            [self.noDataView showNoDataView:CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT-NavbarH) type:NoTextType tagStr:@"" needReload:NO reloadBlock:nil];
            [self.tableView addSubview:self.noDataView];
        }else{
            self.noDataView.hidden = YES;
        }
        
        [self.tableView reloadData];
        
    } Failure:^(NSError *error) {
        
    }];
}


#pragma mark - table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.dataArray.count;
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CoinMarketCell *cell = [CoinMarketCell coinMarketCell:tableView];
//    CoinRanksModel *model = self.dataArray[indexPath.row];
//    cell.model = model;
    return cell;
}

#pragma mark - table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    CoinRanksModel *model = self.dataArray[indexPath.row];
    KlineDetailViewController *kdetailVC = [[KlineDetailViewController alloc] init];
//    kdetailVC.coinModel = model;
    [self.navigationController pushViewController:kdetailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return AdaptY(58);
}

#pragma mark - UI
- (void)createUI{
    
    WeakSelf(self);
    [self.view addSubview:self.menuView];
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.right.mas_equalTo(self.view);
        make.height.equalTo(@(AdaptY(35)));
    }];
    
    self.menuView.weightMenuBlock = ^(WeightMenuBtnType btnType, NSInteger tag) {
        weakself.orderType = [weakself weightArr][tag];
        weakself.sort = btnType == WeightMenuBtnUpType ? 2 : 1;
        [weakself.tableView.mj_header beginRefreshing];
    };
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.menuView.mas_bottom);
    }];
}

#pragma mark - init
- (NSArray *)weightArr{
    return @[@"MARKET_CAP",@"TURNOVER",@"PRICE",@"DEGREE"];
}

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
