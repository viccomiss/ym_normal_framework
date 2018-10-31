//
//  UserInfoView.m
//  Hunt
//
//  Created by 杨明 on 2018/8/5.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "UserInfoView.h"

@interface UserInfoView()

/* icon */
@property (nonatomic, strong) BaseImageView *iconView;
/* name */
@property (nonatomic, strong) BaseLabel *nameLabel;
/* arrow */
@property (nonatomic, strong) BaseButton *arrowBtn;

@end

@implementation UserInfoView

- (instancetype)init{
    if (self == [super init]) {
        
        [self createUI];
    }
    return self;
}

#pragma mark - action
- (void)detailTouch{
    
}

#pragma mark - UI
- (void)createUI{
    
    [self addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(AdaptX(15));
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(AdaptX(50), AdaptX(50)));
    }];
    
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).offset(AdaptX(15));
        make.centerY.mas_equalTo(self.iconView.mas_centerY);
    }];
    
    [self addSubview:self.arrowBtn];
    [self.arrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(- MidPadding);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(AdaptX(25), AdaptX(25)));
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = LineColor;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.equalTo(@(0.5));
    }];
}

#pragma mark - init
- (BaseImageView *)iconView{
    if (!_iconView) {
        _iconView = [[BaseImageView alloc] initWithImage:ImageName(@"avatar_default")];
        ViewRadius(_iconView, AdaptY(25));
    }
    return _iconView;
}

- (BaseLabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [SEFactory labelWithText:@"13520726364" frame:CGRectZero textFont:Font(15) textColor:MainBlackColor textAlignment:NSTextAlignmentLeft];
    }
    return _nameLabel;
}

- (BaseButton *)arrowBtn{
    if (!_arrowBtn) {
        _arrowBtn = [SEFactory buttonWithImage:ImageName(@"arrow_right")];
        [_arrowBtn addTarget:self action:@selector(detailTouch) forControlEvents:UIControlEventTouchUpInside];
    }
    return _arrowBtn;
}

@end
