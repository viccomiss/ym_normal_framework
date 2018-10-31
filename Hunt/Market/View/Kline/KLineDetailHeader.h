//
//  KLineDetailHeader.h
//  nuoee_krypto
//
//  Created by Mac on 2018/6/19.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KlineModel.h"
#import "CoinRanksModel.h"

/**
 k线header
 */
@interface KLineDetailHeader : UIView

/* model */
@property (nonatomic, strong) KlineModel *model;
/* CoinModel */
@property (nonatomic, strong) CoinRanksModel *coinRank;

- (void)adjustLayout;

@end
