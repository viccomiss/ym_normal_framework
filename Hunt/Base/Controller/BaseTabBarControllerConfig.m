//
//  BaseTabBarControllerConfig.m
//  nuoee_krypto
//
//  Created by Mac on 2018/5/30.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "BaseTabBarControllerConfig.h"
#import "BaseNavigationController.h"
#import "BaseMarketViewController.h"
#import "MineViewController.h"
#import "CandyViewController.h"
#import "ProjectViewController.h"
#import "CYLPlusButtonSubclass.h"

static CGFloat const CYLTabBarControllerHeight = 40.f;


@interface BaseTabBarControllerConfig ()<UITabBarControllerDelegate>

@property (nonatomic, readwrite, strong) CYLTabBarController *tabBarController;

@end

@implementation BaseTabBarControllerConfig

/**
 *  lazy load tabBarController
 *
 *  @return CYLTabBarController
 */
- (CYLTabBarController *)tabBarController {
    if (_tabBarController == nil) {
        /**
         * 以下两行代码目的在于手动设置让TabBarItem只显示图标，不显示文字，并让图标垂直居中。
         * 等效于在 `-tabBarItemsAttributesForController` 方法中不传 `CYLTabBarItemTitle` 字段。
         * 更推荐后一种做法。
         */
        UIEdgeInsets imageInsets = UIEdgeInsetsZero;//UIEdgeInsetsMake(4.5, 0, -4.5, 0);
        UIOffset titlePositionAdjustment = UIOffsetZero;//UIOffsetMake(0, MAXFLOAT);
        
        CYLTabBarController *tabBarController = [CYLTabBarController tabBarControllerWithViewControllers:self.viewControllers
                                                                                   tabBarItemsAttributes:self.tabBarItemsAttributesForController
                                                                                             imageInsets:imageInsets
                                                                                 titlePositionAdjustment:titlePositionAdjustment
                                                                                                 context:self.context
                                                 ];
        [self customizeTabBarAppearance:tabBarController];
        _tabBarController = tabBarController;
    }
    return _tabBarController;
}

- (NSArray *)viewControllers {
    BaseMarketViewController *baseMarketVC = [[BaseMarketViewController alloc] init];
    BaseNavigationController *baseMarketNav = [[BaseNavigationController alloc] initWithRootViewController:baseMarketVC];
    
    CandyViewController *candyVC = [[CandyViewController alloc] init];
    BaseNavigationController *candyNav = [[BaseNavigationController alloc] initWithRootViewController:candyVC];
    
    ProjectViewController *projectVC = [[ProjectViewController alloc] init];
    BaseNavigationController *projectNav = [[BaseNavigationController alloc] initWithRootViewController:projectVC];
    
    MineViewController *mineVC = [[MineViewController alloc] init];
    BaseNavigationController *mineNav = [[BaseNavigationController alloc] initWithRootViewController:mineVC];
    
    
    NSArray *viewControllers = @[
                                 baseMarketNav,
                                 candyNav,
                                 projectNav,
                                 mineNav
                                 ];
    return viewControllers;
}

- (NSArray *)tabBarItemsAttributesForController {
    NSDictionary *firstTabBarItemsAttributes = @{
                                                 CYLTabBarItemTitle : LocalizedString(@"行情"),
                                                 CYLTabBarItemImage : @"tab_market",
                                                 CYLTabBarItemSelectedImage : @"tab_market_on",
                                                 };
    NSDictionary *secondTabBarItemsAttributes = @{
                                                                                                    CYLTabBarItemTitle : LocalizedString(@"糖果"),
                                                  CYLTabBarItemImage : @"tab_candy",
                                                  CYLTabBarItemSelectedImage : @"tab_candy_on",
                                                  };
    NSDictionary *thirdTabBarItemsAttributes = @{
                                                                                                  CYLTabBarItemTitle : LocalizedString(@"应用"),
                                                 CYLTabBarItemImage : @"tab_project",
                                                 CYLTabBarItemSelectedImage : @"tab_project_on",
                                                 };
    NSDictionary *fourthTabBarItemsAttributes = @{
                                                 CYLTabBarItemTitle : LocalizedString(@"我的"),
                                                 CYLTabBarItemImage : @"tab_mine",
                                                 CYLTabBarItemSelectedImage :@"tab_mine_on",
                                                 };

    NSArray *tabBarItemsAttributes = @[
                                       firstTabBarItemsAttributes,
                                       secondTabBarItemsAttributes,
                                       thirdTabBarItemsAttributes,
                                       fourthTabBarItemsAttributes
                                       ];
    return tabBarItemsAttributes;
}

/**
 *  更多TabBar自定义设置：比如：tabBarItem 的选中和不选中文字和背景图片属性、tabbar 背景图片属性等等
 */
- (void)customizeTabBarAppearance:(CYLTabBarController *)tabBarController {
#warning CUSTOMIZE YOUR TABBAR APPEARANCE
    // Customize UITabBar height
    // 自定义 TabBar 高度
    tabBarController.tabBarHeight = TabbarH;
    
    // set the text color for unselected state
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = TextDarkColor;
    
    // set the text color for selected state
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = PYTHEME_THEME_COLOR;
    
    
    // set the text Attributes
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
//    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    [tabBar py_addToThemeColorPoolWithSelector:@selector(setTitleTextAttributes:forState:) objects:@[selectedAttrs, @(UIControlStateSelected)]];
    
    // Set the dark color to selected tab (the dimmed background)
    // TabBarItem选中后的背景颜色
    // [self customizeTabBarSelectionIndicatorImage];
    
    // update TabBar when TabBarItem width did update
    // If your app need support UIDeviceOrientationLandscapeLeft or UIDeviceOrientationLandscapeRight，
    // remove the comment '//'
    // 如果你的App需要支持横竖屏，请使用该方法移除注释 '//'
     [self updateTabBarCustomizationWhenTabBarItemWidthDidUpdate];
    
    // set the bar shadow image
    // This shadow image attribute is ignored if the tab bar does not also have a custom background image.So at least set somthing.
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setBackgroundColor:WhiteTextColor];
    //    [[UITabBar appearance] setShadowImage:[UIImage imageNamed:@"tapbar_top_line"]];
    
    // set the bar background image
    // 设置背景图片
    UITabBar *tabBarAppearance = [UITabBar appearance];
    
    //FIXED: #196
    UIImage *tabBarBackgroundImage = [UIImage imageNamed:@"tab_bar"];
    UIImage *scanedTabBarBackgroundImage = [[self class] scaleImage:tabBarBackgroundImage toScale:1.0];
    //     [tabBarAppearance setBackgroundImage:scanedTabBarBackgroundImage];
    
    // remove the bar system shadow image
    // 去除 TabBar 自带的顶部阴影
    // iOS10 后 需要使用 `-[CYLTabBarController hideTabBadgeBackgroundSeparator]` 见 AppDelegate 类中的演示;
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
}

- (void)updateTabBarCustomizationWhenTabBarItemWidthDidUpdate {
    void (^deviceOrientationDidChangeBlock)(NSNotification *) = ^(NSNotification *notification) {
        UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
        if ((orientation == UIDeviceOrientationLandscapeLeft) || (orientation == UIDeviceOrientationLandscapeRight)) {
            NSLog(@"Landscape Left or Right !");
        } else if (orientation == UIDeviceOrientationPortrait) {
            NSLog(@"Landscape portrait!");
        }
        [self customizeTabBarSelectionIndicatorImage];
    };
    [[NSNotificationCenter defaultCenter] addObserverForName:CYLTabBarItemWidthDidChangeNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:deviceOrientationDidChangeBlock];
}

- (void)customizeTabBarSelectionIndicatorImage {
    ///Get initialized TabBar Height if exists, otherwise get Default TabBar Height.
    CGFloat tabBarHeight = CYLTabBarControllerHeight;
    CGSize selectionIndicatorImageSize = CGSizeMake(CYLTabBarItemWidth, tabBarHeight);
    //Get initialized TabBar if exists.
    UITabBar *tabBar = [self cyl_tabBarController].tabBar ?: [UITabBar appearance];
    [tabBar setSelectionIndicatorImage:
     [[self class] imageWithColor:[UIColor yellowColor]
                             size:selectionIndicatorImageSize]];
}

+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize {
    UIGraphicsBeginImageContext(CGSizeMake([UIScreen mainScreen].bounds.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width + 1, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
