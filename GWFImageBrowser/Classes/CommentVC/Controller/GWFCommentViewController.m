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

@interface GWFCommentViewController ()<UITextFieldDelegate,UITextViewDelegate,HXPhotoViewDelegate,UIImagePickerControllerDelegate> {
    UITextField  *_titleTF;
    UITextView   *_contentTextView;
    UILabel      *_placeHolderLabel;
    UIView       *lineView1;
    UIView       *_shawView;
    UIButton     *_sendBtn;
    
}

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (strong, nonatomic) HXPhotoManager *manager;
@property (strong, nonatomic) HXPhotoView *photoView;
@property (strong, nonatomic) HXDatePhotoToolManager *toolManager;
@property (copy, nonatomic) NSString *topicType;
@property (strong, nonatomic) GWFCommentModel *commentModel;

@property (nonatomic,assign) BOOL isFinish;

@end

@implementation GWFCommentViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HIDDENTHEBUTTON" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发布帖子";
    self.isFinish = NO;
    self.topicType = @"0";
    _dataArray = [NSMutableArray array];
    
    _commentModel = [[GWFCommentModel alloc] init];
    
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
    CGFloat Y1 = subViewsY;
    CGFloat Y = Y1+14;
    // 创建控件
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(GENERAL_SIZE(40), Y, GENERAL_SIZE(80), GENERAL_SIZE(40))];
    titleLabel.text = @"标题:";
    titleLabel.textColor = TEXTCOLOR;
    titleLabel.font = TEXTFONT;
    [self.view addSubview:titleLabel];
    
    _titleTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame)+GENERAL_SIZE(20), Y-7, SCREEN_WIDTH - GENERAL_SIZE(80) - GENERAL_SIZE(40)*2-GENERAL_SIZE(20), GENERAL_SIZE(60))];
    _titleTF.textColor = TEXTCOLOR;
    _titleTF.placeholder = @" 请输入帖子标题...";
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
    _contentTextView.backgroundColor = [UIColor clearColor];
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
    
    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
    photoView.frame = CGRectMake(GENERAL_SIZE(20), CGRectGetMaxY(lineView1.frame)+margin*2, SCREEN_WIDTH-GENERAL_SIZE(20)*2, 0);
    photoView.delegate = self;
    photoView.outerCamera = YES;
    photoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:photoView];
    self.photoView = photoView;
    
    
    [self.view bringSubviewToFront:_shawView];
}
- (HXDatePhotoToolManager *)toolManager {
    if (!_toolManager) {
        _toolManager = [[HXDatePhotoToolManager alloc] init];
    }
    return _toolManager;
}

- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhotoAndVideo];
        _manager.configuration.openCamera = YES;
        _manager.configuration.lookLivePhoto = YES;
        _manager.configuration.photoMaxNum = 9;
        _manager.configuration.videoMaxNum = 6;
        _manager.configuration.maxNum = 10;
        _manager.configuration.videoMaxDuration = 500.f;
        _manager.configuration.saveSystemAblum = NO;
        _manager.configuration.showDateSectionHeader = NO;
        _manager.configuration.selectTogether = NO;
        __weak typeof(self) weakSelf = self;
        _manager.configuration.shouldUseCamera = ^(UIViewController *viewController, HXPhotoConfigurationCameraType cameraType, HXPhotoManager *manager) {
            
            // 这里拿使用系统相机做例子
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = (id)weakSelf;
            imagePickerController.allowsEditing = NO;
            NSString *requiredMediaTypeImage = ( NSString *)kUTTypeImage;
            NSString *requiredMediaTypeMovie = ( NSString *)kUTTypeMovie;
            NSArray *arrMediaTypes;
            if (cameraType == HXPhotoConfigurationCameraTypePhoto) {
                arrMediaTypes=[NSArray arrayWithObjects:requiredMediaTypeImage,nil];
            }else if (cameraType == HXPhotoConfigurationCameraTypeVideo) {
                arrMediaTypes=[NSArray arrayWithObjects:requiredMediaTypeMovie,nil];
            }else {
                arrMediaTypes=[NSArray arrayWithObjects:requiredMediaTypeImage, requiredMediaTypeMovie,nil];
            }
            [imagePickerController setMediaTypes:arrMediaTypes];
            // 设置录制视频的质量
            [imagePickerController setVideoQuality:UIImagePickerControllerQualityTypeHigh];
            //设置最长摄像时间
            [imagePickerController setVideoMaximumDuration:60.f];
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
            imagePickerController.modalPresentationStyle=UIModalPresentationOverCurrentContext;
            [viewController presentViewController:imagePickerController animated:YES completion:nil];
        };
    }
    return _manager;
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    HXPhotoModel *model;
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        model = [HXPhotoModel photoModelWithImage:image];
        if (self.manager.configuration.saveSystemAblum) {
            [HXPhotoTools savePhotoToCustomAlbumWithName:self.manager.configuration.customAlbumName photo:model.thumbPhoto];
        }
    }else  if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        NSURL *url = info[UIImagePickerControllerMediaURL];
        NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                         forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
        AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];
        float second = 0;
        second = urlAsset.duration.value/urlAsset.duration.timescale;
        model = [HXPhotoModel photoModelWithVideoURL:url videoTime:second];
        
        if (self.manager.configuration.saveSystemAblum) {
            [HXPhotoTools saveVideoToCustomAlbumWithName:self.manager.configuration.customAlbumName videoURL:url];
        }
    }
    if (self.manager.configuration.useCameraComplete) {
        self.manager.configuration.useCameraComplete(model);
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal {
    
    NSSLog(@"所有:%ld - 照片:%ld - 视频:%ld",allList.count,photos.count,videos.count);
    NSSLog(@"所有:%@ - 照片:%@ - 视频:%@",allList,photos,videos);
    NSMutableArray *seconds = [NSMutableArray array];
    NSMutableArray *thumbImages = [NSMutableArray array];
    if (videos.count > 0) {
        for (HXPhotoModel *model in videos) {
            [seconds addObject:model.videoTime];
            
            NSData *imageData = UIImageJPEGRepresentation(model.thumbPhoto, 1.0);
            NSString *image64 = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            [thumbImages addObject:image64];
        }
        _commentModel.timesJsonStr = [seconds componentsJoinedByString:@","];
        // 视频缩略图
        NSData *data=[NSJSONSerialization dataWithJSONObject:thumbImages options:NSJSONWritingPrettyPrinted error:nil];
        _commentModel.thumbImagesJsonStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    [HXPhotoTools selectListWriteToTempPath:allList requestList:^(NSArray *imageRequestIds, NSArray *videoSessions) {
        
        NSSLog(@"requestIds - image : %@ \nsessions - video : %@",imageRequestIds,videoSessions);
        
    } completion:^(NSArray<NSURL *> *allUrl, NSArray<NSURL *> *imageUrls, NSArray<NSURL *> *videoUrls) {
        [self.dataArray removeAllObjects];
        NSSLog(@"allUrl - %@\nimageUrls - %@\nvideoUrls - %@",allUrl,imageUrls,videoUrls);
        if (imageUrls.count > 0) {
            self.topicType = @"1";
            
            for (NSURL *url in imageUrls) {
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
                [self.dataArray addObject:image];
                NSString *imageStr = [url path];
                NSFileManager *manager = [NSFileManager defaultManager];
                
                BOOL isMove = [manager removeItemAtPath:imageStr error:nil];
                if (isMove) {
                    NSLog(@"移除成功");
                } else {
                    NSLog(@"移除失败");
                }
            }
        }
        if (videoUrls.count > 0) {
            self.topicType = @"2";
            for (NSURL *videoUrl in videoUrls) {
                NSString *videoStr = [videoUrl path];
                NSFileManager *manager = [NSFileManager defaultManager];
                // 移动文件
                NSString *videoName = [videoStr lastPathComponent];
                NSString *movePath = [kVideoPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",videoName]];
                BOOL isMove = [manager moveItemAtPath:videoStr toPath:movePath error:nil];
                if (isMove) {
                    NSLog(@"移动成功");
                } else {
                    NSLog(@"移动失败");
                }
                [self.dataArray addObject:movePath];
            }
        }
        NSLog(@"dataArray === %@",self.dataArray);
        if (self.dataArray.count == videoUrls.count || self.dataArray.count == imageUrls.count) {
            self.isFinish = YES;
        }
        
    } error:^{
        NSSLog(@"失败");
    }];
}
//- (void)photoView:(HXPhotoView *)photoView deleteNetworkPhoto:(NSString *)networkPhotoUrl {
//    NSSLog(@"networkPhotoUrl === %@",networkPhotoUrl);
//}
//
//- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame {
//    NSSLog(@"%@",NSStringFromCGRect(frame));
////    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY(frame) + kPhotoViewMargin);
//
//}
//
//- (void)photoView:(HXPhotoView *)photoView currentDeleteModel:(HXPhotoModel *)model currentIndex:(NSInteger)index {
//    NSSLog(@"%@ --> index - %ld",model,index);
//}

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
    _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [_sendBtn setTitleColor:RGBACOLOR(4, 140, 248, 1.0) forState:UIControlStateNormal];
    _sendBtn.frame = CGRectMake(0, 0, 44, 44);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_sendBtn];
    
    [_sendBtn addTarget:self action:@selector(sendContent:) forControlEvents:UIControlEventTouchUpInside];
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
    
    if ([self.topicType isEqualToString:@"0"]) {
        self.isFinish = YES;
    }
    
    //    if (self.isFinish) {
    NSLog(@"dataArray2121212 === %@",self.dataArray);
    NSCharacterSet *chat = [NSCharacterSet whitespaceCharacterSet];
    NSString *titleText = [_titleTF.text stringByTrimmingCharactersInSet:chat];
    
    if (titleText.length <= 0) {
        [MBProgressHUD showError:@"标题不能为空" toView:self.view];
        return;
    } else {
        NSString *contentText = [_contentTextView.text stringByTrimmingCharactersInSet:chat];
        if (contentText.length <= 0 && self.dataArray.count == 0) {
            [MBProgressHUD showError:@"请输入文本或添加图片" toView:self.view];
            return;
        } else {
            if (_isFinish) {
                [MBProgressHUD showMessag:@"正在发送..." toView:self.view];
                NSString *jsonStr;
                NSString *videoStr;
                _sendBtn.userInteractionEnabled = NO;
                if ([self.topicType isEqualToString:@"1"]) {
                    NSMutableArray *tempImageArr = [NSMutableArray array];
                    // 等比缩小后的图片
                    for (UIImage *originImage in self.dataArray) {
                        NSData *imageData = UIImageJPEGRepresentation(originImage, 1.0);
                        NSString *image64 = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                        [tempImageArr addObject:image64];
                    }
                    // 等比缩小后的图片的jsonStr
                    NSData *data=[NSJSONSerialization dataWithJSONObject:tempImageArr options:NSJSONWritingPrettyPrinted error:nil];
                    jsonStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                    videoStr = @"";
                    _commentModel.topType = @"1";
                    
                } else if ([self.topicType isEqualToString:@"2"]) {
                    videoStr = [self.dataArray componentsJoinedByString:@","];
                    jsonStr = @"";
                    _commentModel.topType = @"2";
                } else if ([self.topicType isEqualToString:@"0"]) {
                    _commentModel.topType = @"0";
                }
                _commentModel.topTitle = _titleTF.text;  // 标题
                _commentModel.topContent = _contentTextView.text;  // 文本
                _commentModel.jsonStr = jsonStr;  // 图片
                _commentModel.videoString = videoStr;// 视频连接
                _commentModel.postTime = [self currentTimer]; // 帖子发布时间
                
                [[GWFDataBaseManager shareManager] setDataForDataBase:_commentModel];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [MBProgressHUD showSuccess:@"发送成功！" toView:self.view];
                });
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                    
                    if (self.doneBlack) {
                        self.doneBlack();
                    }
                });
            }
            
        }
        
    }
    
    //    }
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

















