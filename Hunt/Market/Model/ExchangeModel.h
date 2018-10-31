//
//  ExchangeModel.h
//  Hunt
//
//  Created by 杨明 on 2018/8/4.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "BaseModel.h"

@interface ExchangeModel : BaseModel

/* 图标地址 */
@property (nonatomic, copy) NSString *iconUrl;
/* 交易所code */
@property (nonatomic, copy) NSString *exchangeCode;
/* 交易所名称 */
@property (nonatomic, copy) NSString *cnName;
/* 成交额 */
@property (nonatomic, assign) CGFloat turnover;

+(NSURLSessionDataTask*)exchange_ranks:(NSDictionary *)option
                               Success:(void (^)(NSArray *list))success
                               Failure:(void (^)(NSError *error))failue;

@end
