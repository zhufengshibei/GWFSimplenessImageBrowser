//
//  GWFBaseViewController.m
//  GWFImageBrowser
//
//  Created by user on 2018/5/31.
//  Copyright © 2018年 user. All rights reserved.
//

#import "GWFBaseViewController.h"

@interface GWFBaseViewController ()

@property (nonatomic,strong) UIView  *defaultView;
@property (nonatomic,retain) UIImageView *imageView;

@end

@implementation GWFBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BACKGROUNDCOLOR;
    
    self.defaultView.hidden = YES;
    [self.view addSubview:self.defaultView];
}
- (void)setupLoadingView {
    if (!_defaultView) {
        _defaultView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _defaultView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_defaultView];
        
        _imageView = [[UIImageView alloc]init];
        [_imageView setImage:[UIImage imageNamed:@"ic_loading"]];
        [_defaultView addSubview:_imageView];
        
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.defaultView);
            make.centerY.equalTo(self.defaultView).offset(-GENERAL_SIZE(120));
        }];
        
        
    }
}
-(void)loadingSuccess{
    _defaultView.hidden = YES;
}

-(void)loadingFailed{
    _defaultView.hidden = NO;
    
}

-(void)reloadViewData{
    
}

@end
