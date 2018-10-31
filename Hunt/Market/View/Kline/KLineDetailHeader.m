//
//  KLineDetailHeader.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/19.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "KLineDetailHeader.h"
#import "KlineIndView.h"
#import "SEUserDefaults.h"
#import "NSString+JLAdd.h"

@interface KLineDetailHeader()

/* price */
@property (nonatomic, strong) BaseLabel *priceLabel;
/* degreePirce */
@property (nonatomic, strong) BaseLabel *degreePirceLabel;
/* degree */
@property (nonatomic, strong) BaseLabel *degreeLabel;
/* high */
@property (nonatomic, strong) BaseLabel *highLabel;
/* low */
@property (nonatomic, strong) BaseLabel *lowLabel;
/* total */
@property (nonatomic, strong) BaseLabel *totalLabel;
/* market */
@property (nonatomic, strong) BaseLabel *marketLabel;
/* change */
@property (nonatomic, strong) BaseLabel *changeLabel;
/* num */
@property (nonatomic, strong) BaseLabel *numLabel;
/* lastPrice */
@property (nonatomic, assign) CGFloat lastPrice;

@end

@implementation KLineDetailHeader

- (instancetype)init{
    if (self == [super init]) {
        
        self.backgroundColor = WhiteTextColor;
        [self createUI];
    }
    return self;
}

- (void)setCoinRank:(CoinRanksModel *)coinRank{
    _coinRank = coinRank;
    
    self.priceLabel.text = [NSString numberFormatterToAllRMB:coinRank.price];
    self.degreeLabel.text = [NSString stringWithFormat:@"%.2f%%(今日)",coinRank.degree];
    self.degreePirceLabel.text = [NSString numberFormatterToAllRMB:coinRank.change];
    self.totalLabel.text = [NSString numberFormatterToRMB:coinRank.turnover];
    self.marketLabel.text = [NSString numberFormatterToRMB:coinRank.marketCap];
    self.highLabel.text = [NSString numberFormatterToRMB:coinRank.high];
    self.lowLabel.text = [NSString numberFormatterToRMB:coinRank.low];
    self.changeLabel.text = [NSString stringWithFormat:@"%.2f%%",coinRank.turnoverRate];
    self.numLabel.text = [NSString stringWithFormat:@"%ld",coinRank.rankNum];
}

//- (void)setModel:(KlineModel *)model{
//    _model = model;
//
//    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
//    formatter.numberStyle = kCFNumberFormatterCurrencyStyle;
//
//    //涨跌颜色
//    if (self.lastPrice < model.closePrice) {
//        self.closeLabel.textColor = [[SEUserDefaults shareInstance] getRiseOrFallColor:RoseType];
//    }else{
//        self.closeLabel.textColor = [[SEUserDefaults shareInstance] getRiseOrFallColor:FallType];
//    }
//    self.degreeLabel.textColor = self.closeLabel.textColor;
//    self.lastPrice = model.closePrice;
//    self.closeLabel.text = [formatter stringFromNumber:[NSNumber numberWithFloat:model.closePrice]];
//    self.dollarLabel.text = [NSString stringWithFormat:@"≈$%.2f",model.usdPrice];;
//    if (model.degree > 0) {
//        self.degreeLabel.text = [NSString stringWithFormat:@"+%.2f%%",model.degree];
//    }else{
//        self.degreeLabel.text = [NSString stringWithFormat:@"%.2f%%",model.degree];
//    }
//
//    self.highLabel.text = [NSString stringWithFormat:@"%.2f",model.highestPrice];
//    self.lowLabel.text = [NSString stringWithFormat:@"%.2f",model.lowestPrice];
//    self.volLabel.text = [NSString stringWithFormat:@"%.2f万",[model.volumn doubleValue] / 10000];
//}

//- (void)adjustLayout{
//
//    [self.closeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.mas_left).offset(3 * MidPadding);
//        make.top.mas_equalTo(self.mas_top).offset(MidPadding);
//    }];
//
//    [self.degreeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.closeLabel.mas_right).offset(MidPadding);
//        make.bottom.mas_equalTo(self.closeLabel.mas_bottom).offset(-AdaptY(5));
//    }];
//
//    [self.dollarLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.closeLabel.mas_left);
//        make.top.mas_equalTo(self.closeLabel.mas_bottom).offset(MidPadding);
//    }];
//}

#pragma mark - UI
- (void)createUI{
    
    [self addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(MidPadding);
        make.top.mas_equalTo(self.mas_top).offset(AdaptY(15));
        make.width.mas_lessThanOrEqualTo(@(AdaptX(140)));
    }];
    
    [self addSubview:self.degreeLabel];
    [self.degreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.priceLabel.mas_left);
        make.top.mas_equalTo(self.priceLabel.mas_bottom).offset(MinPadding);
    }];
    
    [self addSubview:self.degreePirceLabel];
    [self.degreePirceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.priceLabel.mas_left);
        make.top.mas_equalTo(self.degreeLabel.mas_bottom).offset(AdaptY(3));
    }];
    
    [self setDataView];
}

- (void)setDataView{
    
    NSInteger row = 2;
    NSInteger low = 3;
    
    CGFloat width = (MAINSCREEN_WIDTH - AdaptX(160) - 2 * MidPadding) / 3;
    CGFloat height = (AdaptY(95) - AdaptY(20)) / 2;
    
    NSArray *titleArr = @[@[LocalizedString(@"流通市值"),LocalizedString(@"总额(24h)"),LocalizedString(@"最高(24h)")],@[LocalizedString(@"市值排名"),LocalizedString(@"换手(24h)"),LocalizedString(@"最低(24h)")]];

    
    for (int i = 0; i < row; i++) {
        for (int j = 0; j < low; j++) {
            
            UIView *contentView = [[UIView alloc] init];
            [self addSubview:contentView];
            [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.mas_right).offset(- MidPadding - width * j);
                make.top.mas_equalTo(self.mas_top).offset(MidPadding + height * i + MinPadding * i);
                make.size.mas_equalTo(CGSizeMake(width, height));
            }];
            
            BaseLabel *top = [SEFactory labelWithText:titleArr[i][j] frame:CGRectZero textFont:Font(10) textColor:LightTextGrayColor textAlignment:NSTextAlignmentLeft];
            [contentView addSubview:top];
            [top mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(contentView.mas_left);
                make.bottom.mas_equalTo(contentView.mas_centerY).offset(-AdaptY(3));
            }];
            
            BaseLabel *bottom = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(10) textColor:MainBlackColor textAlignment:NSTextAlignmentLeft];
            [contentView addSubview:bottom];
            [bottom mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(contentView.mas_centerY);
                make.left.mas_equalTo(top.mas_left).offset(3);
            }];
            
            switch (i) {
                case 0:
                    switch (j) {
                        case 0:
                            self.marketLabel = bottom;
                            break;
                        case 1:
                            self.totalLabel = bottom;
                            break;
                        case 2:
                            self.highLabel = bottom;
                            break;
                    }
                    break;
                case 1:
                    switch (j) {
                        case 0:
                            self.numLabel = bottom;
                            break;
                        case 1:
                            self.changeLabel = bottom;
                            break;
                        case 2:
                            self.lowLabel = bottom;
                            break;
                    }
                    break;
            }
        }
    }
}

#pragma mark - init
- (BaseLabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:[UIFont boldSystemFontOfSize:22] textColor:MainBlackColor textAlignment:NSTextAlignmentLeft];
    }
    return _priceLabel;
}

- (BaseLabel *)degreeLabel{
    if (!_degreeLabel) {
        _degreeLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(11) textColor:BackGreenColor textAlignment:NSTextAlignmentLeft];
    }
    return _degreeLabel;
}

- (BaseLabel *)degreePirceLabel{
    if (!_degreePirceLabel) {
        _degreePirceLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(11) textColor:BackGreenColor textAlignment:NSTextAlignmentLeft];
    }
    return _degreePirceLabel;
}

@end
