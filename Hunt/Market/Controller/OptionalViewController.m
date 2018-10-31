//
//  OptionalViewController.m
//  Hunt
//
//  Created by 杨明 on 2018/7/30.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "OptionalViewController.h"
#import "OptionalRecommendView.h"
#import "WeightMenuView.h"

@interface OptionalViewController ()

/* optionalView */
@property (nonatomic, strong) OptionalRecommendView *recommendView;
/* menuView */
@property (nonatomic, strong) WeightMenuView *menuView;

@end

@implementation OptionalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}

#pragma mark - action


#pragma mark - UI
- (void)createUI{
    
    [self.view addSubview:self.menuView];
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.right.mas_equalTo(self.view);
        make.height.equalTo(@(AdaptY(35)));
    }];
    
    [self.view addSubview:self.recommendView];
    [self.recommendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.menuView.mas_bottom);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.left.right.mas_equalTo(self.view);
    }];
}

#pragma mark - init
- (OptionalRecommendView *)recommendView{
    if (!_recommendView) {
        _recommendView = [[OptionalRecommendView alloc] init];
    }
    return _recommendView;
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
