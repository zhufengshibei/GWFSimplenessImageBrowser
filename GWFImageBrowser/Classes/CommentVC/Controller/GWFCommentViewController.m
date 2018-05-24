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
#import "GWFAddButtonCell.h"
#import "GWFImageCell.h"
#import "GWFCommentModel.h"

#import "GWFImageBrowserViewController.h"

@interface GWFCommentViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate,UITextViewDelegate,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate> {
    UITextField  *_titleTF;
    UITextView   *_contentTextView;
    UILabel      *_placeHolderLabel;
    UIView       *lineView1;
    UIView       *_shawView;
}

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *bigDataArray;
@property (nonatomic,strong) NSMutableArray *assetsDataArray;

@property (nonatomic, strong)  ZYQAssetPickerController *pickerController;

@property (nonatomic,strong) UICollectionView *collectionView;;

@end

@implementation GWFCommentViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HIDDENTHEBUTTON" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"发布帖子";
    
    _dataArray = [NSMutableArray array];
    _bigDataArray = [NSMutableArray array];
    _assetsDataArray = [NSMutableArray array];
    
    [self setupSubViews];
}
// 发表评论页面UI搭建
- (void)setupSubViews {
    [self setupRightButton];
    [self setupContentSubViews];
}

- (void)setupContentSubViews {
    
    _shawView = [[UIView alloc] initWithFrame:self.view.bounds];
    _shawView.hidden = YES;
    [self.view addSubview:_shawView];
    
    
    CGFloat margin = GENERAL_SIZE(30);
    CGFloat Y = subViewsY + margin;
    // 创建控件
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(GENERAL_SIZE(40), Y, GENERAL_SIZE(80), GENERAL_SIZE(40))];
    titleLabel.text = @"标题:";
    titleLabel.textColor = TEXTCOLOR;
    titleLabel.font = TEXTFONT;
    [self.view addSubview:titleLabel];
    
    _titleTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame)+GENERAL_SIZE(20), Y, SCREEN_WIDTH - GENERAL_SIZE(80) - GENERAL_SIZE(40)*2-GENERAL_SIZE(20), GENERAL_SIZE(40))];
    _titleTF.textColor = TEXTCOLOR;
    _titleTF.placeholder = @"请输入帖子标题...";
    _titleTF.font = TEXTFONT;
    _titleTF.layer.cornerRadius = GENERAL_SIZE(5);
    _titleTF.layer.masksToBounds = YES;
    _titleTF.layer.borderWidth = 0.5;
    _titleTF.delegate = self;
    _titleTF.layer.borderColor = TEXTCOLOR.CGColor;
    //左端缩进15像素
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, GENERAL_SIZE(10), GENERAL_SIZE(30))];
    _titleTF.leftView = view;
    _titleTF.leftViewMode = UITextFieldViewModeAlways;
    
    [self.view addSubview:_titleTF];

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleTF.frame)+GENERAL_SIZE(margin), SCREEN_WIDTH, GENERAL_SIZE(2))];
    lineView.backgroundColor =RGBACOLOR(246, 246, 246, 1.0);
    [self.view addSubview:lineView];
    
    _contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(GENERAL_SIZE(20), CGRectGetMaxY(lineView.frame)+GENERAL_SIZE(margin), SCREEN_WIDTH - GENERAL_SIZE(20)*2, GENERAL_SIZE(241))];
    _contentTextView.textColor = TEXTCOLOR;
    _contentTextView.font = TEXTFONT;
    _contentTextView.backgroundColor = [UIColor cyanColor];
    _contentTextView.delegate = self;
    [self.view addSubview:_contentTextView];
    
    _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - GENERAL_SIZE(20)*2, GENERAL_SIZE(60))];
    _placeHolderLabel.text = @"请输入帖子内容...";
    _placeHolderLabel.textColor = RGBACOLOR(201, 201, 201, 1.0);
    _placeHolderLabel.font = TEXTFONT;
    [_contentTextView addSubview:_placeHolderLabel];
    
    lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_contentTextView.frame)+GENERAL_SIZE(margin), SCREEN_WIDTH, GENERAL_SIZE(2))];
    lineView1.backgroundColor =RGBACOLOR(246, 246, 246, 1.0);
    [self.view addSubview:lineView1];
    
   
    CGFloat CollectionViewH = SCREEN_HEIGHT-CGRectGetMaxY(lineView1.frame)-GENERAL_SIZE(margin)*2;

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(GENERAL_SIZE(160), GENERAL_SIZE(160));
//    flowLayout.minimumLineSpacing = 0;
//    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(GENERAL_SIZE(20), GENERAL_SIZE(20), 0, GENERAL_SIZE(20));
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(GENERAL_SIZE(20), CGRectGetMaxY(lineView1.frame)+GENERAL_SIZE(margin), SCREEN_WIDTH-GENERAL_SIZE(20)*2, CollectionViewH) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = RGBACOLOR(241, 241, 241, 1.0);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    [_collectionView registerClass:[GWFAddButtonCell class] forCellWithReuseIdentifier:@"GWFAddButtonCellIdentifier"];
    [_collectionView registerClass:[GWFImageCell class] forCellWithReuseIdentifier:@"GWFImageCellIdentifier"];
    
    [self.view addSubview:_collectionView];

    [self.view bringSubviewToFront:_shawView];
    
}


#pragma mark --  UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if ([textView.text length]) {
        _placeHolderLabel.alpha = 0;
    } else {
        _placeHolderLabel.alpha = 1;
    }
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    _shawView.hidden = NO;
    _shawView.backgroundColor = [UIColor clearColor];
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    _shawView.hidden = NO;
    _shawView.backgroundColor = [UIColor clearColor];
    return YES;
}

- (void)setupRightButton {
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:RGBACOLOR(4, 140, 248, 1.0) forState:UIControlStateNormal];
    sendBtn.frame = CGRectMake(0, 0, 44, 44);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sendBtn];
    
    [sendBtn addTarget:self action:@selector(sendContent:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)endEditView {
    _shawView.hidden = YES;
    [_titleTF endEditing:YES];
    [_contentTextView endEditing:YES];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditView];
}
#pragma mark --  发送按钮的点击事件
- (void)sendContent:(id)sender {
    
    [self endEditView];

    [MBProgressHUD showMessag:@"正在发送..." toView:self.view];
    NSMutableArray *tempImageArr = [NSMutableArray array];
    NSMutableArray *origionTempImageArr = [NSMutableArray array];
    // 等比缩小后的图片
    for (UIImage *originImage in self.dataArray) {
        NSData *imageData = UIImageJPEGRepresentation(originImage, 1.0);
        NSString *image64 = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        [tempImageArr addObject:image64];
    }
    // 原图数组
    for (UIImage *originImage in self.bigDataArray) {
        NSData *imageData = UIImageJPEGRepresentation(originImage, 1.0);
        NSString *image64 = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        [origionTempImageArr addObject:image64];
    }
    // 等比缩小后的图片的jsonStr
    NSData *data=[NSJSONSerialization dataWithJSONObject:tempImageArr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    // 原图片的jsonStr
    NSData *origionDdata=[NSJSONSerialization dataWithJSONObject:origionTempImageArr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *origionJsonStr=[[NSString alloc]initWithData:origionDdata encoding:NSUTF8StringEncoding];
    
    GWFCommentModel *model = [[GWFCommentModel alloc] init];
    model.topTitle = _titleTF.text;  // 标题
    model.topContent = _contentTextView.text;  // 文本
    model.jsonStr = jsonStr;  // 图片
    model.origionImageJsonStr = origionJsonStr;
    model.postTime = [self currentTimer]; // 帖子发布时间
    
    [[GWFDataBaseManager shareManager] setDataForDataBase:model];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showSuccess:@"发送成功！" toView:self.view];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

#pragma mark ------相册回调方法----------
// 多图片选择
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    NSLog(@"assets === %@",assets);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i=0; i<assets.count; i++) {
            ZYQAsset *asset=assets[i];
            
            [self.assetsDataArray addObject:asset];
            
            [asset setGetFullScreenImage:^(UIImage *result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (result) {
                        UIImage *image = [UIImage scaleToSizeWithImage:result size:CGSizeMake(GENERAL_SIZE(160), GENERAL_SIZE(160))];
                        [self.dataArray addObject:image];
                        [self.bigDataArray addObject:result];
                        [self.collectionView reloadData];
                    }
                });
                
            }];
        }
    });

    [self dismissViewControllerAnimated:YES completion:nil];
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count + 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GWFAddButtonCell *addCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GWFAddButtonCellIdentifier" forIndexPath:indexPath];
    GWFImageCell *imageCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GWFImageCellIdentifier" forIndexPath:indexPath];
    
    if (self.dataArray.count == 0) {
        return addCell;
    } else {
        
        if (indexPath.item + 1 > self.dataArray.count) {
            return addCell;
        } else {
            imageCell.imageView.image = self.dataArray[indexPath.item];
//            [imageCell.imageView addSubview:imageCell.deleteBtn];
            imageCell.deleteBtn.tag = indexPath.item+100;
            [imageCell.deleteBtn addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
        }
        return imageCell;

    }

}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item + 1 > self.dataArray.count) {
        // 图片
        self.pickerController = [[ZYQAssetPickerController alloc] init];
        _pickerController.maximumNumberOfSelection = 9;
        _pickerController.assetsFilter = ZYQAssetsFilterAllAssets;
        _pickerController.showEmptyGroups=YES;
        _pickerController.delegate=self;
        _pickerController.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            if ([(ZYQAsset*)evaluatedObject mediaType]==ZYQAssetMediaTypeVideo) {
                NSTimeInterval duration = [(ZYQAsset*)evaluatedObject duration];
                return duration >= 9;
            } else {
                return YES;
            }
        }];
        [self presentViewController:self.pickerController animated:YES completion:nil];
    } else {
        NSLog(@"===== %@",self.dataArray);
        GWFImageBrowserViewController *imageBrowserVC = [[GWFImageBrowserViewController alloc] init];
        imageBrowserVC.imageIndex = indexPath.item;
        imageBrowserVC.isLocal = YES;
        imageBrowserVC.dataArray = self.bigDataArray;
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5f;
        transition.type = @"Cube";
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [self presentViewController:imageBrowserVC animated:NO completion:nil];
    }
}
- (void)deleteImage:(UIButton *)deleteBtn {
    NSInteger index = deleteBtn.tag - 100;
    
    [self.dataArray removeObjectAtIndex:index];
    
    [self.collectionView reloadData];
}
// 获取当前时间
- (NSString *)currentTimer {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *nowDate = [NSDate date];
    NSString *currentTimeString = [dateFormatter stringFromDate:nowDate];
    return currentTimeString;
}
@end

















