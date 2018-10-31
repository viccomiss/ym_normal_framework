//
//  Enumeration.h
//  UNIS-LEASE
//
//  Created by runlin on 2016/11/10.
//  Copyright © 2016年 unis. All rights reserved.
//

#ifndef Enumeration_h
#define Enumeration_h

/** theme type */
typedef NS_ENUM(NSUInteger, ThemeType){
    ThemeBlueType,
    ThemeOrangeType,
};

/** cell type */
typedef NS_ENUM(NSUInteger, MineCellType){
    MineNormalCellType,
    MineMessageTagCellType,
    MineSummaryCellType,
    MineSwitchCellType,
};

/** WightMenuType */
typedef NS_ENUM(NSUInteger, WeightMenuBtnType){
    WeightMenuBtnNormalType = 0,
    WeightMenuBtnDownType = 1,
    WeightMenuBtnUpType = 2,
};

/** kMenuType */
typedef NS_ENUM(NSUInteger, KMenuType){
    KMenuKLineOrTimeType = 0,
    KMenuInd1Type = 1,
    KMenuInd2Type = 2,
    KMenuInd3Type = 3,
    KMenuCycleType = 4, //分时
};


typedef NS_ENUM(NSUInteger, KMenuStateType){
    KMenuFixedType = 0, //固定
    KMenuDynamicType = 1, //动态隐藏
    KMenuQuataType = 2, //指标
};

typedef NS_ENUM(NSUInteger, RoseOrFallType){
    RoseType = 0, //上涨
    FallType = 1, //下跌
};

/** 权重menuType */
typedef NS_ENUM(NSUInteger, WeightMenuType){
    WeightMenuFourType,
    WeightMenuTwoType,
    WeightMenuThreeType
};

/** 排行or交易所类型 */
typedef NS_ENUM(NSUInteger, CoinRankOrExchangeType){
    CoinRankType,
    ExchangeType,
};

/** 无数据类型 */
typedef NS_ENUM(NSUInteger, NoDataType){
    NoTextType = 1,
    NoNetworkType = 2,
    NoFlashType = 3,
    NoUnWarnType = 4,
    NoHistoryType = 5,
    NoMessageType,
    NoSearchType,
};


/** 网络监听 */
typedef NS_ENUM(NSUInteger,NetWorkState) {
    NetWorkUnknow = 0,  //没网
    NetWorkConnected = 1,     //有网
};
#endif /* Enumeration_h */
