//
//  UIViewController+Basic.h
//  KPChina
//
//  Created by PC开发 on 2017/5/26.
//  Copyright © 2017年 PC开发. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Basic)

- (void)willMoveToParentViewController:(UIViewController*)parent;
- (void)didMoveToParentViewController:(UIViewController*)parent;

/// 将十六进制的字符串转化为NSData
- (NSData *)transStrHexToData:(NSString *)strHex;


@end
