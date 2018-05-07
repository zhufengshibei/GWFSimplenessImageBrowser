//
//  GWFTabbar.m
//  BaiSiBudeJie
//
//  Created by zhufeng on 16/12/17.
//  Copyright © 2016年 zhufeng. All rights reserved.
//

#import "GWFTabbar.h"

@interface GWFTabbar ()

//@property (nonatomic,weak) UIButton *publishButton;

@property (nonatomic,weak) UIControl *preClickButton;

@end

@implementation GWFTabbar

//-(UIButton *)publishButton {
//    if (_publishButton == nil) {
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btn setBackgroundImage:[UIImage imageOriginalWithUIImageName:@"tabBar_publish_icon"] forState:UIControlStateNormal];
//        [btn setBackgroundImage:[UIImage imageOriginalWithUIImageName:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
//        btn.layer.cornerRadius = (self.gwf_height)/2.0;
//        btn.layer.masksToBounds = YES;
//        [btn sizeToFit];
//        self.publishButton = btn;
//
//        [self addSubview:btn];
//
//        [btn addTarget:self action:@selector(btnClicjDid) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _publishButton;
//}
//-(void)btnClicjDid {
//    NSLog(@"%s",__func__);
//
//    [[NSNotificationCenter defaultCenter] postNotificationName:publishBtnClick object:nil];
//
//}

//-(void)layoutSubviews {
//    [super layoutSubviews];
//    
//    CGFloat tapWidth = self.gwf_width / (self.items.count+1);
//    CGFloat x = 0;
//    int margin = 0;
//    
//    //遍历子控件
//    for (UIControl *tabBarButton in self.subviews) {
//        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
//            
//            if (margin == 0 && self.preClickButton == nil) {
//                self.preClickButton = tabBarButton;
//            }
//            
//            if (margin == 2) {
//                margin += 1;
//            }
//            x = margin * tapWidth;
//            
//            tabBarButton.frame = CGRectMake(x, 0, tapWidth, self.gwf_height);
//            
//            margin++;
//            
//            [tabBarButton addTarget:self action:@selector(tabBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        }
//    }
//    //设置发布按钮
//    self.publishButton.center = CGPointMake(self.gwf_width*0.5, self.gwf_height*0.5);
//}
//-(void)tabBarButtonClick:(UIControl *)tabBarButton {
//    //监听tabbar按钮的点击次数
//    //重复点击时执行
//    if (self.preClickButton == tabBarButton) {
//        
//        //重复点击tabbar 按钮时，发布一个通知，让各自的界面去处理操作
//        [[NSNotificationCenter defaultCenter] postNotificationName:tabbarButtonDidRepeatClickNotification object:nil userInfo:nil];
//    }
//    self.preClickButton = tabBarButton;
//}


@end
