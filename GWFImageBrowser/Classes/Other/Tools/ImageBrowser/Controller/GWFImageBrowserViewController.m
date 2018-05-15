//
//  GWFImageBrowserViewController.m
//  GWFImageBrowser
//
//  Created by user on 2018/5/2.
//  Copyright © 2018年 user. All rights reserved.
//

#import "GWFImageBrowserViewController.h"

#import "GWFImageBrowserCell.h"

@interface GWFImageBrowserViewController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,GWFImageBrowserCellDelegate> {

    UILabel      *indexLabel;
}
@property (nonatomic, strong) UICollectionView  *browserCollectionView;
@end

@implementation GWFImageBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.browserCollectionView];
    
    [self setupSubViews];
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GWFImageBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"browserCollectionView" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.delegate = self;
    [cell setIsLocal:self.isLocal];
    
    [cell setImageString:self.dataArray[indexPath.row]];
    
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
     int currentPage = floor((_browserCollectionView.contentOffset.x - SCREEN_WIDTH / 2) / SCREEN_WIDTH) + 2;
    indexLabel.text = [NSString stringWithFormat:@"%d / %ld",currentPage,self.dataArray.count];
    
    NSLog(@"==== %d",currentPage);
    
}

#pragma mark ---  懒加载collectionView
-(UICollectionView *)browserCollectionView {
    if (!_browserCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-80);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;

        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _browserCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 80, SCREEN_WIDTH, SCREEN_HEIGHT-80) collectionViewLayout:flowLayout];
        _browserCollectionView.backgroundColor = [UIColor clearColor];
        _browserCollectionView.dataSource = self;
        _browserCollectionView.delegate = self;
        _browserCollectionView.pagingEnabled = YES;
        // 注册 cell
        [_browserCollectionView registerClass:[GWFImageBrowserCell class] forCellWithReuseIdentifier:@"browserCollectionView"];
        
        _browserCollectionView.contentOffset = CGPointMake(SCREEN_WIDTH*self.imageIndex, 0);
    }
    return _browserCollectionView;
}


- (void)setupSubViews {
    
    // 索引
    indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    indexLabel.center = CGPointMake(self.view.center.x, 40);
    indexLabel.text = [NSString stringWithFormat:@"%ld / %ld",self.imageIndex+1,self.dataArray.count];
    indexLabel.textColor = [UIColor whiteColor];
    indexLabel.font = [UIFont systemFontOfSize:18];
    indexLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:indexLabel];

}

- (void)dissMissVC {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOWTHEBUTTON" object:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}



@end























