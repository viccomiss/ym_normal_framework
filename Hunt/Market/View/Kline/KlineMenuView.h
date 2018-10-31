//
//  KlineMenuView.h
//  Hunt
//
//  Created by 杨明 on 2018/8/3.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 k线菜单
 */
@interface KlineMenuView : UIView

- (instancetype)initWithTitles:(NSArray *)titles;

/* touchBlock */
@property (nonatomic, strong) BaseIntBlock touchBlock;

//是否显示阴影
- (void)stayShowShadow:(BOOL)shadow;

@end
