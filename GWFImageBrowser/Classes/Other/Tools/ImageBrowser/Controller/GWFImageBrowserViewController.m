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
    
    [cell setImageString:self.dataArray[indexPath.row]];
    
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
     int currentPage = floor((_browserCollectionView.contentOffset.x - SCREEN_WIDTH / 2) / SCREEN_WIDTH) + 2;
    indexLabel.text = [NSString stringWithFormat:@"%d / %ld",currentPage,self.dataArray.count];
    
}

#pragma mark ---  懒加载collectionView
-(UICollectionView *)browserCollectionView {
    if (!_browserCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-80);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;

        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _browserCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:flowLayout];
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
    indexLabel.center = CGPointMake(self.view.center.x, 15);
    indexLabel.text = [NSString stringWithFormat:@"%ld / %ld",self.imageIndex+1,self.dataArray.count];
    indexLabel.textColor = [UIColor whiteColor];
    indexLabel.font = [UIFont systemFontOfSize:18];
    indexLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:indexLabel];
    
    

}

-(void)longPressSaveImageToAlbum:(id)objc string:(NSString *)imageStr {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"保存到本地相册" message:nil preferredStyle:UIAlertControllerStyleAlert];
    //保存图片
    [alertVC addAction:[UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([imageStr hasSuffix:@".gif"]) {
            NSData *imageData = (NSData *)objc;
            // 保存到本地相册
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            [library writeImageDataToSavedPhotosAlbum:imageData metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
                
                if (error) {
                    NSLog(@"保存过程中发生错误，错误信息:%@",error.localizedDescription);
                    [MBProgressHUD showError:@"图片保存失败" toView:self.view];
                } else {
                    NSLog(@"图片保存成功");
                    [MBProgressHUD showSuccess:@"图片保存成功" toView:self.view];
                }
            }] ;
            
        } else {
            UIImage *image = (UIImage *)objc;
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
    }]];

    //取消
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}
#pragma mark - 自定义方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        NSLog(@"保存过程中发生错误，错误信息:%@",error.localizedDescription);
        [MBProgressHUD showError:@"图片保存失败" toView:self.view];
    } else {
        NSLog(@"图片保存成功");
        [MBProgressHUD showSuccess:@"图片保存成功" toView:self.view];
    }
}

- (void)dissMissVC {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOWTHEBUTTON" object:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
}

// 返回值要必须为NO
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}



@end























