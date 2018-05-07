//
//  UIBarButtonItem+GWFItem.m
//  BaiSiBudeJie
//
//  Created by zhufeng on 16/12/17.
//  Copyright © 2016年 zhufeng. All rights reserved.
//

#import "UIBarButtonItem+GWFItem.h"

@implementation UIBarButtonItem (GWFItem)

+ (UIBarButtonItem *)setBarButtonItemNormalImage:(UIImage *)normalImage HighlightedImage:(UIImage *)highlightedImage addTarget:(id)target action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button sizeToFit];
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:highlightedImage forState:UIControlStateHighlighted];
    UIView *containView = [[UIView alloc] initWithFrame:button.bounds];
    [containView addSubview:button];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:containView];
}

+ (UIBarButtonItem *)setBarButtonItemNormalImage:(UIImage *)normalImage selectImage:(UIImage *)selectImage addTarget:(id)target action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button sizeToFit];
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:selectImage forState:UIControlStateSelected];
    UIView *containView = [[UIView alloc] initWithFrame:button.bounds];
    [containView addSubview:button];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:containView];
}

+ (UIBarButtonItem *)setBackButtonItemNormalImage:(UIImage *)normalImage HighlightedImage:(UIImage *)highlightedImage addTarget:(id)target action:(SEL)action Title:(NSString *)title {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:title forState:UIControlStateNormal];
    [backButton setImage:normalImage forState:UIControlStateNormal];
    [backButton setImage:highlightedImage forState:UIControlStateHighlighted];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [backButton setContentEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    [backButton sizeToFit];
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    
    
}

@end
