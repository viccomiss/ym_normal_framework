//
//  UIViewController+LSNavigationController.h
//  BaseNavigationController
//
//  Created by liusong on 2018/3/30.
//  Copyright © 2018年 liusong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseNavigationBar.h"


@interface UIViewController (BaseNavigationController)

@property (nonatomic,weak) BaseNavigationBar *navigationBar;

@property (nonatomic,assign) BOOL cancelGesture; //取消当前页面手势 不影响其他VC手势使用
@property (nonatomic,assign) BOOL forbidAllGesture;//禁用整个导航控制器手势 如果想在启用必须在设置为NO



//创建UINavigationBar
-(void)reloadNavigationBar:(BOOL)hideBottomLine;

//删除UINavigationBar
-(void)removeNavigationBar;

//左上角返回按钮点击事件 如果想hook 重写此方法即可
-(void)navigationBarClickBack;

//根据UIColor生成UIImage
- (UIImage*)imageWithColor:(UIColor*)color;

@end
