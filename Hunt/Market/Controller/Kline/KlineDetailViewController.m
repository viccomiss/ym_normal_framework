//
//  JoinUpSocketViewController.m
//  ZXKlineDemo
//
//  Created by 郑旭 on 2017/9/13.
//  Copyright © 2017年 郑旭. All rights reserved.
//
#import <Masonry.h>
#import "KlineDetailViewController.h"
#import "ZXAssemblyView.h"
#import <SocketRocket.h>
#import "KLineDetailHeader.h"
#import "KlineIndView.h"
#import "KlineIndModel.h"
#import "KlineMoreCycView.h"
#import "NSString+JLAdd.h"
#import "SEUserDefaults.h"
#import "UserModel.h"
#import "KlineMenuView.h"
#import "CoinMarketForExchangeViewController.h"
#import "CoinMoneyViewController.h"
#import "CoinIntroduceViewController.h"
#import "DateManager.h"

#define HEADERHEIGHT AdaptY(95)
#define CYCHEIGHT AdaptY(35)
#define MENUHEIGHT AdaptY(40)
#define MORECYCHEIGHT AdaptY(82)
#define TOPVIEWHEIGHT HEADERHEIGHT + CYCHEIGHT + MidPadding * 2 + TotalHeight + MENUHEIGHT

@interface KlineDetailViewController ()<AssemblyViewDelegate,ZXSocketDataReformerDelegate,SRWebSocketDelegate,UIScrollViewDelegate>
/**
 *k线实例对象
 */
@property (nonatomic,strong) ZXAssemblyView *assenblyView;
/**
 *横竖屏方向
 */
@property (nonatomic,assign) UIInterfaceOrientation orientation;
/**
 *当前绘制的指标名
 */
@property (nonatomic,strong) NSString *currentDrawQuotaName;
/**
 *所有的指标名数组
 */
@property (nonatomic,strong) NSArray *quotaNameArr;
/**
 *所有数据模型
 */
@property (nonatomic,strong) NSMutableArray *dataArray;
/**
 *
 */
@property (nonatomic,assign) ZXTopChartType topChartType;

@property (nonatomic,strong) NSTimer  *timer;
/* socket */
@property (nonatomic, strong) SRWebSocket *webSocket;
/* drawDone */
@property (nonatomic, assign) BOOL drawDone;
/* channel */
@property (nonatomic, copy) NSString *channel;
/* header */
@property (nonatomic, strong) KLineDetailHeader *headerView;
/* ind */
@property (nonatomic, strong) KlineIndView *indView;
/* more */
@property (nonatomic, strong) KlineMoreCycView *moreCycView;
/* quota */
@property (nonatomic, strong) KlineIndView *quotaView;

/* ind 当前指标 */
@property (nonatomic, copy) NSString *currentInd;

/* 横屏price */
@property (nonatomic, strong) UIView *landScapePriceView;
/* curreny */
@property (nonatomic, strong) BaseLabel *landScapeCurrenyLabel;
/* price */
@property (nonatomic, strong) BaseLabel *landScapePriceLabel;
/* 最新kline */
@property (nonatomic, strong) KlineModel *newklineModel;
/* menuChildView */
@property (nonatomic, strong) UIScrollView *mainScrollView;
/* menuView */
@property (nonatomic, strong) KlineMenuView *menuView;
/* coinMarket */
@property (nonatomic, strong) CoinMarketForExchangeViewController *coinMarketVC;
/* coinMoney */
@property (nonatomic, strong) CoinMoneyViewController *coinMoneyVC;
/* coinIntroduce */
@property (nonatomic, strong) CoinIntroduceViewController *coinIntroduceVC;

@end

@implementation KlineDetailViewController
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)navigationBarClickBack{
    
    self.webSocket.delegate = nil;
    [self.webSocket close];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.hidden = NO;
    [self createUI];
    [self addConstrains];
//    [self configureData:@[]];
    
    //这句话必须要,否则拖动到两端会出现白屏
//    self.automaticallyAdjustsScrollViewInsets = NO;
    //
    self.currentDrawQuotaName = self.quotaNameArr[4];
    
    //监测旋转:用于适配横竖屏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
    //socket请求
//    [self initWebScoket];
    
    
    //soclet数据暂时用假数据替代
//    self.timer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(creatFakeSocketData) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    //止盈止损线
//    [self.assenblyView updateStopHoldLineWithStopProfitPrice:0.7646 stopLossPrice:0.7620];
//    [self.assenblyView hideStopHoldLine];
    //止盈止损线+委托价格线
//    [self.assenblyView updateStopHoldLineWithStopProfitPrice:0.7646 stopLossPrice:0.7620 delegatePrice:0.7630];
//    [self.assenblyView hideAllReferenceLine];
}

- (void)timeMargin{
    NSLog(@"111111");
}

#pragma mark - action
- (void)collectTouch{
    
}

- (void)shareTouch{
    
}

#pragma mark - 创建socket
- (void)initWebScoket{
    
    self.webSocket.delegate = nil;
    
    [self.webSocket close];
    
    self.webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",WEBSOCKET_URL,SOCKET_COIN_KCLINE]]]];
    
    self.webSocket.delegate = self;
    
    [self.webSocket open];
}

#pragma mark - SRWebSocketDelegate
- (void)webSocketDidOpen:(SRWebSocket *)webSocket;{
    
    NSLog(@"Websocket Connected success");
    self.currentInd = @"15m";
    [self sendIndData];
}

- (void)sendIndData{
    NSDictionary *dic = @{@"exchangeCode": self.coinModel.exchangeCode, @"coinCode": self.coinModel.coinCode, @"cycle": self.currentInd, @"size": @"100"};
    [self sendJsonData:dic];
}

//发送json包
- (void)sendJsonData:(NSDictionary *)dic{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [self.webSocket send:jsonString];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;{
    
    NSLog(@":( Websocket Failed With Error %@", error);
    if (error.code == 57) {
        //断网
        
    }else{
        
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;{
    
//    NSLog(@"Received \"%@\"", message);
    NSData *jsonData = [message dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:jsonData
                             
                                                            options:NSJSONReadingMutableContainers
                             
                                                              error:&err];
    
   
    if ([[dicData jk_numberForKey:@"errcode"] integerValue] == 0) {
        //首屏
        NSArray *klines = [[[dicData jk_arrayForKey:@"result"] reverseObjectEnumerator] allObjects];
        if (klines.count == 0) {
            return;
        }
        [self configureData:klines];
    }
//    if ([[dicData objectForKey:@"event"] isEqualToString:@"kline"]) {
//
//
//        //逐条
//        if (self.drawDone && [self.channel isEqualToString:[dicData objectForKey:@"channel"]] &&  [dicData objectForKey:@"kline"] != nil) {
//
//            NSLog(@"kline === %@", [dicData objectForKey:@"kline"]);
//            NSDictionary *d = [dicData objectForKey:@"kline"];
//            //必须在主线程执行
//            dispatch_async(dispatch_get_main_queue(), ^{
//
//                KlineModel *m = [[KlineModel alloc] init];
//                m.timestamp = [[d objectForKey:@"dateTime"] integerValue];
//                m.closePrice = [[d objectForKey:@"close"] doubleValue];
//                m.degree = [[d objectForKey:@"degree"] doubleValue];
//                m.openPrice = [[d objectForKey:@"open"] doubleValue];
//                m.highestPrice = [[d objectForKey:@"high"] doubleValue];
//                m.lowestPrice = [[d objectForKey:@"low"] doubleValue];
//                m.volumn = [NSNumber numberWithDouble:[[d objectForKey:@"vol24"] doubleValue]];
//                m.usdPrice = [[d objectForKey:@"usdPrice"] doubleValue];
//
//                self.newklineModel = m;
//                self.headerView.model = m;
//                self.landScapePriceLabel.text = [NSString stringWithFormat:@"￥%.2f",m.closePrice];
//
//                //socket数据处理
//                [[ZXSocketDataReformer sharedInstance] bulidNewKlineModelWithNewPrice:m timestamp:m.timestamp volumn:m.volumn dataArray:self.dataArray isFakeData:NO];
//            });
//        }
    
//        //首屏
//        if ([dicData objectForKey:@"klines"] != nil) {
//            NSArray *klines = [[[dicData objectForKey:@"klines"] reverseObjectEnumerator] allObjects];
////            NSLog(@"revice === %@",klines);
//            if (klines.count == 0) {
//                return;
//            }
//            [self configureData:klines];
//        }
//    }
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;{
    
    NSLog(@"WebSocket closed");
    
    webSocket = nil;
}

#pragma mark - 屏幕旋转通知事件
- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- (void)statusBarOrientationChange:(NSNotification *)notification
{
    
    if (self.orientation == UIDeviceOrientationPortrait || self.orientation == UIDeviceOrientationPortraitUpsideDown) {
        
        //翻转为竖屏时
        [self updateConstrainsForPortrait];
        self.navigationBar.hidden = NO;
    }else if (self.orientation==UIDeviceOrientationLandscapeLeft || self.orientation == UIDeviceOrientationLandscapeRight) {
        
        [self updateConstrsinsForLandscape];
        self.navigationBar.hidden = YES;
    }
}
- (void)updateConstrainsForPortrait
{
    self.headerView.hidden = NO;
    
    [self.indView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerView.mas_bottom).offset(MidPadding);
        make.left.right.mas_equalTo(self.view);
        make.height.equalTo(@(CYCHEIGHT));
    }];
    [self.indView adjustSubviews:self.orientation];
    
    [self.assenblyView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.indView.mas_bottom);
        make.width.mas_equalTo(TotalWidth);
        make.height.mas_equalTo(TotalHeight);
    }];
    
    [self.moreCycView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.indView.mas_bottom);
        make.left.right.height.mas_equalTo(self.indView);
    }];
    
    [self.quotaView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.moreCycView.mas_top);
        make.left.right.height.mas_equalTo(self.moreCycView);
    }];
}
- (void)updateConstrsinsForLandscape
{
    //翻转为横屏时
    self.headerView.hidden = YES;
    
    [self.landScapePriceView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(ZX_IS_IPHONE_X ? SafeAreaTopMargin : 0);
        make.top.mas_equalTo(self.view.mas_top).offset(HAdaptY(50) - HAdaptY(36));
        make.height.equalTo(@(HAdaptY(36)));
    }];
    
    [self.landScapeCurrenyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.landScapePriceView.mas_left).offset(HAdaptX(20));
        make.centerY.mas_equalTo(self.landScapePriceView.mas_centerY);
    }];
    
    [self.landScapePriceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.landScapeCurrenyLabel.mas_right).offset(HAdaptX(10));
        make.centerY.mas_equalTo(self.landScapeCurrenyLabel);
    }];
    
    [self.indView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(HAdaptY(50) - HAdaptY(36));
        make.right.mas_equalTo(self.view.mas_right).offset(ZX_IS_IPHONE_X ? -SafeAreaBottomMargin : 0);
        make.height.equalTo(@(HAdaptY(36)));
        make.width.equalTo(@(ZX_IS_IPHONE_X ? MAINSCREEN_HEIGHT : MAINSCREEN_HEIGHT));
    }];
    [self.indView adjustSubviews:self.orientation];
    
    [self.moreCycView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.indView.mas_bottom);
        make.height.mas_equalTo(self.indView);
        make.left.mas_equalTo(self.view.mas_left).offset(ZX_IS_IPHONE_X ? SafeAreaTopMargin : 0);
        make.right.mas_equalTo(self.view.mas_right).offset(ZX_IS_IPHONE_X ? -SafeAreaBottomMargin : 0);
    }];
    
    [self.quotaView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.moreCycView.mas_top);
        make.left.right.height.mas_equalTo(self.moreCycView);
    }];
    
    [self.assenblyView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(HAdaptY(50));
        make.width.mas_equalTo(TotalWidth);
        make.height.mas_equalTo(TotalHeight);
    }];
}

- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

#pragma mark - Private Methods
- (void)createUI
{
    WeakSelf(self);
    [self.view addSubview:self.mainScrollView];
    
    [self.mainScrollView addSubview:self.headerView];
    self.headerView.coinRank = self.coinModel;
    
    //nav
    [self setNavView];
    
    [self.mainScrollView addSubview:self.indView];
    self.indView.indBlock = ^(KMenuType tag, BOOL sel) {
        switch (tag) {
            case KMenuKLineOrTimeType:
                [weakself drawCandleAreaWithCode:!sel];
                break;
            case KMenuInd1Type:
                break;
            case KMenuInd2Type:
                break;
            case KMenuInd3Type:
                break;
            case KMenuCycleType:
                weakself.moreCycView.hidden = NO;
                break;
            default:
                break;
        }
    };
    
    //需要加载在最上层，为了旋转的时候直接覆盖其他控件
    [self.mainScrollView addSubview:self.assenblyView];
    
    //更多分时
    [self.mainScrollView addSubview:self.moreCycView];
    self.moreCycView.changeCycBlock = ^(NSString *parameter, NSString *cyc) {
        [weakself.indView reloadSelStr:parameter];
        weakself.moreCycView.hidden = YES;
        weakself.currentInd = cyc;
        [weakself sendIndData];
    };
    
    //子view
    [self addChildViewController:self.coinMarketVC];
    [self addChildViewController:self.coinMoneyVC];
    [self addChildViewController:self.coinIntroduceVC];
    self.coinMarketVC.view.frame = CGRectMake(0, TOPVIEWHEIGHT, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT);
    [self.mainScrollView addSubview:self.coinMarketVC.view];
    
    self.coinMoneyVC.view.frame = CGRectMake(0, self.coinMarketVC.view.easy_y, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT);
    self.coinMoneyVC.view.hidden = YES;
    [self.mainScrollView addSubview:self.coinMoneyVC.view];
    
    self.coinIntroduceVC.view.frame = CGRectMake(0, self.coinMarketVC.view.easy_y, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT);
    self.coinIntroduceVC.view.hidden = YES;
    [self.mainScrollView addSubview:self.coinIntroduceVC.view];
    
    //menu
    [self.mainScrollView addSubview:self.menuView];
    self.menuView.touchBlock = ^(NSInteger tag) {
        switch (tag) {
            case 0:
                weakself.coinMoneyVC.view.hidden = YES;
                weakself.coinIntroduceVC.view.hidden = YES;
                weakself.coinMarketVC.view.hidden = NO;
                weakself.mainScrollView.contentSize = CGSizeMake(MAINSCREEN_WIDTH, TOPVIEWHEIGHT + AdaptY(50) * 10);

                break;
            case 1:
                weakself.coinMarketVC.view.hidden = YES;
                weakself.coinIntroduceVC.view.hidden = YES;
                weakself.coinMoneyVC.view.hidden = NO;
                weakself.mainScrollView.contentSize = CGSizeMake(MAINSCREEN_WIDTH, TOPVIEWHEIGHT + MAINSCREEN_HEIGHT);

                break;
            case 2:
                weakself.coinMoneyVC.view.hidden = YES;
                weakself.coinMarketVC.view.hidden = YES;
                weakself.coinIntroduceVC.view.hidden = NO;
                weakself.mainScrollView.contentSize = CGSizeMake(MAINSCREEN_WIDTH, TOPVIEWHEIGHT + (MAINSCREEN_HEIGHT / 2));

                break;
        }
    };
    
    //横屏price
    [self.view addSubview:self.landScapePriceView];
    [self.landScapePriceView addSubview:self.landScapeCurrenyLabel];
//    self.landScapeCurrenyLabel.text = [self.currencyMarket.ticker subStringFrom:@":"];
    [self.landScapePriceView addSubview:self.landScapePriceLabel];
    
//    self.quotaView.mainSelectBlock = ^(NSString *str){
//        NSLog(@"主图 == %@",str);
//        if ([str isEqualToString:@"MA"]) {
//            weakself.assenblyView.isDrawMA = YES;
//            [weakself.assenblyView reDrawMAWithMA1Day:5 MA2:10 MA3:20];
//        }
//    };
//    self.quotaView.viceSelectBlock = ^(NSString *str){
//        NSLog(@"副图 == %@",str);
//    };
//    self.quotaView.mainCancelBlock = ^(){
//        weakself.assenblyView.isDrawMA = NO;
////        [weakself drawCandleAreaWithCode:weakself.currentInd];
//        [weakself.assenblyView reDrawMAWithMA1Day:5 MA2:10 MA3:20];
//    };
//    self.quotaView.viceCancelBlock = ^(){
//
//    };
    
//    [self.view addSubview:self.landScapeView];
//    self.landScapeView.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT);
}

- (void)setNavView{
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake((MAINSCREEN_WIDTH - 180) / 2, 0, 180, NavbarH - StatusBarH)];
    navView.backgroundColor = WhiteTextColor;
    [self.navigationBar addSubview:navView];
    
//    UIBarButtonItem *collectItem = [[UIBarButtonItem alloc] initWithImage:ImageName(@"collect") style:UIBarButtonItemStylePlain target:self action:@selector(collectTouch)];
//
//    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithImage:ImageName(@"share") style:UIBarButtonItemStylePlain target:self action:@selector(shareTouch)];
//    self.navigationItem.rightBarButtonItems = @[shareItem, collectItem];
    
    BaseLabel *coinLabel = [SEFactory labelWithText:[NSString stringWithFormat:@"%@(%@)",LocalizedString(self.coinModel.cnName),LocalizedString(self.coinModel.coinCode)] frame:CGRectZero textFont:Font(13) textColor:MainBlackColor textAlignment:NSTextAlignmentCenter];
    [navView addSubview:coinLabel];
    [coinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(navView.mas_centerX);
        make.bottom.mas_equalTo(navView.mas_centerY);
    }];
    
    BaseLabel *tickLabel = [SEFactory labelWithText:[NSString stringWithFormat:@"%@ %@",LocalizedString(@"全网"),[DateManager dateWithTimeIntervalSince1970:self.coinModel.lastUpdate format:@"HH:mm:ss"]] frame:CGRectZero textFont:Font(11) textColor:LightTextGrayColor textAlignment:NSTextAlignmentCenter];
    [navView addSubview:tickLabel];
    [tickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(navView.mas_centerX);
        make.top.mas_equalTo(navView.mas_centerY).offset(3);
    }];

    BaseImageView *iconView = [[BaseImageView alloc] init];
    [iconView sd_setImageWithURL:[NSURL URLWithString:self.coinModel.iconUrl] placeholderImage:ImageName(@"coin_place")];
    iconView.backgroundColor = BackGroundColor;
    ViewRadius(iconView, AdaptX(10));
    [navView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(tickLabel.mas_left).offset(-MidPadding);
        make.centerY.mas_equalTo(navView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(AdaptX(20), AdaptX(20)));
    }];
    
//    BaseButton *closeBtn = [SEFactory buttonWithImage:ImageName(@"nav_back_black")];
//    [navView addSubview:closeBtn];
//    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(navView.mas_top).offset(StatusBarH);
//        make.size.mas_equalTo(CGSizeMake(NavbarH - StatusBarH, NavbarH - StatusBarH));
//    }];
//
//    BaseButton *shareBtn = [SEFactory buttonWithImage:ImageName(@"share")];
//    [navView addSubview:shareBtn];
//    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(navView.mas_right).offset(-MidPadding);
//        make.width.height.mas_equalTo(closeBtn);
//        make.centerY.mas_equalTo(closeBtn.mas_centerY);
//    }];
//
//    BaseButton *collectBtn = [SEFactory buttonWithImage:ImageName(@"collect")];
//    [navView addSubview:collectBtn];
//    [collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.mas_equalTo(closeBtn);
//        make.centerY.mas_equalTo(shareBtn.mas_centerY);
//        make.right.mas_equalTo(shareBtn.mas_left).offset(-MinPadding);
//    }];
}

- (void)addConstrains
{
    if (self.orientation == UIDeviceOrientationPortrait || self.orientation == UIDeviceOrientationPortraitUpsideDown) {
        //初始为竖屏
        self.navigationBar.hidden = NO;
        
        self.headerView.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, HEADERHEIGHT);
        self.indView.frame = CGRectMake(0, HEADERHEIGHT + MidPadding, MAINSCREEN_WIDTH, CYCHEIGHT);
        self.assenblyView.frame = CGRectMake(0, self.indView.easy_bottom, TotalWidth, TotalHeight);
        self.menuView.frame = CGRectMake(0, self.assenblyView.easy_bottom + MidPadding, MAINSCREEN_WIDTH, MENUHEIGHT);
        
//        [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.left.right.mas_equalTo(self.view);
//            make.top.mas_equalTo(self.mainScrollView.mas_top);
//            make.height.equalTo(@(HEADERHEIGHT));
//        }];
//        
//        [self.indView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.headerView.mas_bottom).offset(MidPadding);
//            make.left.right.mas_equalTo(self.mainScrollView);
//            make.height.equalTo(@(CYCHEIGHT));
//        }];
//        
//        [self.assenblyView mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.left.mas_equalTo(self.view);
//            make.width.mas_equalTo(TotalWidth);
//            make.height.mas_equalTo(TotalHeight);
//            make.top.mas_equalTo(self.indView.mas_bottom);
//        }];
//    
//        [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.assenblyView.mas_bottom).offset(MidPadding);
//            make.left.right.mas_equalTo(self.indView);
//            make.height.equalTo(@(MENUHEIGHT));
//        }];
        
        [self.moreCycView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.indView.mas_bottom);
            make.left.right.mas_equalTo(self.indView);
            make.height.equalTo(@(MORECYCHEIGHT));
        }];
        
        [self.quotaView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.moreCycView.mas_top);
            make.left.right.height.mas_equalTo(self.moreCycView);
        }];
        
    }else if (self.orientation==UIDeviceOrientationLandscapeLeft || self.orientation == UIDeviceOrientationLandscapeRight) {
        //初始为横屏
        self.navigationBar.hidden = YES;
        
        [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.view);
            make.top.mas_equalTo(self.view.mas_top).offset(NavbarH);
            make.height.equalTo(@(AdaptY(0)));
        }];
        
        [self.assenblyView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(self.view);
            make.left.mas_equalTo(self.view);
            make.width.mas_equalTo(TotalWidth);
            make.height.mas_equalTo(TotalHeight);
        }];
    }
}

#pragma mark - scrollView delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.mainScrollView) {
        //切换导航条
        CGFloat offsetY = scrollView.contentOffset.y;
        
        //悬停
        if (offsetY < TOPVIEWHEIGHT - MENUHEIGHT  && offsetY >0) {
            self.menuView.frame = CGRectMake(0, TOPVIEWHEIGHT - MENUHEIGHT, MAINSCREEN_WIDTH, MENUHEIGHT);
            [self.menuView stayShowShadow:NO];
            [self.mainScrollView addSubview:self.menuView];
        }else if(offsetY >= TOPVIEWHEIGHT - MENUHEIGHT) {
            self.menuView.frame = CGRectMake(0, NavbarH, MAINSCREEN_WIDTH, MENUHEIGHT);
            [self.menuView stayShowShadow:YES];
            [self.view addSubview:self.menuView];
        }
    }
}

#pragma mark - data
- (void)configureData:(NSArray *)kDataArr
{
    if (kDataArr.count == 0) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"kData" ofType:@"plist"];
        kDataArr = [NSArray arrayWithContentsOfFile:path];
        
//        NSMutableArray *tempArray = [NSMutableArray array];
//        for (int i = 0; i<100
//             ; i++) {
//            [tempArray addObject:kDataArr[i]];
//        }
    }
    
    //==精度计算
    NSInteger precision = [self calculatePrecisionWithOriginalDataArray:kDataArr];
    
    //将请求到的数据数组传递过去，并且精度也是需要你自己传;
    /*
     数组中数据格式:@[@"时间戳,收盘价,开盘价,最高价,最低价,成交量",
     @"时间戳,收盘价,开盘价,最高价,最低价,成交量",
     @"时间戳,收盘价,开盘价,最高价,最低价,成交量",
     @"...",
     @"..."];
     */
    /*如果的数据格式和此demo中不同，那么你需要点进去看看，并且修改响应的取值为你的数据格式;
     修改数据格式→  ↓↓↓↓↓↓↓点它↓↓↓↓↓↓↓↓↓  ←
     */
    //===数据处理
    NSArray *transformedDataArray =  [[ZXDataReformer sharedInstance] transformDataWithOriginalDataArray:kDataArr currentRequestType:self.currentInd];
    
    //绘制header
    KlineModel *headerData = [transformedDataArray lastObject];
    self.headerView.model = headerData;
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:transformedDataArray];
    
    
    //====绘制k线图
    [self.assenblyView drawHistoryCandleWithDataArr:self.dataArray precision:(int)precision stackName:@"股票名" needDrawQuota:self.currentDrawQuotaName];
    
    //监听首屏绘制结束
    self.drawDone = YES;
    
    //如若有socket实时绘制的需求，需要实现下面的方法
    //socket
    //定时器不再沿用
    [ZXSocketDataReformer sharedInstance].delegate = self;
    
}
#pragma mark -  计算精度
- (NSInteger)calculatePrecisionWithOriginalDataArray:(NSArray *)dataArray
{
    NSDictionary *dic = dataArray.lastObject;
//    //取的最高值
    NSInteger maxPrecision = [self calculatePrecisionWithPrice:[NSString stringWithFormat:@"%@",[dic objectForKey:@"hign"]]];
    
//    NSArray *strArr = [dataArray.lastObject componentsSeparatedByString:@","];
//    //取的最高值
//    NSInteger maxPrecision = [self calculatePrecisionWithPrice:strArr[3]];
    
    return maxPrecision;
}
- (NSInteger)calculatePrecisionWithPrice:(NSString *)price
{
    //计算精度
    NSInteger dig = 0;
    if ([price containsString:@"."]) {
        NSArray *com = [price componentsSeparatedByString:@"."];
        dig = ((NSString *)com.lastObject).length;
    }
    return dig;
}
#pragma mark - AssemblyViewDelegate

//底部touch
//- (void)tapActionActOnQuotaArea
//{
//    if (self.topChartType==ZXTopChartTypeTimeLine) {
//        return;
//    }
//    //这里可以进行quota图的切换
//    NSInteger index = [self.quotaNameArr indexOfObject:self.currentDrawQuotaName];
//    if (index<self.quotaNameArr.count-1) {
//
//        self.currentDrawQuotaName = self.quotaNameArr[index+1];
//    }else{
//        self.currentDrawQuotaName = self.quotaNameArr[0];
//    }
//    [self drawQuotaWithCurrentDrawQuotaName:self.currentDrawQuotaName];
//}

//顶部视图
//- (void)tapActionActOnCandleArea
//{
//    if (self.topChartType==ZXTopChartTypeBrokenLine) {
//
//        [self.assenblyView switchTopChartWithTopChartType:ZXTopChartTypeCandle];
//        self.topChartType = ZXTopChartTypeCandle;
//    }
////    else if (self.topChartType==ZXTopChartTypeCandle)
////    {
////        [self.assenblyView switchTopChartWithTopChartType:ZXTopChartTypeTimeLine];
////        [self drawQuotaWithCurrentDrawQuotaName:@"VOL"];
////        self.currentDrawQuotaName = @"VOL";
////        self.topChartType = ZXTopChartTypeTimeLine;
////    }
//    else if (self.topChartType==ZXTopChartTypeCandle)
//    {
//        [self.assenblyView switchTopChartWithTopChartType:ZXTopChartTypeBrokenLine];
//        self.topChartType = ZXTopChartTypeBrokenLine;
//    }
//}
#pragma mark - 画指标
//画蜡烛
- (void)drawCandleAreaWithCode:(BOOL)time{
    if (time) {
        [self.assenblyView switchTopChartWithTopChartType:ZXTopChartTypeBrokenLine];
        self.topChartType = ZXTopChartTypeBrokenLine;
    }else{
        [self.assenblyView switchTopChartWithTopChartType:ZXTopChartTypeCandle];
        self.topChartType = ZXTopChartTypeCandle;
    }
}

//在返回的数据里面。可以调用预置的指标接口绘制指标，也可以根据返回的数据自己计算数据，然后调用绘制接口进行绘制
- (void)drawQuotaWithCurrentDrawQuotaName:(NSString *)currentDrawQuotaName
{
    
    if ([currentDrawQuotaName isEqualToString:self.quotaNameArr[0]])
    {
        //macd绘制
        [self.assenblyView drawPresetQuotaWithQuotaName:PresetQuotaNameWithMACD];
    }else if ([currentDrawQuotaName isEqualToString:self.quotaNameArr[1]])
    {
        
        //KDJ绘制
        [self.assenblyView drawPresetQuotaWithQuotaName:PresetQuotaNameWithKDJ];
    }else if ([currentDrawQuotaName isEqualToString:self.quotaNameArr[2]])
    {
        
        //BOLL绘制
        [self.assenblyView drawPresetQuotaWithQuotaName:PresetQuotaNameWithBOLL];
    }else if ([currentDrawQuotaName isEqualToString:self.quotaNameArr[3]])
    {
        
        //RSI绘制
        [self.assenblyView drawPresetQuotaWithQuotaName:PresetQuotaNameWithRSI];
    }else if ([currentDrawQuotaName isEqualToString:self.quotaNameArr[4]])
    {
        
        //Vol绘制
        [self.assenblyView drawPresetQuotaWithQuotaName:PresetQuotaNameWithVOL];
    }
}

//socket 假数据
- (void)creatFakeSocketData
{
    KlineModel *model = self.dataArray[self.dataArray.count-2];
    int32_t highestPrice = model.highestPrice*100000;
    int32_t lowestPrice = model.lowestPrice*100000;
    CGFloat newPrice = (arc4random_uniform(highestPrice-lowestPrice)+lowestPrice)/100000.0;
    NSLog(@"%f",newPrice);
    NSInteger volumn = arc4random_uniform(100);
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval timestamp = [date timeIntervalSince1970];
    //socket数据处理
//    [[ZXSocketDataReformer sharedInstance] bulidNewKlineModelWithNewPrice:newPrice timestamp:timestamp volumn:@(volumn) dataArray:self.dataArray isFakeData:NO];
}
#pragma mark - ZXSocketDataReformerDelegate
- (void)bulidSuccessWithNewKlineModel:(KlineModel *)newKlineModel
{
    //维护控制器数据源
    if (newKlineModel.isNew) {
        
        [self.dataArray addObject:newKlineModel];
        [[ZXQuotaDataReformer sharedInstance] handleQuotaDataWithDataArr:self.dataArray model:newKlineModel index:self.dataArray.count-1];
        [self.dataArray replaceObjectAtIndex:self.dataArray.count-1 withObject:newKlineModel];
        
    }else{
        [self.dataArray replaceObjectAtIndex:self.dataArray.count-1 withObject:newKlineModel];
        
        [[ZXQuotaDataReformer alloc] handleQuotaDataWithDataArr:self.dataArray model:newKlineModel index:self.dataArray.count-1];
        
        [self.dataArray replaceObjectAtIndex:self.dataArray.count-1 withObject:newKlineModel];
    }
    //绘制最后一个蜡烛
    [self.assenblyView drawLastKlineWithNewKlineModel:newKlineModel];
}


#pragma mark - Event Response



#pragma mark - CustomDelegate



#pragma mark - Getters & Setters
- (ZXAssemblyView *)assenblyView
{
    if (!_assenblyView) {
        //仅仅只有k线的初始化方法
//        _assenblyView = [[ZXAssemblyView alloc] initWithDrawJustKline:YES];
        //带指标的初始化
        _assenblyView = [[ZXAssemblyView alloc] init];
        _assenblyView.delegate = self;
        _assenblyView.isDrawMA = YES;
    }
    return _assenblyView;
}

- (UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavbarH, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT - NavbarH)];
        _mainScrollView.delegate = self;
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.contentSize = CGSizeMake(MAINSCREEN_WIDTH, TOPVIEWHEIGHT + MAINSCREEN_HEIGHT);
    }
    return _mainScrollView;
}

- (CoinMarketForExchangeViewController *)coinMarketVC{
    if (!_coinMarketVC) {
        _coinMarketVC = [[CoinMarketForExchangeViewController alloc] init];
    }
    return _coinMarketVC;
}

- (CoinMoneyViewController *)coinMoneyVC{
    if (!_coinMoneyVC) {
        _coinMoneyVC = [[CoinMoneyViewController alloc] init];
    }
    return _coinMoneyVC;
}

- (CoinIntroduceViewController *)coinIntroduceVC{
    if (!_coinIntroduceVC) {
        _coinIntroduceVC = [[CoinIntroduceViewController alloc] init];
    }
    return _coinIntroduceVC;
}

- (KLineDetailHeader *)headerView{
    if (!_headerView) {
        _headerView = [[KLineDetailHeader alloc] init];
    }
    return _headerView;
}

- (KlineIndView *)indView{
    if (!_indView) {
        _indView = [[KlineIndView alloc] init];
    }
    return _indView;
}

- (KlineMoreCycView *)moreCycView{
    if (!_moreCycView) {
        _moreCycView = [[KlineMoreCycView alloc] init];
        _moreCycView.hidden = YES;
    }
    return _moreCycView;
}

- (KlineMenuView *)menuView{
    if (!_menuView) {
        _menuView = [[KlineMenuView alloc] initWithTitles:@[LocalizedString(@"行情"),LocalizedString(@"资金"),LocalizedString(@"简况")]];
    }
    return _menuView;
}

//- (KlineMoreIndView *)quotaView{
//    if (!_quotaView) {
//        _quotaView = [[KlineMoreIndView alloc] init];
//        _quotaView.hidden = YES;
//    }
//    return _quotaView;
//}

- (UIView *)landScapePriceView{
    if (!_landScapePriceView) {
        _landScapePriceView = [[UIView alloc] init];
        _landScapePriceView.hidden = YES;
    }
    return _landScapePriceView;
}

- (BaseLabel *)landScapeCurrenyLabel{
    if (!_landScapeCurrenyLabel) {
        _landScapeCurrenyLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(14) textColor:WhiteTextColor textAlignment:NSTextAlignmentLeft];
    }
    return _landScapeCurrenyLabel;
}

- (BaseLabel *)landScapePriceLabel{
    if (!_landScapePriceLabel) {
        _landScapePriceLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(20) textColor:WhiteTextColor textAlignment:NSTextAlignmentLeft];
    }
    return _landScapePriceLabel;
}

//- (KlineIndView *)quotaView{
//    if (!_quotaView) {
//        _quotaView = [[KlineIndView alloc] initWithType:KMenuQuataType];
//        _quotaView.hidden = YES;
//    }
//    return _quotaView;
//}

- (UIInterfaceOrientation)orientation
{
    return [[UIApplication sharedApplication] statusBarOrientation];
}
- (NSArray *)quotaNameArr
{
    if (!_quotaNameArr) {
        _quotaNameArr = @[@"MACD",@"KDJ",@"BOLL",@"RSI",@"VOL"];
    }
    return _quotaNameArr;
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
