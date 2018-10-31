//
//  CoinRanksModel.h
//  Hunt
//
//  Created by 杨明 on 2018/8/3.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "BaseModel.h"

/**
 币行情Model
 */
@interface CoinRanksModel : BaseModel

/* iconUrl */
@property (nonatomic, copy) NSString *iconUrl;
/* 币code */
@property (nonatomic, copy) NSString *coinCode;
/* 币中文名 */
@property (nonatomic, copy) NSString *cnName;
/* 交易所code  ,ALL 全网 */
@property (nonatomic, copy) NSString *exchangeCode;
/* 市值 */
@property (nonatomic, assign) CGFloat marketCap;
/* 成交额 */
@property (nonatomic, assign) CGFloat turnover;
/* 成交量 */
@property (nonatomic, assign) CGFloat volume;
/* 当前价格 */
@property (nonatomic, assign) CGFloat price;
/* 涨跌值 */
@property (nonatomic, assign) CGFloat change;
/* 涨跌幅 */
@property (nonatomic, assign) CGFloat degree;
/* 最高价 */
@property (nonatomic, assign) CGFloat high;
/* 最低价 */
@property (nonatomic, assign) CGFloat low;
/* 换手率 */
@property (nonatomic, assign) CGFloat turnoverRate;
/* 排名 */
@property (nonatomic, assign) NSInteger rankNum;
/* 更新时间戳 */
@property (nonatomic, assign) NSInteger lastUpdate;

//币行情列表
+(NSURLSessionDataTask*)coin_ranks:(NSDictionary *)option
                           Success:(void (^)(NSArray *list))success
                           Failure:(void (^)(NSError *error))failue;

@end
