//
//  KlineMoreIndView.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/19.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "KlineMoreCycView.h"

@interface KlineMoreCycView()

/* btnArray */
@property (nonatomic, strong) NSMutableArray *btnArray;
/* close */
@property (nonatomic, strong) BaseButton *closeBtn;

@end

@implementation KlineMoreCycView

- (instancetype)init{
    if (self == [super init]) {
        
        self.backgroundColor = WhiteTextColor;
        [self createUI];
    }
    return self;
}

#pragma mark - action
- (void)closeTouch{
    self.hidden = YES;
}

- (void)btnTouch:(BaseButton *)sender{
    if (sender.selected) {
        return;
    }
    for (BaseButton *btn in self.btnArray) {
        if (btn.tag == sender.tag) {
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
    }
    
    NSString *value;
    for (NSDictionary *dic in [self cycData]) {
        if ([[dic allKeys].firstObject isEqualToString:sender.titleLabel.text]) {
            value = [dic objectForKey:sender.titleLabel.text];
        }
    }
    if (self.changeCycBlock) {
        self.changeCycBlock(sender.titleLabel.text, value);
    }
}

- (NSArray *)cycData{
    return @[@{@"5m" : @"5m"}, @{@"15m" : @"15m"}, @{@"30m" : @"30m"}, @{@"1h" : @"1h"}, @{LocalizedString(@"日K") : @"1d"}, @{LocalizedString(@"周K") : @"1w"}, @{LocalizedString(@"月K") : @"1M"}];
}

#pragma mark - UI
- (void)createUI{
    
    NSArray *titleArr = @[@[@"5m",@"15m", @"30m", @"1h", LocalizedString(@"日K")],@[LocalizedString(@"周K"), LocalizedString(@"月K")]];
    
    CGFloat width = (MAINSCREEN_WIDTH - 7 * MidPadding) / 5;
    CGFloat height = AdaptY(30);
    
    int row = 2;
    
    for (int i = 0; i < row; i++) {
        NSArray *arr = titleArr[i];
        for (int j = 0; j < arr.count; j++) {
            BaseButton *btn = [SEFactory buttonWithTitle:titleArr[i][j] image:nil frame:CGRectZero font:Font(11) fontColor:MainBlackColor];
            [btn py_addToThemeColorPoolWithSelector:@selector(setTitleColor:forState:) objects:@[PYTHEME_THEME_COLOR, @(UIControlStateSelected)]];
            btn.tag = i * 10 + j;
            [btn addTarget:self action:@selector(btnTouch:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.mas_left).offset(MidPadding + MidPadding * j + width * j);
                make.top.mas_equalTo(self.mas_top).offset(MidPadding + height * i + AdaptY(5) * i);
                make.size.mas_equalTo(CGSizeMake(width, height));
            }];
            
            if ([btn.titleLabel.text isEqualToString:@"15m"]) {
                btn.selected = YES;
            }
            
            [self.btnArray addObject:btn];
        }
    }
    
    self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.layer.shadowOffset=CGSizeMake(0, 3);
    self.layer.shadowOpacity=0.3;
    self.layer.shadowRadius=2;
    
    [self addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(MidPadding + MidPadding * 4 + width * 4);
        make.top.mas_equalTo(self.mas_top).offset(MidPadding + height + AdaptY(5));
        make.size.mas_equalTo(CGSizeMake(width, height));
    }];
    
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = LineColor;
    [self addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        make.height.equalTo(@(0.5));
    }];
}

#pragma mark - init
- (BaseButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [SEFactory buttonWithTitle:LocalizedString(@"关闭") image:nil frame:CGRectZero font:Font(11) fontColor:MainBlackColor];
        [_closeBtn addTarget:self action:@selector(closeTouch) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (NSMutableArray *)btnArray{
    if (!_btnArray) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

@end
