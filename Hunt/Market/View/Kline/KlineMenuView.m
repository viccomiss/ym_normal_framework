//
//  KlineMenuView.m
//  Hunt
//
//  Created by 杨明 on 2018/8/3.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "KlineMenuView.h"

@interface KlineMenuView()

/* btnArray */
@property (nonatomic, strong) NSMutableArray *btnArray;
/* bottomLine */
@property (nonatomic, strong) UIView *bottomLineView;
/* titles */
@property (nonatomic, strong) NSArray *titles;
/* line */
@property (nonatomic, strong) UIView *line;

@end

@implementation KlineMenuView

- (instancetype)initWithTitles:(NSArray *)titles{
    if (self == [super init]) {
        
        self.backgroundColor = WhiteTextColor;
        self.titles = titles;
        [self createUI];
    }
    return self;
}

#pragma mark - action
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
    
    [UIView animateWithDuration:0.2 animations:^{
        self.bottomLineView.center = CGPointMake((MAINSCREEN_WIDTH / self.titles.count / 2) + (MAINSCREEN_WIDTH / self.titles.count) * sender.tag, self.bottomLineView.center.y);
    }];
    
    if (self.touchBlock) {
        self.touchBlock(sender.tag);
    }
}

- (void)stayShowShadow:(BOOL)shadow{
    
    if (shadow) {
        self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        self.layer.shadowOffset=CGSizeMake(0, 3);
        self.layer.shadowOpacity=0.3;
        self.layer.shadowRadius=2;
        self.line.hidden = YES;
    }else{
        self.line.hidden = NO;
        self.layer.shadowColor = [UIColor clearColor].CGColor;
        self.layer.shadowOffset=CGSizeMake(0, 0);
        self.layer.shadowOpacity=0;
        self.layer.shadowRadius=0;
    }
}

#pragma mark - UI
- (void)createUI{
    
    for (int i = 0; i < self.titles.count; i++) {
        BaseButton *btn = [SEFactory buttonWithTitle:self.titles[i] image:nil frame:CGRectZero font:Font(14) fontColor:TextDarkGrayColor];
        btn.tag = i;
        [btn py_addToThemeColorPoolWithSelector:@selector(setTitleColor:forState:) objects:@[PYTHEME_THEME_COLOR, @(UIControlStateSelected)]];
        [btn addTarget:self action:@selector(btnTouch:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(i * MAINSCREEN_WIDTH / self.titles.count);
            make.top.height.mas_equalTo(self);
            make.width.equalTo(@(MAINSCREEN_WIDTH / self.titles.count));
        }];
        
        if (i == 0) {
            btn.selected = YES;
        }
        
        [self.btnArray addObject:btn];
    }
    
    [self addSubview:self.bottomLineView];
    
    [self addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.equalTo(@(0.5));
    }];
}

#pragma mark - init
- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = LineColor;
    }
    return _line;
}

- (NSMutableArray *)btnArray{
    if (!_btnArray) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

- (UIView *)bottomLineView{
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, AdaptY(40) - 2, AdaptX(30), 2)];
        _bottomLineView.center = CGPointMake(MAINSCREEN_WIDTH / self.titles.count / 2, _bottomLineView.center.y);
        [_bottomLineView py_addToThemeColorPool:@"backgroundColor"];
    }
    return _bottomLineView;
}

@end
