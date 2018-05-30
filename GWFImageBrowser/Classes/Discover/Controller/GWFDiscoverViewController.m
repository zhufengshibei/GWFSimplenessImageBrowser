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
    
    self.title = @"圈子";
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.tableView];
    
    [self loadDataState:@"正在加载数据..." done:@"数据加载成功!"];
    
}

- (void)loadDataState:(NSString *)promt done:(NSString *)doneStr {
    
    [MBProgressHUD showMessag:promt toView:[UIApplication sharedApplication].keyWindow];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];

        [MBProgressHUD showSuccess:doneStr toView:[UIApplication sharedApplication].keyWindow];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    
            self.dataArray = [[GWFDataBaseManager shareManager] loadDataForTopDetails];
            // 数组逆序
            self.dataArray = [[self.dataArray reverseObjectEnumerator] allObjects];
            [self.tableView reloadData];
            
        });
    });
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
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GWFCommentModel *model = self.dataArray[indexPath.row];
    [[GWFDataBaseManager shareManager] removeCurrentDataWithTopicId:model.topID];
    [self loadDataState:@"正在删除数据..." done:@"数据删除成功!"];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    GWFCommentModel *model = self.dataArray[indexPath.row];
    
    CGFloat H = 0.0;
    if (model.imageArray.count > 0 || model.videoArray.count > 0) {

        //重新计算collectionview的高度  = 总行数(rows) * itemH
        // rows = (item的总个数(count) - 1) / 列数(column) + 1
        NSInteger count = 0;
        
        if ([model.topType isEqualToString:@"1"]) {
            count = model.imageArray.count;
        } else if ([model.topType isEqualToString:@"2"]) {
            count = model.videoArray.count;
        }
        
        NSInteger rows = (count - 1) / 3 + 1;

        CGFloat M = 0.0;
        if (count > 3) {
            M = GENERAL_SIZE(10);
        } else {
            M = 0;
        }
        
        CGFloat collectionViewH = rows * SCREEN_WIDTH/3;
        H += model.cellHeight;
        H += collectionViewH;
        return H-M;
    } else {
        return model.cellHeight;
    }
}

#pragma mark --- GWFDiscoverCellDelegate  点击图片加载图片浏览器
-(void)didImageItemWithIndexPath:(NSIndexPath *)currentIndexPath imageArray:(NSMutableArray *)imageArr dataModel:(GWFCommentModel *)model {
    if ([model.topType isEqualToString:@"1"]) {
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
    } else if ([model.topType isEqualToString:@"2"]) {
        [MBProgressHUD showError:@"正在努力开发中..." toView:self.view];
    }
    
}

-(void)jumpButton {
    GWFCommentViewController *commentVC= [[GWFCommentViewController alloc] init];
    commentVC.doneBlack = ^{
        [self loadDataState:@"正在加载数据..." done:@"数据加载成功!"];
    };
    [self.navigationController pushViewController:commentVC animated:YES];
}

#pragma mark --- 懒加载
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

@end
