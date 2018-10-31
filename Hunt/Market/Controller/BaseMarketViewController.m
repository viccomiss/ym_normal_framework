//
//  BaseMarketViewController.m
//  Hunt
//
//  Created by 杨明 on 2018/8/2.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "BaseMarketViewController.h"
#import "CoinMarketViewController.h"
#import "ExchangeViewController.h"

@interface BaseMarketViewController ()<UIScrollViewDelegate>

/* seg */
@property (nonatomic, strong) UISegmentedControl *segControl;
/* scrollView */
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation BaseMarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self reloadNavigationBar:YES];
    [self createUI];
}

#pragma mark - action
- (void)indexDidChangeForSegmentedControl:(UISegmentedControl *)sender{
    
    NSInteger selecIndex = sender.selectedSegmentIndex;
    switch(selecIndex){
        case 0:
            sender.selectedSegmentIndex=0;
            [self.scrollView setContentOffset:CGPointMake(0 , 0) animated:YES];

           
            break;
            
        case 1:
            sender.selectedSegmentIndex = 1;
            [self.scrollView setContentOffset:CGPointMake(MAINSCREEN_WIDTH , 0) animated:YES];
            
            break;
            
        default:
            break;
    }
}

- (void)searchTouch{
    
}

#pragma mark - UI
- (void)createUI{
    
    self.segControl = [[UISegmentedControl alloc] initWithItems:@[LocalizedString(@"币行情"),LocalizedString(@"交易所")]];
    self.segControl.frame = CGRectMake(0, 0, AdaptX(120), AdaptY(28));
    self.segControl.selectedSegmentIndex = 0;
    [self.segControl py_addToThemeColorPool:@"tintColor"];
    [self.segControl addTarget:self action:@selector(indexDidChangeForSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    [self.navigationItem setTitleView:self.segControl];
    
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithImage:ImageName(@"nav_search") style:UIBarButtonItemStylePlain target:self action:@selector(searchTouch)];
    self.navigationItem.rightBarButtonItem = searchItem;
    
    
    [self.view addSubview:self.scrollView];
    
    CoinMarketViewController *coinMVC = [[CoinMarketViewController alloc] init];
    [self addChildViewController:coinMVC];
    [self.scrollView addSubview:coinMVC.view];
    
    ExchangeViewController *exchangeVC = [[ExchangeViewController alloc] init];
    [self addChildViewController:exchangeVC];
    exchangeVC.view.frame = CGRectMake(MAINSCREEN_WIDTH, self.view.easy_y, MAINSCREEN_WIDTH, self.view.easy_height);
    [self.scrollView addSubview:exchangeVC.view];

}

#pragma mark - init
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT)];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollEnabled = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(2 * MAINSCREEN_WIDTH, _scrollView.easy_height);
    }
    return _scrollView;
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
