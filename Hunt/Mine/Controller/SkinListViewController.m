//
//  SkinListViewController.m
//  Hunt
//
//  Created by 杨明 on 2018/8/6.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "SkinListViewController.h"
#import "SelectBoxCell.h"
#import "SelectBoxModel.h"

@interface SkinListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) BaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation SkinListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = LocalizedString(@"皮肤切换");
    [self createUI];
    [self setData];
}

- (void)setData{
    
    NSArray *titles = @[@"优雅蓝",@"活力橙"];
    NSArray *colors = @[MainBlueColor, MainOrangColor];
    NSArray *type = @[[NSNumber numberWithUnsignedInteger:ThemeBlueType],[NSNumber numberWithUnsignedInteger:ThemeOrangeType]];
    for (int i = 0; i < 2; i++) {
        SelectBoxModel *m = [[SelectBoxModel alloc] init];
        m.name = titles[i];
        m.skinColor = colors[i];
        m.themeType = [type[i] unsignedIntegerValue];
        if (i == 0) {
            m.selected = YES;
        }
        [self.dataArray addObject:m];
    }
    [self.tableView reloadData];
}

#pragma mark - table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectBoxCell *cell = [SelectBoxCell selectBoxCell:tableView];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectBoxModel *model = self.dataArray[indexPath.row];
    for (SelectBoxModel *m in self.dataArray) {
        if ([m.name isEqualToString:model.name]) {
            m.selected = YES;
        }else{
            m.selected = NO;
        }
    }
    [self.tableView reloadData];
    [[ThemeManager sharedInstance] reloadTheme:model.themeType needPostNotification:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return AdaptY(50);
}


#pragma mark - UI
- (void)createUI{
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(NavbarH);
        make.left.right.bottom.mas_equalTo(self.view);
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
