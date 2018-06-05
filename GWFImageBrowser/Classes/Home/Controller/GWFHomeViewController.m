//
//  HomeViewController.m
//  GWFImageBrowser
//
//  Created by user on 2018/4/24.
//  Copyright © 2018年 user. All rights reserved.
//

#import "GWFHomeViewController.h"
#import "GWFImageBrowserViewController.h"


static NSString *const kReuseIdentifierOfCell = @"kReuseIdentifierOfCell";
static NSString *const kReuseIdentifierOfHeader = @"kReuseIdentifierOfHeader";
static int tagOfImageOfCell = 1000;
static int tagOfImageOfLabel = 1001;
static int tagOfLabelOfHeader = 2000;

@interface GWFHomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate> {
    BOOL  _isPresentVC;
}

@property (nonatomic,strong) NSArray *localDArray;
@property (nonatomic,strong) NSArray *dataArray;

@property (nonatomic,strong) UICollectionView *collectionView;

@property(strong,nonatomic)UIWindow *window;
@property(strong,nonatomic)UIButton *button;

@end

@implementation GWFHomeViewController

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
    
    self.title = @"首页";
    [self.view addSubview:self.collectionView];
}

#pragma mark ---  collectionView 的数据源方法
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.localDArray.count;
    } else {
        return self.dataArray.count;
    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kReuseIdentifierOfCell forIndexPath:indexPath];
    
    UIImageView *imageView = [cell.contentView viewWithTag:tagOfImageOfCell];
    UILabel *label = [cell.contentView viewWithTag:tagOfImageOfLabel];
    if (!imageView) {
        CGFloat height = cell.contentView.bounds.size.height, width = cell.contentView.bounds.size.width;
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;
        NSString *tag = [[NSString stringWithFormat:@"%ld",indexPath.section+1] stringByAppendingString:[NSString stringWithFormat:@"%ld",indexPath.row]];
        imageView.tag = [tag integerValue];
        cell.tag = [tag integerValue];
        [cell.contentView addSubview:imageView];
        CGFloat labelWidth = 34, labelHeight = 25;
        label = [[UILabel alloc] initWithFrame:CGRectMake(width-labelWidth, height-labelHeight, labelWidth, labelHeight)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:14];
        label.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        label.layer.cornerRadius = 5;
        label.layer.masksToBounds = YES;
        label.tag = tagOfImageOfLabel;
        [cell.contentView addSubview:label];
    }
    label.hidden = YES;
    if (indexPath.section == 0) { // 本地的图片
        UIImage *image = [UIImage imageNamed:self.localDArray[indexPath.row]];
        if (image.size.width > 3500 || image.size.height > 3500) {
            label.hidden = NO;
            label.text = @"大图";
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // 大图等比例缩小
                UIImage *result = [UIImage scaleToSizeWithImage:image size:CGSizeMake(800, image.size.height / image.size.width*800)];
                GWF_MAINTHREAD_ASYNC(^{
                    imageView.image = result;
                })
            });
        } else {
            imageView.image = image;
        }
        
    } else { // 网络图片
        NSString *urlStr = self.dataArray[indexPath.row];
        if ([urlStr hasSuffix:@".gif"]) {
            label.hidden = NO;
            label.text = @"gif";
        }
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.row]]];
    }
    
    return cell;
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kReuseIdentifierOfHeader forIndexPath:indexPath];
        
        UILabel *label = [reusableView viewWithTag:tagOfLabelOfHeader];
        if (!label) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
            lineView.backgroundColor = RGBACOLOR(241, 241, 241, 1.0);
            [reusableView addSubview:lineView];
            
            label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView.frame), reusableView.bounds.size.width, reusableView.bounds.size.height-10)];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor orangeColor];
            label.backgroundColor = [UIColor whiteColor];
            label.font = [UIFont boldSystemFontOfSize:17];
            label.tag = tagOfLabelOfHeader;
            [reusableView addSubview:label];
        }
        label.text = indexPath.section ? @"网络图片" : @"本地图片";
        return reusableView;
    }
    return nil;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(SCREEN_WIDTH, 64);
}
#pragma mark ---  UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    _isPresentVC = YES;
    [(AppDelegate*)[UIApplication sharedApplication].delegate setIsPresent:_isPresentVC] ;
    
    // 区分点击的是 本地图片 还是 网络图片
    if (indexPath.section == 0) { // 点击本地图片
        [self showLocalImageWithBigTouchIndexPath:indexPath];
    } else {  // 点击网络图片
        [self showWebImageWithBigTouchIndexPath:indexPath];
    }
}
// 点击浏览本地图片
-(void)showLocalImageWithBigTouchIndexPath:(NSIndexPath *)indexPath {
    
    GWFImageBrowserViewController *imageBrowserVC = [[GWFImageBrowserViewController alloc] init];
    imageBrowserVC.imageIndex = indexPath.row;
    imageBrowserVC.dataArray = self.localDArray;
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.type = @"Cube";
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self presentViewController:imageBrowserVC animated:NO completion:nil];
}
// 点击浏览网络图片
-(void)showWebImageWithBigTouchIndexPath:(NSIndexPath *)indexPath {
    
    GWFImageBrowserViewController *imageBrowserVC = [[GWFImageBrowserViewController alloc] init];
    imageBrowserVC.imageIndex = indexPath.row;
    imageBrowserVC.dataArray = self.dataArray;
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.type = @"Cube";
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self presentViewController:imageBrowserVC animated:NO completion:nil];
}

-(void)jumpButton {
    GWFCommentViewController *commentVC= [[GWFCommentViewController alloc] init];
    [self.navigationController pushViewController:commentVC animated:YES];
}

#pragma mark ---  懒加载collectionView
-(UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CELLSIZE;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsZero;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = RGBACOLOR(241, 241, 241, 1.0);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        // 注册 collectionView 的头视图和 cell
        [_collectionView registerClass:UICollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kReuseIdentifierOfHeader];
        [_collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:kReuseIdentifierOfCell];
    }
    return _collectionView;
}
#pragma mark ---  懒加载本地图片数组
-(NSArray *)localDArray {
    if (!_localDArray) {
        _localDArray = @[@"localImage0", @"localImage1", @"localImage3", @"localImage2", @"localImage4", @"localImage5", @"localImage6", @"localImage8", @"localBigImage0",@"timg.gif"];
    }
    return _localDArray;
}
#pragma mark ---  懒加载网络图片数组
-(NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[
                       @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1524118687954&di=d92e4024fe4c2e4379cce3d3771ae105&imgtype=0&src=http%3A%2F%2Fimg3.duitang.com%2Fuploads%2Fitem%2F201605%2F18%2F20160518181939_nCZWu.gif",
                       @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1524118772581&di=29b994a8fcaaf72498454e6d207bc29a&imgtype=0&src=http%3A%2F%2Fimglf2.ph.126.net%2F_s_WfySuHWpGNA10-LrKEQ%3D%3D%2F1616792266326335483.gif",
                       @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1524118803027&di=beab81af52d767ebf74b03610508eb36&imgtype=0&src=http%3A%2F%2Fe.hiphotos.baidu.com%2Fbaike%2Fpic%2Fitem%2F2e2eb9389b504fc2995aaaa1efdde71190ef6d08.jpg",
                       @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1524118823131&di=aa588a997ac0599df4e87ae39ebc7406&imgtype=0&src=http%3A%2F%2Fimg3.duitang.com%2Fuploads%2Fitem%2F201605%2F08%2F20160508154653_AQavc.png",
                       @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=722693321,3238602439&fm=27&gp=0.jpg",
                       @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1524118892596&di=5e8f287b5c62ca0c813a548246faf148&imgtype=0&src=http%3A%2F%2Fwx1.sinaimg.cn%2Fcrop.0.0.1080.606.1000%2F8d7ad99bly1fcte4d1a8kj20u00u0gnb.jpg",
                       @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1524118914981&di=7fa3504d8767ab709c4fb519ad67cf09&imgtype=0&src=http%3A%2F%2Fimg5.duitang.com%2Fuploads%2Fitem%2F201410%2F05%2F20141005221124_awAhx.jpeg",
                       @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1524118934390&di=fbb86678336593d38c78878bc33d90c3&imgtype=0&src=http%3A%2F%2Fi2.hdslb.com%2Fbfs%2Farchive%2Fe90aa49ddb2fa345fa588cf098baf7b3d0e27553.jpg",
                       @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1524118984884&di=7c73ddf9d321ef94a19567337628580b&imgtype=0&src=http%3A%2F%2Fimg5q.duitang.com%2Fuploads%2Fitem%2F201506%2F07%2F20150607185100_XQvYT.jpeg"
                       ];
    }
    return _dataArray;
}
@end

