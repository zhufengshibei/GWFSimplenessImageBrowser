//
//  GWFBaseViewController.h
//  GWFImageBrowser
//
//  Created by user on 2018/5/31.
//  Copyright © 2018年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GWFBaseViewController : UIViewController

-(void)setupLoadingView;

-(void)loadingSuccess;
-(void)loadingFailed;

-(void)reloadViewData;

@end
