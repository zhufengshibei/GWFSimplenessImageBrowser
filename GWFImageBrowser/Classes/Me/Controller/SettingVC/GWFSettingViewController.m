//
//  GWFSettingViewController.m
//  GWFImageBrowser
//
//  Created by user on 2018/5/3.
//  Copyright © 2018年 user. All rights reserved.
//

#import "GWFSettingViewController.h"

@interface GWFSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation GWFSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self.view addSubview:self.tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GWFSettingViewController"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"GWFSettingViewController"];
    }
    cell.textLabel.text = @"清除缓存";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //清除内存使用SDWebImage缓存的图片
//    [[SDImageCache sharedImageCache] clearMemory];
    //清除沙盒中所有使用SDWebImage缓存的缓存图片
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        
    }];
    //    //清除沙盒中所有使用SDWebImage缓存的已过期(缓存时长超过一星期(60*60*24*7))的图片
    //    [[SDImageCache sharedImageCache] cleanDisk];
    //设置缓存时长为 一个月
    //    [SDImageCache sharedImageCache].maxCacheAge = 30 * 24 * 60 * 60;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
