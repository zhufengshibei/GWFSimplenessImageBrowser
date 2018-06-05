//
//  GWFImageBrowserViewController.h
//  GWFImageBrowser
//
//  Created by user on 2018/5/2.
//  Copyright © 2018年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GWFImageBrowserViewController : UIViewController

@property (nonatomic, assign) NSInteger imageIndex;

// 图片数据源
@property (nonatomic, strong) NSArray *dataArray;

@end
