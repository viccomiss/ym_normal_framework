

//
//  BaseNavigationBar.m
//  BaseNavigationController
//
//  Created by liusong on 2018/3/27.
//  Copyright © 2018年 liusong. All rights reserved.
//

#import "BaseNavigationBar.h"
#import <objc/runtime.h>

@implementation BaseTopNavigationBar
@end




@implementation BaseNavigationBar

-(void)layoutSubviews{
    [super layoutSubviews];
    for (UIView *view in self.subviews) {
        NSString *className=NSStringFromClass([view class]);
        if ([className isEqualToString:@"_UIBarBackground"]) {
            
            CGFloat height=[UIApplication sharedApplication].statusBarFrame.size.height;
            CGRect frame=self.bounds;
            frame.size.height =self.frame.size.height+height;
            frame.origin.y=-height;
            view.frame=frame;
        }
    }
}

@end



@implementation BaseNavigationItem

-(void)setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem
{
    //解决ios11以下系统 设置leftBarButtonItem不显示问题 通过延迟也可以解决 但是此方法不用延时也可以解决
    dispatch_async(dispatch_get_main_queue(), ^{
        [super setLeftBarButtonItem:leftBarButtonItem];
    });
}

-(void)setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem
{
    //解决ios11以下系统 设置leftBarButtonItem不显示问题 通过延迟也可以解决 但是此方法不用延时也可以解决
    dispatch_async(dispatch_get_main_queue(), ^{
        [super setRightBarButtonItem:rightBarButtonItem];
    });
}

@end



