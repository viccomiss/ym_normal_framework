//
//  ExchangeCell.h
//  Hunt
//
//  Created by 杨明 on 2018/8/2.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "ExchangeModel.h"

/**
 交易所cell
 */
@interface ExchangeCell : BaseTableViewCell

+ (instancetype)exchangeCell:(UITableView *)tableView;

/* model */
@property (nonatomic, strong) ExchangeModel *model;

@end
