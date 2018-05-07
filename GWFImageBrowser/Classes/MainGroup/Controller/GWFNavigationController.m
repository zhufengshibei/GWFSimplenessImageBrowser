//
//  GWFNavigationController.m
//  BaiSiBudeJie
//
//  Created by zhufeng on 16/12/17.
//  Copyright © 2016年 zhufeng. All rights reserved.
//

#import "GWFNavigationController.h"

@interface GWFNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation GWFNavigationController

+(void)load {
    //设置导航栏标题字体大小样式
    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedIn:self, nil];
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
    [navBar setTitleTextAttributes:attrs];
    
    [navBar setBackgroundImage:[UIImage imageOriginalWithUIImageName:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
    navBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
    
    CGRect rect = navBar.frame;
    navBar.frame = CGRectMake(rect.origin.x,rect.origin.y,rect.size.width,200);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //恢复滑动返回手势，控制手势的触发时机 ，只有非根控制器才会触发滑动返回手势
    //仅设置 self.interactivePopGestureRecognizer.delegate = self; 只能滑动边沿返回上一层
    //    self.interactivePopGestureRecognizer.delegate = self;
    
    //设置 全屏滑动手势返回上一层
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
    
    //控制手势的触发时机
    pan.delegate = self;
    
    [self.view addGestureRecognizer:pan];
    
    
//    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
    
}

/**
 *  重写Push方法(隐藏底部的tabbar)
 *  统一设置返回按钮和跳转自动隐藏底部的tabbar
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count) { //避免一开始就隐藏了
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HIDDENTHEBUTTON" object:nil];
        
        viewController.hidesBottomBarWhenPushed = YES;
        
        //自定义返回按钮后，滑动返回的手势被其代理做了些别的事情，导致滑动返回的手势失效，所以需使self.interactivePopGestureRecognizer.delegate = nil; 恢复滑动返回功能
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem setBackButtonItemNormalImage:[UIImage imageOriginalWithUIImageName:@"navigationButtonReturn"] HighlightedImage:[UIImage imageOriginalWithUIImageName:@"navigationButtonReturnClick"] addTarget:self action:@selector(back) Title:@"返回"];
    }
    
    [super pushViewController:viewController animated:animated];
}
-(void)back {
    
    if (self.viewControllers.count == 2) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOWTHEBUTTON" object:nil];
    }

    [self popViewControllerAnimated:YES];
}

//决定手势是否触发
//如果返回 NO 则说明所有的手势都不触发
// self.childViewControllers.count > 1 表示根控制器不触发
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return self.childViewControllers.count > 1;
}



@end
