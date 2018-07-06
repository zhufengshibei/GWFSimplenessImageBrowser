//
//  MeViewController.m
//  GWFImageBrowser
//
//  Created by user on 2018/4/24.
//  Copyright © 2018年 user. All rights reserved.
//

#import "GWFMeViewController.h"
#import "GWFSettingViewController.h"
#import "GWFAboutViewController.h"

@interface GWFMeViewController () {
    BOOL  _isPresentVC;
}

@end

@implementation GWFMeViewController

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (_isPresentVC) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HIDDENTHEBUTTON" object:nil];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"JUMPOTHERCONTROLLER" object:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpButton) name:@"JUMPOTHERCONTROLLER" object:nil];
    _isPresentVC = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的";
    
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

-(void)jumpButton {
    GWFCommentViewController *commentVC= [[GWFCommentViewController alloc] init];
    [self.navigationController pushViewController:commentVC animated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    GWFAboutViewController *aboutVC = [[GWFAboutViewController alloc] init];
    
//    _isPresentVC = YES;
//    [(AppDelegate*)[UIApplication sharedApplication].delegate setIsPresent:_isPresentVC];
//    [self presentViewController:aboutVC animated:YES completion:nil];
    
    [self.navigationController pushViewController:aboutVC animated:YES];
}

@end
