//
//  GWFCommentViewController.m
//  GWFImageBrowser
//
//  Created by user on 2018/5/2.
//  Copyright © 2018年 user. All rights reserved.
//

#define TEXTCOLOR RGBACOLOR(65, 65, 65, 1.0)
#define TEXTFONT [UIFont systemFontOfSize:16.0]

#import "GWFCommentViewController.h"

@interface GWFCommentViewController () {
    UITextField  *_titleTF;
    UITextView   *_contentTextView;
}

@end

@implementation GWFCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"发布帖子";
    
    [self setupSubViews];
}
// 发表评论页面UI搭建
- (void)setupSubViews {
    [self setupRightButton];
    [self setupContentSubViews];
}

- (void)setupContentSubViews {
    // 创建控件
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"标题:";
    titleLabel.textColor = TEXTCOLOR;
    titleLabel.font = TEXTFONT;
    [self.view addSubview:titleLabel];
    
    _titleTF = [[UITextField alloc] init];
    _titleTF.textColor = TEXTCOLOR;
    _titleTF.placeholder = @"请输入帖子标题...";
    _titleTF.font = TEXTFONT;
    _titleTF.layer.cornerRadius = GENERAL_SIZE(5);
    _titleTF.layer.masksToBounds = YES;
    _titleTF.layer.borderWidth = 0.5;
    _titleTF.layer.borderColor = TEXTCOLOR.CGColor;
    //左端缩进15像素
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, GENERAL_SIZE(10), GENERAL_SIZE(30))];
    _titleTF.leftView = view;
    _titleTF.leftViewMode = UITextFieldViewModeAlways;
    
    [self.view addSubview:_titleTF];

    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor =RGBACOLOR(246, 246, 246, 1.0);
    [self.view addSubview:lineView];
    
    _contentTextView = [[UITextView alloc] init];
    _contentTextView.textColor = TEXTCOLOR;
    _contentTextView.font = TEXTFONT;
    _contentTextView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_contentTextView];
    
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = @"请输入文本...";
    placeHolderLabel.textColor = RGBACOLOR(201, 201, 201, 1.0);
    placeHolderLabel.font = TEXTFONT;
    [_contentTextView addSubview:placeHolderLabel];
    
    
    // 设置控件布局
    [self setupLayoutControlsWithTitleLabel:titleLabel titleTF:_titleTF lineView:lineView contentTextView:_contentTextView placeHolderLabel:placeHolderLabel];
}

- (void)setupLayoutControlsWithTitleLabel:(UILabel *)titleLabel titleTF:(UITextField *)_titleTF lineView:(UIView *)lineView contentTextView:(UITextView *)_contentTextView placeHolderLabel:(UILabel *)placeHolderLabel {
    CGFloat margin = GENERAL_SIZE(30);
    CGFloat Y = subViewsY + margin;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(Y);
        make.left.equalTo(self.view.mas_left).offset(GENERAL_SIZE(40));
        make.width.mas_equalTo(GENERAL_SIZE(80));
    }];
    [_titleTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel);
        make.left.equalTo(titleLabel.mas_right).offset(GENERAL_SIZE(20));
        make.right.equalTo(self.view.mas_right).offset(-GENERAL_SIZE(40));
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(margin);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(GENERAL_SIZE(2));
    }];
    [_contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(margin);
        make.left.equalTo(titleLabel);
        make.right.equalTo(_titleTF);
        make.height.mas_equalTo(GENERAL_SIZE(241));
    }];
    [placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentTextView);
        make.left.equalTo(_contentTextView.mas_left).offset(GENERAL_SIZE(GENERAL_SIZE(20)));
        make.height.mas_equalTo(GENERAL_SIZE(60));
    }];
}

- (void)setupRightButton {
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:RGBACOLOR(4, 140, 248, 1.0) forState:UIControlStateNormal];
    sendBtn.frame = CGRectMake(0, 0, 44, 44);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sendBtn];
    
    [sendBtn addTarget:self action:@selector(sendContent:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark --  发送按钮的点击事件
- (void)sendContent:(id)sender {
    
}

@end

















