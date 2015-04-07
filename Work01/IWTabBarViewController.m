//
//  IWTabBarViewController.m
//  ItcastWeibo
//
//  Created by apple on 14-5-5.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "IWTabBarViewController.h"

#import "UserViewController.h"//用户
#import "SelectProjectController.h"//学习
#import "ViewController.h"//首页

#import "IWNavigationController.h"
#import "UIImage+KWJ.h"
#import "IWTabBar.h"

#import "HeaderFile.h"

@interface IWTabBarViewController () <IWTabBarDelegate>
/*
 *  自定义的tabbar
 */
@property (nonatomic, weak) IWTabBar *customTabBar;
@end

@implementation IWTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化tabbar
    [self setupTabbar];
    
    // 初始化所有的子控制器
    [self setupAllChildViewControllers];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 删除系统自动生成的UITabBarButton
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            NSLog(@"%@",child.textInputContextIdentifier);
            [child removeFromSuperview];
        }
    }
}

/*
 *  初始化tabbar
 */
- (void)setupTabbar
{
    IWTabBar *customTabBar = [[IWTabBar alloc] init];
    customTabBar.frame = self.tabBar.bounds;
    customTabBar.delegate = self;
    [self.tabBar addSubview:customTabBar];
    self.customTabBar = customTabBar;
}

/*
 *  监听tabbar按钮的改变
 *  @param from   原来选中的位置
 *  @param to     最新选中的位置
 */
- (void)tabBar:(IWTabBar *)tabBar didSelectedButtonFrom:(int)from to:(int)to
{
    self.selectedIndex = to;
}

/*
 *  初始化所有的子控制器
 */
- (void)setupAllChildViewControllers
{
//    IWHomeViewController *home = [[IWHomeViewController alloc] init];
//    [self setupChildViewController:home title:@"首页" imageName:@"tabbar_home" selectedImageName:@"tabbar_home_selected"];
    
    UIStoryboard *storyBoary = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //self.window.rootViewController = [storyBoary instantiateViewControllerWithIdentifier:@"tabbar"];
    
//    ViewController *home = [[ViewController alloc] init];
    [self setupChildViewController:[storyBoary instantiateViewControllerWithIdentifier:@"homef"] title:@"博文" imageName:@"tabbar_home" selectedImageName:@"tabbar_home_selected"];

//    SelectProjectController *project = [[SelectProjectController alloc] init];
    [self setupChildViewController:[storyBoary instantiateViewControllerWithIdentifier:@"projectf"] title:@"学库" imageName:@"tabbar_discover" selectedImageName:@"tabbar_discover_selected"];
    
//    UserViewController *user = [[UserViewController alloc] init];
    [self setupChildViewController:[storyBoary instantiateViewControllerWithIdentifier:@"user"] title:@"个人" imageName:@"tabbar_profile" selectedImageName:@"tabbar_profile_selected"];
}

/*
 *  初始化一个子控制器
 *
 *  @param childVc           需要初始化的子控制器
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中的图标
 */
- (void)setupChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    // 1.设置控制器的属性
    childVc.title = title;
    // 设置图标
    childVc.tabBarItem.image = [UIImage imageWithName:imageName];
    // 设置选中的图标
    UIImage *selectedImage = [UIImage imageWithName:selectedImageName];
    if (iOS7) {
        childVc.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    } else {
        childVc.tabBarItem.selectedImage = selectedImage;
    }
    
    // 2.包装一个导航控制器
    IWNavigationController *nav = [[IWNavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
    
    // 3.添加tabbar内部的按钮
    [self.customTabBar addTabBarButtonWithItem:childVc.tabBarItem];
}

@end
