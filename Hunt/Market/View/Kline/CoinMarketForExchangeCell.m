//
//  CoinMarketForExchangeCell.m
//  Hunt
//
//  Created by 杨明 on 2018/8/3.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "CoinMarketForExchangeCell.h"

static NSString *cellId = @"coinMarketForExchangeCellId";

@interface CoinMarketForExchangeCell()

/* name */
@property (nonatomic, strong) BaseLabel *nameLabel;
/* degree */
@property (nonatomic, strong) BaseLabel *degreeLabel;
/* price */
@property (nonatomic, strong) BaseLabel *priceLabel;
/* market */
@property (nonatomic, strong) BaseLabel *marketLabel;
/* vol */
@property (nonatomic, strong) BaseLabel *volLabel;

@end

@implementation CoinMarketForExchangeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createUI];
    }
    return self;
}

- (instancetype)initCoinMarketForExchangeCell:(UITableView *)tableView{
    self = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!self) {
        self = [[CoinMarketForExchangeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

+ (instancetype)coinMarketForExchangeCell:(UITableView *)tableView{
    return [[CoinMarketForExchangeCell alloc] initCoinMarketForExchangeCell:tableView];
}

//- (void)setModel:(Currency *)model{
//    _model = model;
//
//    [self.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.png",IMAGE_SERVICE,model.currency_name]] placeholderImage:ImageName(@"coin_place")];
//    self.nameLabel.text = model.currency_name;
//}

#pragma mark - UI
- (void)createUI{
    
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(AdaptX(15));
        make.bottom.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    [self.contentView addSubview:self.volLabel];
    [self.volLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(AdaptY(3));
    }];
    
    [self.contentView addSubview:self.degreeLabel];
    [self.degreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-MidPadding);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(AdaptX(64), AdaptY(26)));
    }];
    
    [self.contentView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.degreeLabel.mas_left).offset(-MaxPadding);
        make.centerY.mas_equalTo(self.nameLabel.mas_centerY);
    }];
    
    [self.contentView addSubview:self.marketLabel];
    [self.marketLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.priceLabel.mas_right);
        make.top.mas_equalTo(self.volLabel.mas_top);
    }];
    
    self.nameLabel.text = @"58Coin BTC/USDT";
    self.volLabel.text = @"55.36万 BTC/306.91亿 USDT";
    self.priceLabel.text = @"≈￥55,644.36";
    self.marketLabel.text = @"9206.45";
    self.degreeLabel.text = @"-0.40%";
}

#pragma mark - init
- (BaseLabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(14) textColor:MainBlackColor textAlignment:NSTextAlignmentLeft];
    }
    return _nameLabel;
}

- (BaseLabel *)volLabel{
    if (!_volLabel) {
        _volLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(11) textColor:LightTextGrayColor textAlignment:NSTextAlignmentLeft];
    }
    return _volLabel;
}

- (BaseLabel *)degreeLabel{
    if (!_degreeLabel) {
        _degreeLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(13) textColor:BackGreenColor textAlignment:NSTextAlignmentCenter];
    }
    return _degreeLabel;
}

- (BaseLabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(13) textColor:MainBlackColor textAlignment:NSTextAlignmentRight];
    }
    return _priceLabel;
}

- (BaseLabel *)marketLabel{
    if (!_marketLabel) {
        _marketLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(11) textColor:LightTextGrayColor textAlignment:NSTextAlignmentRight];
    }
    return _marketLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
