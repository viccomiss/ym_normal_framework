

//
//  UINavigationBar+BaseNavigationController.m
//  BaseNavigationController
//
//  Created by liusong on 2018/3/28.
//  Copyright © 2018年 liusong. All rights reserved.
//

#import "UINavigationBar+BaseNavigationController.h"
#import <objc/runtime.h>
#import "BaseNavigationBar.h"

@implementation UINavigationBar (BaseNavigationController)

+ (void)ls_navBar_exchangeInstanceMethod : (Class) dClass originalSel :(SEL)originalSelector newSel: (SEL)newSelector
{
    Method originalMethod = class_getInstanceMethod(dClass, originalSelector);
    Method newMethod = class_getInstanceMethod(dClass, newSelector);
    //将 newMethod的实现 添加到系统方法中 也就是说 将 originalMethod方法指针添加成
    //方法newMethod的  返回值表示是否添加成功
    BOOL isAdd = class_addMethod(dClass, originalSelector,
                                 method_getImplementation(newMethod),
                                 method_getTypeEncoding(newMethod));
    //添加成功了 说明 本类中不存在新方法
    //所以此时必须将新方法的实现指针换成原方法的，否则 新方法将没有实现。
    if (isAdd) {
        class_replaceMethod(dClass, newSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        //添加失败了 说明本类中 有methodB的实现，此时只需要将
        // originalMethod和newMethod的IMP互换一下即可。
        method_exchangeImplementations(originalMethod, newMethod);
    }
    
}
+(void)load
{
    Class dClass=[self class];
    [self ls_navBar_exchangeInstanceMethod:dClass originalSel:@selector(pushNavigationItem:) newSel:@selector(ls_pushNavigationItem:)];
    [self ls_navBar_exchangeInstanceMethod:dClass originalSel:@selector(pushNavigationItem:animated:) newSel:@selector(ls_pushNavigationItem:animated:)];
    
}


-(void)ls_pushNavigationItem:(UINavigationItem *)item
{
    if ([self isKindOfClass:[BaseTopNavigationBar class]]) {
        item=[[UINavigationItem alloc]init];
        item.leftBarButtonItem=[UIBarButtonItem new];
    }
    [self ls_pushNavigationItem:item];
}

-(void)ls_pushNavigationItem:(UINavigationItem *)item animated:(BOOL)animated
{
    if ([self isKindOfClass:[BaseTopNavigationBar class]]) {
        item=[[UINavigationItem alloc]init];
    }
    [self ls_pushNavigationItem:item animated:animated];
}


@end



