//
//  GWFTabBarController.m
//  BaiSiBudeJie
//
//  Created by zhufeng on 16/12/17.
//  Copyright © 2016年 zhufeng. All rights reserved.
//

#import "GWFTabBarController.h"
#import "GWFTabbar.h"

@interface GWFTabBarController ()

@end

@implementation GWFTabBarController

+(void)load {
    //设置选中字体颜色
    UITabBarItem *item = [UITabBarItem appearanceWhenContainedIn:self, nil];
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    [item setTitleTextAttributes:attrs forState:UIControlStateSelected];
    [item setTitleTextAttributes:@{NSFontAttributeName:LabelFont(28) } forState:UIControlStateNormal];
    //设置字体大小
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createdTabbar];
    //添加所有的子控制器
    [self addAllViewController];
    //给tabbar的item赋值
    [self setAllTabbarItemsValue];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(publishButtonClick) name:publishBtnClick object:nil];

    
}

//创建tabbar
-(void)createdTabbar {
    GWFTabbar *tabBar = [[GWFTabbar alloc] init];
    
    [self setValue:tabBar forKey:@"tabBar"];
}
-(void) addAllViewController {
    //精华
    GWFHomeViewController *essenceVC = [[GWFHomeViewController alloc] init];
    GWFNavigationController *navEssence = [[GWFNavigationController alloc] initWithRootViewController:essenceVC];
    [self addChildViewController:navEssence];
    //新帖
    GWFDiscoverViewController *newInvitationVC = [[GWFDiscoverViewController alloc] init];
    GWFNavigationController *navNewInvitation = [[GWFNavigationController alloc] initWithRootViewController:newInvitationVC];
    [self addChildViewController:navNewInvitation];
    //关注
    GWFMeViewController *friendsTrendVC = [[GWFMeViewController alloc] init];
    GWFNavigationController *navfriendsTrend = [[GWFNavigationController alloc] initWithRootViewController:friendsTrendVC];
    [self addChildViewController:navfriendsTrend];

}

-(void)setAllTabbarItemsValue {
    GWFNavigationController *navEssence = self.childViewControllers[0];
    navEssence.tabBarItem.image = [UIImage imageOriginalWithUIImageName:@"tabBar_essence_icon"];
    navEssence.tabBarItem.selectedImage = [UIImage imageOriginalWithUIImageName:@"tabBar_essence_click_icon"];
    navEssence.tabBarItem.title = @"首页";
    
    GWFNavigationController *navNewInvitation = self.childViewControllers[1];
    navNewInvitation.tabBarItem.image = [UIImage imageOriginalWithUIImageName:@"tabBar_new_icon"];
    navNewInvitation.tabBarItem.selectedImage = [UIImage imageOriginalWithUIImageName:@"tabBar_new_click_icon"];
    navNewInvitation.tabBarItem.title = @"圈子";
    
    GWFNavigationController *navfriendsTrend = self.childViewControllers[2];
    navfriendsTrend.tabBarItem.image = [UIImage imageOriginalWithUIImageName:@"tabBar_friendTrends_icon"];
    navfriendsTrend.tabBarItem.selectedImage = [UIImage imageOriginalWithUIImageName:@"tabBar_friendTrends_click_icon"];
    navfriendsTrend.tabBarItem.title = @"我的";
    
}

////点击发布按钮
//-(void)publishButtonClick {
//    //发布
//    GWFPublishViewController *publishVC = [[GWFPublishViewController alloc] init];
//    [self presentViewController:publishVC animated:YES completion:^{}];
//}

@end
