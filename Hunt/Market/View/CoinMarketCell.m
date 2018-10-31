//
//  CoinMarketCell.m
//  Hunt
//
//  Created by 杨明 on 2018/8/2.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "CoinMarketCell.h"
#import "SEUserDefaults.h"
#import "NSString+JLAdd.h"

static NSString *cellId = @"coinMarketCellId";

@interface CoinMarketCell()

/* icon */
@property (nonatomic, strong) BaseImageView *iconView;
/* name */
@property (nonatomic, strong) BaseLabel *nameLabel;
/* china */
@property (nonatomic, strong) BaseLabel *chinaLabel;
/* degree */
@property (nonatomic, strong) BaseLabel *degreeLabel;
/* price */
@property (nonatomic, strong) BaseLabel *priceLabel;
/* vol */
@property (nonatomic, strong) BaseLabel *volLabel;
/* market */
@property (nonatomic, strong) BaseLabel *marketLabel;

@end

@implementation CoinMarketCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createUI];
    }
    return self;
}

- (instancetype)initCoinMarketCell:(UITableView *)tableView{
    self = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!self) {
        self = [[CoinMarketCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

+ (instancetype)coinMarketCell:(UITableView *)tableView{
    return [[CoinMarketCell alloc] initCoinMarketCell:tableView];
}

- (void)setModel:(CoinRanksModel *)model{
    _model = model;

    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:ImageName(@"coin_place")];
    self.nameLabel.text = model.coinCode;
    self.chinaLabel.text = model.cnName;
    self.priceLabel.text = [NSString stringWithFormat:@"%@",[NSString numberFormatterToAllRMB:model.price]];
    self.marketLabel.text = [NSString stringWithFormat:@"市值%@",[NSString numberFormatterToRMB:model.marketCap]];
    self.degreeLabel.text = [NSString stringWithFormat:@"%.2f%%",model.degree];
    self.degreeLabel.backgroundColor = model.degree >= 0 ? BackRedColor : BackGreenColor;
    self.volLabel.text = [NSString stringWithFormat:@"%@ %@/%@ CNY",[NSString numberFormatterToNum:model.volume],model.coinCode,[NSString numberFormatterToNum:model.turnover]];
}

#pragma mark - UI
- (void)createUI{
    
    [self.contentView addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(MaxPadding);
        make.top.mas_equalTo(self.contentView.mas_top).offset(MidPadding);
        make.size.mas_equalTo(CGSizeMake(AdaptX(20), AdaptX(20)));
    }];
    
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).offset(MidPadding);
        make.centerY.mas_equalTo(self.iconView.mas_centerY);
    }];
    
    [self.contentView addSubview:self.chinaLabel];
    [self.chinaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_right).offset(MidPadding);
        make.centerY.mas_equalTo(self.nameLabel.mas_centerY);
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
        make.centerY.mas_equalTo(self.iconView.mas_centerY);
    }];
    
    [self.contentView addSubview:self.marketLabel];
    [self.marketLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.priceLabel.mas_right);
        make.top.mas_equalTo(self.priceLabel.mas_bottom).offset(MinPadding);
    }];
    
    [self.contentView addSubview:self.volLabel];
    [self.volLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_left);
        make.top.mas_equalTo(self.marketLabel.mas_top);
    }];
    
    self.nameLabel.text = @"BTC";
    self.chinaLabel.text = @"比特币";
    self.priceLabel.text = @"￥50,819.45";
    self.marketLabel.text = @"7,553.43";
    self.degreeLabel.text = @"-2.35%";
    self.volLabel.text = @"9.01万 ETH/4,950 BTC";
}

#pragma mark - init
- (BaseImageView *)iconView{
    if (!_iconView) {
        _iconView = [[BaseImageView alloc] init];
        ViewRadius(_iconView, AdaptX(20/2));
        _iconView.backgroundColor = BackGroundColor;
    }
    return _iconView;
}

- (BaseLabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(14) textColor:MainBlackColor textAlignment:NSTextAlignmentLeft];
    }
    return _nameLabel;
}

- (BaseLabel *)chinaLabel{
    if (!_chinaLabel) {
        _chinaLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(10) textColor:LightTextGrayColor textAlignment:NSTextAlignmentLeft];
    }
    return _chinaLabel;
}

- (BaseLabel *)degreeLabel{
    if (!_degreeLabel) {
        _degreeLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(13) textColor:WhiteTextColor textAlignment:NSTextAlignmentCenter];
        _degreeLabel.backgroundColor = BackGreenColor;
        ViewRadius(_degreeLabel, AdaptX(2));
    }
    return _degreeLabel;
}

- (BaseLabel *)volLabel{
    if (!_volLabel) {
        _volLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(10) textColor:LightTextGrayColor textAlignment:NSTextAlignmentLeft];
    }
    return _volLabel;
}

- (BaseLabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(16) textColor:DarkBlackColor textAlignment:NSTextAlignmentRight];
    }
    return _priceLabel;
}

- (BaseLabel *)marketLabel{
    if (!_marketLabel) {
        _marketLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(10) textColor:LightTextGrayColor textAlignment:NSTextAlignmentRight];
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
