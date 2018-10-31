//
//  CoinMarketCell.h
//  Hunt
//
//  Created by 杨明 on 2018/8/2.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "CoinRanksModel.h"

/**
 币市值
 */
@interface CoinMarketCell : BaseTableViewCell

+ (instancetype)coinMarketCell:(UITableView *)tableView;

/* model */
@property (nonatomic, strong) CoinRanksModel *model;

@end
