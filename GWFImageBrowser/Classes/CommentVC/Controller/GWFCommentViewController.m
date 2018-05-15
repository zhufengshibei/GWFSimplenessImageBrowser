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

@interface GWFCommentViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate> {
    UITextField  *_titleTF;
    UITextView   *_contentTextView;
    UILabel      *_placeHolderLabel;
    UIView       *lineView1;
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

}


#pragma mark --  UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if ([textView.text length]) {
        _placeHolderLabel.alpha = 0;
    } else {
        _placeHolderLabel.alpha = 1;
    }
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
    
    [_titleTF endEditing:YES];
    [_contentTextView endEditing:YES];
    
    NSMutableArray *tempImageArr = [NSMutableArray array];
    
    for (UIImage *originImage in self.dataArray) {
//        NSData *data = UIImageJPEGRepresentation(originImage, 1.0f);
//        NSData *encodedImageData = [data base64EncodedDataWithOptions:0];
//        // Data转字符串
//        NSString *decodeStr = [[NSString alloc] initWithData:encodedImageData encoding:NSUTF8StringEncoding];
        
        
        NSData *licenseData = UIImageJPEGRepresentation(originImage, 0.7f);
        
        
        Byte *bytes = (Byte *)[licenseData bytes];
        NSString *hexStr=@"";
        for(int i=0;i<[licenseData length];i++)
        {
            NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff]; ///16进制数
            if([newHexStr length]==1)
                hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
            else
                hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
        }
//        NSLog(@"bytes 的16进制数为:%@",hexStr);
        
        
        [tempImageArr addObject:hexStr];
    }
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    NSMutableArray *arry = tempImageArr;
    [dictionary setValue:_titleTF.text forKey:@"topTitle"];
    [dictionary setValue:_contentTextView.text forKey:@"topContent"];
    [dictionary setValue:arry forKey:@"imageArray"];
    NSData *data=[NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    
//    GWFCommentModel *model = [[GWFCommentModel alloc] init];
//    model.topTitle = _titleTF.text;
//    model.topContent = _contentTextView.text;
//
//    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
//    NSMutableArray *arry = tempImageArr;
//    [model setValue:arry forKey:model.imageJsonStr];

    
//    NSData *modelData = [ModelToJson getJSON:dictionary options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *modelJsonStr = [[NSString alloc] initWithData:modelData encoding:NSUTF8StringEncoding];
    
    NSLog(@"modelJsonStr  == %@",jsonStr);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:jsonStr forKey:@"TESTDATA"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
    
}

#pragma mark ------相册回调方法----------
// 多图片选择
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    NSLog(@"assets === %@",assets);
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
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
//    });

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

@end

















