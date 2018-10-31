//
//  OptionalRecommendCell.m
//  Hunt
//
//  Created by 杨明 on 2018/7/30.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "OptionalRecommendCell.h"

@interface OptionalRecommendCell()

/* currency */
@property (nonatomic, strong) BaseLabel *currencyLabel;
/* exchange */
@property (nonatomic, strong) BaseLabel *exchangeLabel;
/* summary */
@property (nonatomic, strong) BaseLabel *summaryLabel;
/* sel */
@property (nonatomic, strong) BaseImageView *selView;

@end

@implementation OptionalRecommendCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        
        self.contentView.backgroundColor = WhiteTextColor;
        ViewShadow(self.contentView, CGSizeMake(3, 3), LightGrayColor, 4, 3, AdaptX(3));
        [self createUI];
    }
    return self;
}

#pragma mark - UI
- (void)createUI{
    
    [self.contentView addSubview:self.selView];
    [self.selView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(AdaptX(14), AdaptX(14)));
    }];

    [self.contentView addSubview:self.summaryLabel];
    [self.summaryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(self.contentView);
        make.height.equalTo(@(AdaptY(25)));
    }];
    
    [self.contentView addSubview:self.exchangeLabel];
    [self.exchangeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.summaryLabel.mas_top).offset(-AdaptY(10));
        make.left.right.mas_equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.currencyLabel];
    [self.currencyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.exchangeLabel.mas_top).offset(-AdaptY(4));
        make.left.right.mas_equalTo(self.exchangeLabel);
    }];
   
}

#pragma mark - init
- (BaseLabel *)currencyLabel{
    if (!_currencyLabel) {
        _currencyLabel = [SEFactory labelWithText:@"BTC USDT" frame:CGRectZero textFont:Font(14) textColor:TextDarkColor textAlignment:NSTextAlignmentCenter];
    }
    return _currencyLabel;
}

- (BaseLabel *)exchangeLabel{
    if (!_exchangeLabel) {
        _exchangeLabel = [SEFactory labelWithText:@"火币Pro,比特币" frame:CGRectZero textFont:Font(10) textColor:LightTextGrayColor textAlignment:NSTextAlignmentCenter];
    }
    return _exchangeLabel;
}

- (BaseLabel *)summaryLabel{
    if (!_summaryLabel) {
        _summaryLabel = [SEFactory labelWithText:@"热门交易对" frame:CGRectZero textFont:Font(10) textColor:WhiteTextColor textAlignment:NSTextAlignmentCenter];
        [_summaryLabel py_addToThemeColorPool:@"backgroundColor"];
        ViewRadius(_summaryLabel, AdaptX(3));
    }
    return _summaryLabel;
}

- (BaseImageView *)selView{
    if (!_selView) {
        _selView = [[BaseImageView alloc] init];
        _selView.image = [ThemeManager imageForKey:@"optional_sel_on"];
    }
    return _selView;
}

@end
