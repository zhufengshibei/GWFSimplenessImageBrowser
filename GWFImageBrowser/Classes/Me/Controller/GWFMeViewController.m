//
//  MeViewController.m
//  GWFImageBrowser
//
//  Created by user on 2018/4/24.
//  Copyright © 2018年 user. All rights reserved.
//

#import "GWFMeViewController.h"
#import "GWFSettingViewController.h"

@interface GWFMeViewController ()

@end

@implementation GWFMeViewController

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    COMMENTVCNOTIFICATIONJUMP
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupRightButton];
}



- (void)setupRightButton {
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingBtn setTitle:@"设置" forState:UIControlStateNormal];
    [settingBtn setTitleColor:RGBACOLOR(4, 140, 248, 1.0) forState:UIControlStateNormal];
    settingBtn.frame = CGRectMake(20, 20, 44, 44);
    
    [settingBtn addTarget:self action:@selector(didClickCancel) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingBtn];
}
- (void)didClickCancel {
    GWFSettingViewController *settingVC = [[GWFSettingViewController alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
}


COMMENTVCNOTIFICATIONJUMPCLICK

@end