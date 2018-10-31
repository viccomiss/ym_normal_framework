//
//  KlineIndView.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/19.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "KlineIndView.h"
#import "KlineIndModel.h"

@interface KlineIndView()

/* k  */
@property (nonatomic, strong) BaseButton *kBtn;
/* ind1 */
@property (nonatomic, strong) BaseButton *ind1Btn;
/* ind2 */
@property (nonatomic, strong) BaseButton *ind2Btn;
/* ind3 */
@property (nonatomic, strong) BaseButton *ind3Btn;
/* cyc */
@property (nonatomic, strong) BaseButton *cycBtn;
/* change */
@property (nonatomic, strong) BaseButton *changeBtn;

@end

@implementation KlineIndView

- (instancetype)init{
    if (self == [super init]) {
        
        self.backgroundColor = WhiteTextColor;
        [self createUI];
    }
    return self;
}

- (void)reloadSelStr:(NSString *)sel{
    [self.cycBtn setTitle:sel forState:UIControlStateNormal];
    [self.cycBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:3];
}

#pragma mark - action
- (void)buttonTouch:(BaseButton *)sender{
    
    sender.selected = !sender.selected;
    switch (sender.tag) {
        case KMenuKLineOrTimeType:
            self.kBtn.selected = sender.selected;
            break;
        case KMenuInd1Type:
            self.ind2Btn.selected = NO;
            self.ind3Btn.selected = NO;
            break;
        case KMenuInd2Type:
            self.ind1Btn.selected = NO;
            self.ind3Btn.selected = NO;
            break;
        case KMenuInd3Type:
            self.ind1Btn.selected = NO;
            self.ind2Btn.selected = NO;
            break;
    }
    
    if (self.indBlock) {
        self.indBlock(sender.tag, sender.selected);
    }
}

#pragma mark - UI
- (void)createUI{
    
    [self addSubview:self.changeBtn];
    [self.changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(AdaptX(15));
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(AdaptX(40), AdaptY(15)));
    }];
    
    [self addSubview:self.kBtn];
    [self.kBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.changeBtn.mas_right).offset(MidPadding);
        make.top.bottom.mas_equalTo(self);
    }];
    
    [self addSubview:self.ind1Btn];
    [self.ind1Btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.kBtn.mas_right).offset(MidPadding);
        make.top.bottom.width.mas_equalTo(self.kBtn);
    }];
    
    [self addSubview:self.ind2Btn];
    [self.ind2Btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ind1Btn.mas_right).offset(MidPadding);
        make.top.bottom.width.mas_equalTo(self.kBtn);
    }];
    
    [self addSubview:self.ind3Btn];
    [self.ind3Btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ind2Btn.mas_right).offset(MidPadding);
        make.top.bottom.width.mas_equalTo(self.kBtn);
    }];
    
    [self addSubview:self.cycBtn];
    [self.cycBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-MidPadding);
        make.top.bottom.width.mas_equalTo(self.kBtn);
    }];
}

- (void)adjustSubviews:(UIInterfaceOrientation)orientation{

    
}

#pragma mark - init
- (BaseButton *)changeBtn{
    if (!_changeBtn) {
        _changeBtn = [SEFactory buttonWithImage:[ThemeManager imageForKey:@"menu_time"]];
        _changeBtn.tag = KMenuKLineOrTimeType;
        [_changeBtn setImage:[ThemeManager imageForKey:@"menu_k"] forState:UIControlStateSelected];
        [_changeBtn addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeBtn;
}

- (BaseButton *)kBtn{
    if (!_kBtn) {
        _kBtn = [SEFactory buttonWithTitle:LocalizedString(@"分时图") image:nil frame:CGRectZero font:Font(11) fontColor:TextDarkGrayColor];
        [_kBtn setTitle:LocalizedString(@"K线图") forState:UIControlStateSelected];
        [_kBtn py_addToThemeColorPoolWithSelector:@selector(setTitleColor:forState:) objects:@[PYTHEME_THEME_COLOR, @(UIControlStateSelected)]];
        [_kBtn py_addToThemeColorPoolWithSelector:@selector(setTitleColor:forState:) objects:@[PYTHEME_THEME_COLOR, @(UIControlStateNormal)]];

    }
    return _kBtn;
}

- (BaseButton *)ind1Btn{
    if (!_ind1Btn) {
        _ind1Btn = [SEFactory buttonWithTitle:LocalizedString(@"三色K线") image:nil frame:CGRectZero font:Font(11) fontColor:TextDarkGrayColor];
        _ind1Btn.tag = KMenuInd1Type;
        [_ind1Btn addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
        [_ind1Btn py_addToThemeColorPoolWithSelector:@selector(setTitleColor:forState:) objects:@[PYTHEME_THEME_COLOR, @(UIControlStateSelected)]];
    }
    return _ind1Btn;
}

- (BaseButton *)ind2Btn{
    if (!_ind2Btn) {
        _ind2Btn = [SEFactory buttonWithTitle:LocalizedString(@"与庄共舞") image:nil frame:CGRectZero font:Font(11) fontColor:TextDarkGrayColor];
        _ind2Btn.tag = KMenuInd2Type;
        [_ind2Btn addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
        [_ind2Btn py_addToThemeColorPoolWithSelector:@selector(setTitleColor:forState:) objects:@[PYTHEME_THEME_COLOR, @(UIControlStateSelected)]];
    }
    return _ind2Btn;
}


- (BaseButton *)ind3Btn{
    if (!_ind3Btn) {
        _ind3Btn = [SEFactory buttonWithTitle:LocalizedString(@"乾坤图") image:nil frame:CGRectZero font:Font(11) fontColor:TextDarkGrayColor];
        _ind3Btn.tag = KMenuInd3Type;
        [_ind3Btn addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
        [_ind3Btn py_addToThemeColorPoolWithSelector:@selector(setTitleColor:forState:) objects:@[PYTHEME_THEME_COLOR, @(UIControlStateSelected)]];
    }
    return _ind3Btn;
}


- (BaseButton *)cycBtn{
    if (!_cycBtn) {
        _cycBtn = [SEFactory buttonWithTitle:LocalizedString(@"15m") image:[ThemeManager imageForKey:@"arrow_down"] frame:CGRectZero font:Font(11) fontColor:TextDarkGrayColor];
        _cycBtn.tag = KMenuCycleType;
        [_cycBtn addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
        [_cycBtn py_addToThemeColorPoolWithSelector:@selector(setTitleColor:forState:) objects:@[PYTHEME_THEME_COLOR ,@(UIControlStateNormal)]];
        [_cycBtn py_addToThemeColorPoolWithSelector:@selector(setTitleColor:forState:) objects:@[PYTHEME_THEME_COLOR ,@(UIControlStateSelected)]];
        [_cycBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:3];
    }
    return _cycBtn;
}


@end
