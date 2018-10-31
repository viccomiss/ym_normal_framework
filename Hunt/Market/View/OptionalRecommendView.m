//
//  OptionalRecommendView.m
//  Hunt
//
//  Created by 杨明 on 2018/7/30.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "OptionalRecommendView.h"
#import "OptionalRecommendCell.h"

static NSString *contentCollectionCellId = @"optionRecommendCellId";

@interface OptionalRecommendView()<UICollectionViewDelegate,UICollectionViewDataSource>

/* collection */
@property (nonatomic, strong) UICollectionView *collectionView;
/* dataArray */
@property (nonatomic, strong) NSMutableArray *dataArray;
/* add */
@property (nonatomic, strong) BaseButton *addBtn;
/* reloadBtn */
@property (nonatomic, strong) BaseButton *reloadBtn;
/* custom */
@property (nonatomic, strong) BaseButton *customBtn;

@end

@implementation OptionalRecommendView

- (instancetype)init{
    if (self == [super init]) {
        
        [self createUI];
    }
    return self;
}

#pragma mark - collection datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 6;
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    OptionalRecommendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:contentCollectionCellId forIndexPath:indexPath];
    return cell;
}

#pragma mark - collecton delegate

#pragma mark - UI
- (void)createUI{
    
    BaseLabel *topTag = [SEFactory labelWithText:@"智能推荐" frame:CGRectZero textFont:[UIFont boldSystemFontOfSize:AdaptX(14)] textColor:MainBlackColor textAlignment:NSTextAlignmentCenter];
    [self addSubview:topTag];
    [topTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(AdaptY(40));
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    UIView *leftLine = [[UIView alloc] init];
    leftLine.backgroundColor = LightLineColor;
    [self addSubview:leftLine];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(topTag.mas_left).offset(-MidPadding);
        make.centerY.mas_equalTo(topTag.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(AdaptX(40), 1));
    }];
    
    UIView *rightLine = [[UIView alloc] init];
    rightLine.backgroundColor = LightLineColor;
    [self addSubview:rightLine];
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(topTag.mas_right).offset(MidPadding);
        make.centerY.mas_equalTo(topTag.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(AdaptX(40), 1));
    }];

    
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(AdaptY(74));
        make.left.right.mas_equalTo(self);
        make.height.equalTo(@(AdaptY(170)));
    }];
    
    [self addSubview:self.addBtn];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.collectionView.mas_bottom).offset(AdaptY(46));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(AdaptX(90), AdaptY(32)));
    }];

    [self addSubview:self.reloadBtn];
    [self.reloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-MidPadding);
        make.centerY.mas_equalTo(self.addBtn.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(AdaptX(80), AdaptY(32)));
    }];
    
    [self addSubview:self.customBtn];
    [self.customBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.addBtn.mas_bottom).offset(AdaptY(70));
        make.height.equalTo(@(AdaptY(30)));
    }];
}

#pragma mark - init
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = MidPadding;
        layout.minimumInteritemSpacing = MidPadding;
        layout.sectionInset = UIEdgeInsetsMake(0, MaxPadding, 0, 0);
        layout.itemSize = CGSizeMake((MAINSCREEN_WIDTH - 2 * MidPadding - 2 * MaxPadding) / 3, AdaptY(80));
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[OptionalRecommendCell class] forCellWithReuseIdentifier:contentCollectionCellId];
    }
    return _collectionView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (BaseButton *)addBtn{
    if (!_addBtn) {
        _addBtn = [SEFactory buttonWithTitle:@"一键添加" image:nil frame:CGRectMake(0, 0, AdaptX(90), AdaptY(32)) font:Font(13) fontColor:WhiteTextColor];
        [_addBtn.layer insertSublayer:[UIColor setGradualChangingColor:_addBtn fromColor:[ThemeManager sharedInstance].gradientColor toColor:[ThemeManager sharedInstance].themeColor] below:_addBtn.titleLabel.layer];
        ViewRadius(_addBtn, AdaptY(16));
    }
    return _addBtn;
}

- (BaseButton *)reloadBtn{
    if (!_reloadBtn) {
        _reloadBtn = [SEFactory buttonWithTitle:@"换一批" image:ImageName(@"reload") frame:CGRectZero font:Font(12) fontColor:LightTextGrayColor];
        [_reloadBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:3];
    }
    return _reloadBtn;
}

- (BaseButton *)customBtn{
    if (!_customBtn) {
        _customBtn = [SEFactory buttonWithTitle:@"不太感兴趣，我要自己添加 >" image:nil frame:CGRectZero font:Font(12) fontColor:DarkBlackColor];
    }
    return _customBtn;
}


@end
