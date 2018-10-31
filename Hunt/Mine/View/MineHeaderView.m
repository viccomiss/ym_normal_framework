//
//  MineHeaderView.m
//  Hunt
//
//  Created by 杨明 on 2018/8/4.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "MineHeaderView.h"
#import "UserInfoView.h"
#import "MineInviteView.h"

@interface MineHeaderView()

/* userinfo */
@property (nonatomic, strong) UserInfoView *infoView;
/* invite */
@property (nonatomic, strong) MineInviteView *inviteView;

@end

@implementation MineHeaderView

- (instancetype)init{
    if (self == [super init]) {
        
        self.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, AdaptY(229) + StatusBarH);
        self.backgroundColor = WhiteTextColor;
        [self createUI];
    }
    return self;
}

#pragma mark - UI
- (void)createUI{
    
    [self addSubview:self.infoView];
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(StatusBarH);
        make.left.right.mas_equalTo(self);
        make.height.equalTo(@(AdaptY(80)));
    }];
    
    [self addSubview:self.inviteView];
    [self.inviteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.infoView.mas_bottom);
        make.left.right.mas_equalTo(self);
        make.height.equalTo(@(AdaptY(149)));
    }];
}

#pragma mark - init
- (UserInfoView *)infoView{
    if (!_infoView) {
        _infoView = [[UserInfoView alloc] init];
    }
    return _infoView;
}

- (MineInviteView *)inviteView{
    if (!_inviteView) {
        _inviteView = [[MineInviteView alloc] init];
    }
    return _inviteView;
}


@end
