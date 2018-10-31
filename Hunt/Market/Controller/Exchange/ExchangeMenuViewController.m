//
//  ExchangeMenuViewController.m
//  Hunt
//
//  Created by 杨明 on 2018/8/2.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "ExchangeMenuViewController.h"
#import "SPPageMenu.h"
#import "ExchangeMarketViewController.h"

#define pageMenuH AdaptY(40)
#define scrollViewHeight (MAINSCREEN_HEIGHT - NavbarH - pageMenuH)

@interface ExchangeMenuViewController ()<UIScrollViewDelegate,SPPageMenuDelegate>

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) SPPageMenu *pageMenu;
@property (nonatomic, strong) NSMutableArray *myChildViewControllers;
@property (nonatomic, strong) UIScrollView *scrollView;
/* allData */
@property (nonatomic, strong) NSArray *allDataArray;

@end

@implementation ExchangeMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self reloadNavigationBar:YES];
    [self createUI];
}

#pragma mark - action
- (void)searchTouch{
    
}

#pragma mark - UI
- (void)createUI{
    
    [self.navigationBar addSubview:[self addNavView]];
    
//    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithImage:ImageName(@"exchange") style:UIBarButtonItemStylePlain target:self action:@selector(searchTouch)];
//
//    UIBarButtonItem *introduceItem = [[UIBarButtonItem alloc] initWithImage:ImageName(@"nav_search") style:UIBarButtonItemStylePlain target:self action:@selector(searchTouch)];
//    self.navigationItem.rightBarButtonItems = @[searchItem, introduceItem];
    
    [self.dataArr addObjectsFromArray:@[@"全部",@"BTC市场",@"ETH市场"]];
    
    [self.view addSubview:self.pageMenu];
    
    for (int i = 0; i < self.dataArr.count; i++) {
        BaseViewController *baseVc = [[NSClassFromString(@"ExchangeMarketViewController") alloc] init];
        baseVc.closeNav = YES;
        [self addChildViewController:baseVc];
        
        // 控制器本来自带childViewControllers,但是遗憾的是该数组的元素顺序永远无法改变，只要是addChildViewController,都是添加到最后一个，而控制器不像数组那样，可以插入或删除任意位置，所以这里自己定义可变数组，以便插入(删除)(如果没有插入(删除)功能，直接用自带的childViewControllers即可)
        [self.myChildViewControllers addObject:baseVc];
    }
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavbarH + pageMenuH, MAINSCREEN_WIDTH, scrollViewHeight)];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.backgroundColor = BackRedColor;
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    
    // 这一行赋值，可实现pageMenu的跟踪器时刻跟随scrollView滑动的效果
    self.pageMenu.bridgeScrollView = self.scrollView;
    
    // pageMenu.selectedItemIndex就是选中的item下标
    if (self.pageMenu.selectedItemIndex < self.myChildViewControllers.count) {
        BaseViewController *baseVc = self.myChildViewControllers[self.pageMenu.selectedItemIndex];
        [scrollView addSubview:baseVc.view];
        baseVc.view.frame = CGRectMake(MAINSCREEN_WIDTH*self.pageMenu.selectedItemIndex, 0, MAINSCREEN_WIDTH, scrollViewHeight);
        scrollView.contentOffset = CGPointMake(MAINSCREEN_WIDTH*self.pageMenu.selectedItemIndex, 0);
        scrollView.contentSize = CGSizeMake(self.dataArr.count*MAINSCREEN_WIDTH, 0);
    }
}

- (UIView *)addNavView{
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake((MAINSCREEN_WIDTH - AdaptX(120)) / 2, 0, AdaptX(120), NavbarH - StatusBarH)];
    
    BaseLabel *nameLabel = [SEFactory labelWithText:@"OKEx" frame:CGRectZero textFont:[UIFont boldSystemFontOfSize:16] textColor:MainBlackColor textAlignment:NSTextAlignmentLeft];
    [navView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(navView.mas_centerY);
        make.centerX.mas_equalTo(navView.mas_centerX);
    }];
    
    BaseImageView *iconView = [[BaseImageView alloc] init];
    iconView.backgroundColor = BackGroundColor;
    [navView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(nameLabel.mas_left).offset(-MidPadding);
        make.centerY.mas_equalTo(navView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(AdaptX(20), AdaptX(20)));
    }];
    
    return navView;
}

#pragma mark - page delegate
- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedAtIndex:(NSInteger)index {
    NSLog(@"%zd",index);
}

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    
    NSLog(@"%zd------->%zd",fromIndex,toIndex);
    // 如果fromIndex与toIndex之差大于等于2,说明跨界面移动了,此时不动画.
    if (labs(toIndex - fromIndex) >= 2) {
        [self.scrollView setContentOffset:CGPointMake(MAINSCREEN_WIDTH * toIndex, 0) animated:NO];
    } else {
        [self.scrollView setContentOffset:CGPointMake(MAINSCREEN_WIDTH * toIndex, 0) animated:YES];
    }
    if (self.myChildViewControllers.count <= toIndex) {return;}
    
    UIViewController *targetViewController = self.myChildViewControllers[toIndex];
    // 如果已经加载过，就不再加载
    if ([targetViewController isViewLoaded]) return;
    
    targetViewController.view.frame = CGRectMake(MAINSCREEN_WIDTH * toIndex, 0, MAINSCREEN_WIDTH, scrollViewHeight);
    [_scrollView addSubview:targetViewController.view];
}

- (void)pageMenu:(SPPageMenu *)pageMenu functionButtonClicked:(UIButton *)functionButton {
    
}

- (SPPageMenu *)pageMenu{
    if (!_pageMenu && self) {
        _pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, NavbarH, MAINSCREEN_WIDTH, pageMenuH) trackerStyle:SPPageMenuTrackerStyleLine];
        // 传递数组，默认选中第2个
        _pageMenu.showFuntionButton = YES;
        [_pageMenu setItems:self.dataArr selectedItemIndex:0];
        _pageMenu.itemTitleFont = [UIFont systemFontOfSize:AdaptX(13)];
        [_pageMenu py_addToThemeColorPool:@"selectedItemTitleColor"];
        [_pageMenu.tracker py_addToThemeColorPool:@"backgroundColor"];
        _pageMenu.unSelectedItemTitleColor = TextDarkGrayColor;
        _pageMenu.backgroundColor = WhiteTextColor;
        _pageMenu.dividingLine.hidden = YES;
        // 设置代理
        _pageMenu.delegate = self;
    }
    return _pageMenu;
}

- (NSMutableArray *)myChildViewControllers {
    
    if (!_myChildViewControllers) {
        _myChildViewControllers = [NSMutableArray array];
    }
    return _myChildViewControllers;
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
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
