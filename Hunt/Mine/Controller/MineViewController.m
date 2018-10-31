//
//  MineViewController.m
//  nuoee_krypto
//
//  Created by Mac on 2018/5/30.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "MineViewController.h"
#import "MineCell.h"
#import "MineModel.h"
#import "MineHeaderView.h"
#import "LanguageViewController.h"
#import "CurrencyListViewController.h"
#import "SkinListViewController.h"

@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) BaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
/* header */
@property (nonatomic, strong) MineHeaderView *headerView;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = LocalizedString(@"我的");
    [self createUI];
    [self setData];
}

- (void)reloadTheme:(NSNotification *)notification{
    
}

- (void)setData{
    NSMutableArray *arr1 = [NSMutableArray array];
    NSArray *nameArr1 = @[@"币资产",@"消息中心",@"红涨绿跌",@"价格显示",@"多语言",@"皮肤切换"];
    NSArray *type1 = @[[NSNumber numberWithUnsignedInteger:MineSummaryCellType], [NSNumber numberWithUnsignedInteger:MineNormalCellType],[NSNumber numberWithUnsignedInteger:MineSwitchCellType],[NSNumber numberWithUnsignedInteger:MineSummaryCellType],[NSNumber numberWithUnsignedInteger:MineSummaryCellType],[NSNumber numberWithUnsignedInteger:MineSummaryCellType]];
    for (int i = 0; i < nameArr1.count; i++) {
        MineModel *model = [[MineModel alloc] init];
        model.name = nameArr1[i];
        model.type = [type1[i] integerValue];
        [arr1 addObject:model];
    }
    
    NSMutableArray *arr2 = [NSMutableArray array];
    NSArray *nameArr2 = @[@"联系我们",@"关于虹掌"];
    NSArray *type2 = @[[NSNumber numberWithUnsignedInteger:MineNormalCellType], [NSNumber numberWithUnsignedInteger:MineSummaryCellType]];
    for (int i = 0; i < nameArr2.count; i++) {
        MineModel *model = [[MineModel alloc] init];
        model.name = nameArr2[i];
        model.type = [type2[i] integerValue];
        [arr2 addObject:model];
    }
    
    NSMutableArray *arr3 = [NSMutableArray array];
    NSArray *nameArr3 = @[@"清除缓存"];
    NSArray *type3 = @[[NSNumber numberWithUnsignedInteger:MineSummaryCellType]];
    for (int i = 0; i < nameArr3.count; i++) {
        MineModel *model = [[MineModel alloc] init];
        model.name = nameArr3[i];
        model.type = [type3[i] integerValue];
        [arr3 addObject:model];
    }
    
    [self.dataArray addObject:arr1];
    [self.dataArray addObject:arr2];
    [self.dataArray addObject:arr3];
    [self.tableView reloadData];
}


#pragma mark - table view datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 6;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 1;
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineCell *cell = [MineCell mineCell:tableView];
    NSArray *arr = self.dataArray[indexPath.section];
    MineModel *model = arr[indexPath.row];
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    model.summary = @"￥103,005";
                }
                    break;
                case 1:

                    break;
                case 2:
                {
                    
                }
                    break;
                case 3:
                {
                    model.summary = @"人民币CNY";
                }
                    break;
                case 4:
                {
                    model.summary = @"简体中文";
                }
                    break;
                case 5:
                {
                    model.summary = @"优雅蓝";
                }
                    break;
            }
        }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                {
                    
                }
                    break;
                case 1:
                {
                    model.summary = @"V1.0";
                }
                    break;
            break;
            }
        case 2:
            switch (indexPath.row) {
                case 0:
                {
                    model.summary = @"5.4MB";
                }
                    break;
            }
            break;
    }
    cell.model = arr[indexPath.row];
    return cell;
}

#pragma mark - table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    
                    break;
                case 1:
                    
                    break;
                case 2:
                    
                    break;
                case 3:
                {
                    CurrencyListViewController *currencyVC = [[CurrencyListViewController alloc] init];
                    [self.navigationController pushViewController:currencyVC animated:YES];
                }
                    break;
                case 4:
                {
                    LanguageViewController *languageVC = [[LanguageViewController alloc] init];
                    [self.navigationController pushViewController:languageVC animated:YES];
                }
                    break;
                case 5:
                {
                    SkinListViewController *skinVC = [[SkinListViewController alloc] init];
                    [self.navigationController pushViewController:skinVC animated:YES];
                }
                    break;
            }
            break;
        case 1:
            
            break;
        case 2:
            
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return AdaptY(45);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return MidPadding;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

#pragma mark - UI
- (void)createUI{
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, AdaptY(80))];
}

#pragma mark - init
- (MineHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[MineHeaderView alloc] init];
    }
    return _headerView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (BaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = BackGroundColor;
    }
    return _tableView;
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
