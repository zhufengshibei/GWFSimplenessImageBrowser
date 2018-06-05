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

#import "MoviePlayerViewController.h"


@interface GWFDiscoverViewController ()<UITableViewDelegate,UITableViewDataSource,GWFDiscoverCellDelegate> {
    BOOL  _isPresentVC;
}

@property (nonatomic,strong) UITableView  *tableView;

@property (nonatomic,strong) UIImageView  *defaultView;
@property (nonatomic,strong) UIButton  *refreshBtn;

@property (nonatomic,strong) NSArray  *dataArray;

@property (nonatomic,strong) MPMoviePlayerViewController *playerVC;

@end

@implementation GWFDiscoverViewController

-(NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}
-(UIImageView *)defaultView {
    if (!_defaultView) {
        _defaultView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        _defaultView.frame = self.view.bounds;
        _defaultView.userInteractionEnabled = YES;
        _refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _refreshBtn.frame = CGRectMake((SCREEN_WIDTH-GENERAL_SIZE(280))/2, SCREEN_HEIGHT/3, GENERAL_SIZE(280), GENERAL_SIZE(280));
        [_refreshBtn setImage:[UIImage imageNamed:@"ic_refresh"] forState:UIControlStateNormal];
        _refreshBtn.layer.cornerRadius = GENERAL_SIZE(280)/2;
        _refreshBtn.layer.masksToBounds = YES;
        [_defaultView addSubview:_refreshBtn];
        [_refreshBtn addTarget:self action:@selector(reloadViewData) forControlEvents:UIControlEventTouchUpInside];
        UILabel *promtLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT/3+GENERAL_SIZE(220), SCREEN_WIDTH, GENERAL_SIZE(40))];
        promtLabel.text = @"点击刷新试试看";
        promtLabel.textColor = RGBACOLOR(0, 117, 211, 1.0);
        promtLabel.textAlignment = NSTextAlignmentCenter;
        promtLabel.font = LabelFont(34);
        [_defaultView addSubview:promtLabel];
    }
    return _defaultView;
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpButton) name:@"JUMPOTHERCONTROLLER" object:nil];
    _isPresentVC = NO;
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (_isPresentVC) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HIDDENTHEBUTTON" object:nil];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"JUMPOTHERCONTROLLER" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"圈子";
    
    [self.view addSubview:self.tableView];
    self.defaultView.hidden = YES;
    [self.view addSubview:self.defaultView];
    
    [self setupLoadingView];
    [self loadDataState:@"正在加载数据..." done:@"数据加载成功!"];
}
-(void)reloadViewData {
    self.defaultView.hidden = YES;
    [self setupLoadingView];
    [self loadDataState:@"正在加载数据..." done:@"数据加载成功!"];
    [self loadingFailed];
}
- (void)loadDataState:(NSString *)promt done:(NSString *)doneStr {
    [MBProgressHUD showMessag:promt toView:[UIApplication sharedApplication].keyWindow];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.dataArray = [[GWFDataBaseManager shareManager] loadDataForTopDetails];
        
        
        [UIView animateWithDuration:0.5 animations:^{
            [self loadingSuccess];
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            if (self.dataArray.count == 0) {
                [MBProgressHUD showError:@"暂无数据" toView:self.view];
                self.defaultView.hidden = NO;
            } else {
                // 数组逆序
                self.dataArray = [[self.dataArray reverseObjectEnumerator] allObjects];
                [MBProgressHUD showSuccess:doneStr toView:[UIApplication sharedApplication].keyWindow];
                self.defaultView.hidden = YES;
            }
            [self.tableView reloadData];
        }];
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
-(void)didImageItemWithIndexPath:(NSIndexPath *)currentIndexPath imageArray:(NSMutableArray *)imageArr dataModel:(GWFCommentModel *)model attachName:(NSString *)attachName firstImage:(UIImage *)firstImage {
    _isPresentVC = YES;
    [(AppDelegate*)[UIApplication sharedApplication].delegate setIsPresent:_isPresentVC];
    
    if ([model.topType isEqualToString:@"1"]) {
        
        GWFImageBrowserViewController *imageBrowserVC = [[GWFImageBrowserViewController alloc] init];
        imageBrowserVC.imageIndex = currentIndexPath.item;
        imageBrowserVC.dataArray = imageArr;
        CATransition *transition = [CATransition animation];
        transition.duration = 0.25f;
        transition.type = @"";
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [self presentViewController:imageBrowserVC animated:NO completion:nil];
    } else if ([model.topType isEqualToString:@"2"]) {
        
        NSString *urlStr = [kVideoPath stringByAppendingPathComponent:attachName];
        NSURL *URL = [NSURL fileURLWithPath:urlStr];
#pragma mark --- 视频播放方法一 : 使用 MediaPlayer 播放视频
        self.playerVC = [[MPMoviePlayerViewController alloc] initWithContentURL:URL];
        // 移除播放完成后自动关闭播放器的观察者
        [[NSNotificationCenter defaultCenter] removeObserver:self.playerVC name:MPMoviePlayerPlaybackDidFinishNotification object:self.playerVC.moviePlayer];
        // 添加播放完成后是否关闭播放器的观察者
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(finishedPlay:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.playerVC.moviePlayer];
        [self presentMoviePlayerViewControllerAnimated:self.playerVC];
        
#pragma mark --- 视频播放方法二 : 使用 AVPlayer 播放视频
        /**
         //视频播放
         MoviePlayerViewController *movie = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MoviePlayerViewController"];
         movie.videoURL = URL;
         movie.videoName = [attachName stringByReplacingOccurrencesOfString:@".mp4" withString:@""];
         // 获取视频首帧图片用于下一页展示
         movie.firstImage = firstImage;
         [self.navigationController pushViewController:movie animated:YES];
         */
    }
}
// 播放完成后手动关闭播放器
-(void)finishedPlay:(NSNotification*)aNotification {
    // 循环播放
    [self.playerVC.moviePlayer play];
    
    // 点击完成关闭播放器
    int value = [[aNotification.userInfo valueForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    if (value == MPMovieFinishReasonUserExited) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOWTHEBUTTON" object:nil];
        [self dismissMoviePlayerViewControllerAnimated];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
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
