//
//  CoinRanksModel.m
//  Hunt
//
//  Created by 杨明 on 2018/8/3.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "CoinRanksModel.h"

@implementation CoinRanksModel

+(NSURLSessionDataTask*)coin_ranks:(NSDictionary *)option
                      Success:(void (^)(NSArray *list))success
                      Failure:(void (^)(NSError *error))failue{

    return [APIManager SafePOST:URI_COIN_RANKS parameters:option success:^(NSURLResponse *respone, id responseObject) {

        NSArray *arr = [responseObject jk_arrayForKey:@"result"];
        NSMutableArray *arrM = [NSMutableArray array];
        for (NSDictionary *dic in arr) {
            CoinRanksModel *model = [CoinRanksModel mj_objectWithKeyValues:dic];
            [arrM addObject:model];
        }
        
        success(arrM);

    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

@end
