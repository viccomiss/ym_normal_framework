//
//  CoinMarketViewController.m
//  Hunt
//
//  Created by 杨明 on 2018/8/2.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "CoinMarketViewController.h"
#import "OptionalViewController.h"
#import "CoinViewController.h"

@interface CoinMarketViewController ()

@end

@implementation CoinMarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self reloadNavigationBar:YES];
    [self createUI];
}

- (instancetype)init{
    if (self == [super init]) {
        
        
    }
    return self;
}

#pragma mark - UI
- (void)createUI{
    
    
}

#pragma mark - datasource
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return 2;
}

- (NSInteger)numbersOfTitlesInMenuView:(WMMenuView *)menu{
    return 2;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    
    switch (index) {
        case 0:
        {
            OptionalViewController *optionVC = [[OptionalViewController alloc]init];
            return optionVC;
        }
            break;
        case 1:
        {
            CoinViewController *coinVC = [[CoinViewController alloc]init];
            return coinVC;
        }
            break;
    }
    
    return nil;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    
    switch (index) {
        case 0:
        {
            return LocalizedString(@"自选");
        }
            break;
        case 1:
        {
            return LocalizedString(@"市值/涨幅");
        }
            break;
    }
    
    return nil;
}

//当前所在控制器
- (void)pageController:(WMPageController *)pageController willEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info{
    
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
