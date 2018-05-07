//
//  UIBarButtonItem+GWFItem.h
//  BaiSiBudeJie
//
//  Created by zhufeng on 16/12/17.
//  Copyright © 2016年 zhufeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (GWFItem)

//普通与高亮
+ (UIBarButtonItem *)setBarButtonItemNormalImage:(UIImage *)normalImage HighlightedImage:(UIImage *)highlightedImage addTarget:(id)target action:(SEL)action;

//普通与选中
+ (UIBarButtonItem *)setBarButtonItemNormalImage:(UIImage *)normalImage selectImage:(UIImage *)selectImage addTarget:(id)target action:(SEL)action;

//图文混排返回按钮
+ (UIBarButtonItem *)setBackButtonItemNormalImage:(UIImage *)normalImage HighlightedImage:(UIImage *)highlightedImage addTarget:(id)target action:(SEL)action Title:(NSString *)title;

@end
