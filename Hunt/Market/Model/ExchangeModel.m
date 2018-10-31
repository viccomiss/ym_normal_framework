//
//  ExchangeModel.m
//  Hunt
//
//  Created by 杨明 on 2018/8/4.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "ExchangeModel.h"

@implementation ExchangeModel

+(NSURLSessionDataTask*)exchange_ranks:(NSDictionary *)option
                           Success:(void (^)(NSArray *list))success
                           Failure:(void (^)(NSError *error))failue{
    
    return [APIManager SafePOST:URI_EXCHANGE_RANKS parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        NSArray *arr = [responseObject jk_arrayForKey:@"result"];
        NSMutableArray *arrM = [NSMutableArray array];
        for (NSDictionary *dic in arr) {
            ExchangeModel *model = [ExchangeModel mj_objectWithKeyValues:dic];
            [arrM addObject:model];
        }
        
        success(arrM);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

@end
