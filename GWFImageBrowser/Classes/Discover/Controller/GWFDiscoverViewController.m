//
//  DiscoverViewController.m
//  GWFImageBrowser
//
//  Created by user on 2018/4/24.
//  Copyright © 2018年 user. All rights reserved.
//

#import "GWFDiscoverViewController.h"
#import "GWFCommentModel.h"
#import "GWFDiscoverCell.h"

#import "GWFImageBrowserViewController.h"

@interface GWFDiscoverViewController ()<UITableViewDelegate,UITableViewDataSource,GWFDiscoverCellDelegate> {
    BOOL  _isPresentVC;
}

@property (nonatomic,strong) UITableView  *tableView;


@property (nonatomic,strong) NSArray  *dataArray;

@end

@implementation GWFDiscoverViewController

-(NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    COMMENTVCNOTIFICATIONJUMP
    
    
    _isPresentVC = NO;
    [self loadData];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (_isPresentVC) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HIDDENTHEBUTTON" object:nil];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发现";
    self.view.backgroundColor = [UIColor brownColor];

    [self.view addSubview:self.tableView];
    
    
}

- (void)loadData {
    
    
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    id result = [defaults objectForKey:@"TESTDATA"];
//
//    GWFCommentModel *model = [GWFCommentModel mj_objectWithKeyValues:result];
//
//    NSMutableArray *imageA = [NSMutableArray array];
//
//    //    NSLog(@"imageStrArr === %@",model.imageArray);
//    for (NSString *imageStr in model.imageArray) {
//        NSData *imageData = [self transStrHexToData:imageStr];
//        UIImage *image = [UIImage imageWithData:imageData];
//        [imageA addObject:image];
//    }
//
//    [MBProgressHUD showMessag:@"正在加载数据..." toView:[UIApplication sharedApplication].keyWindow];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
//
//        [MBProgressHUD showSuccess:@"数据加载成功!" toView:[UIApplication sharedApplication].keyWindow];
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    
            self.dataArray = [[GWFDataBaseManager shareManager] loadDataForTopDetails];
            [self.tableView reloadData];
            
//        });
//    });
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GWFDiscoverCell *cell = [GWFDiscoverCell cellWithTableView:tableView];
    cell.delegate = self;
    GWFCommentModel *model = self.dataArray[indexPath.row];
    [cell setCommentModel:model];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    GWFCommentModel *model = self.dataArray[indexPath.row];
    
    CGFloat H = 0.0;
    if (model.imageArray.count > 0) {

        //重新计算collectionview的高度  = 总行数(rows) * itemH
        // rows = (item的总个数(count) - 1) / 列数(column) + 1
        NSInteger count = model.imageArray.count;
        NSInteger rows = (count - 1) / 3 + 1;

        CGFloat collectionViewH = rows * SCREEN_WIDTH/3;
        H += model.cellHeight;
        H += collectionViewH;
        return H;
    } else {
        return model.cellHeight;
    }
}

#pragma mark --- GWFDiscoverCellDelegate
-(void)didImageItemWithIndexPath:(NSIndexPath *)currentIndexPath imageArray:(NSMutableArray *)imageArr {
    _isPresentVC = YES;
    [(AppDelegate*)[UIApplication sharedApplication].delegate setIsPresent:_isPresentVC] ;
    
    GWFImageBrowserViewController *imageBrowserVC = [[GWFImageBrowserViewController alloc] init];
    imageBrowserVC.imageIndex = currentIndexPath.item;
    imageBrowserVC.isLocal = YES;
    imageBrowserVC.dataArray = imageArr;
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.type = @"Cube";
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self presentViewController:imageBrowserVC animated:NO completion:nil];
}

COMMENTVCNOTIFICATIONJUMPCLICK

#pragma mark --- 懒加载
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

@end
