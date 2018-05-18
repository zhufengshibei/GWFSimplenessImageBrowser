//
//  MBProgressHUD+Add.h
//  视频客户端
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Add)
/**
 *  类似错误信息的提示框(没有菊花的试图)
 *
 *  @param text 提示内容
 *  @param icon 提示的图片(原本菊花换成自己给的图片)
 *  @param view 加载的试图
 */
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view;


+ (void)showError:(NSString *)error toView:(UIView *)view;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

/**
 *  显示加载中的试图(有菊花)
 *
 *  @param message 内容
 *  @param view    加载的试图
 *
 *  @return 返回一个View
 */
+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view;




@end
