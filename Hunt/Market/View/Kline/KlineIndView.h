//
//  KlineIndView.h
//  nuoee_krypto
//
//  Created by Mac on 2018/6/19.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 指标view
 */
typedef void(^indBlock)(KMenuType type, BOOL sel);

@interface KlineIndView : UIView

/* block */
@property (nonatomic, copy) indBlock indBlock;

- (void)adjustSubviews:(UIInterfaceOrientation)orientation;

- (void)reloadSelStr:(NSString *)sel;

@end
