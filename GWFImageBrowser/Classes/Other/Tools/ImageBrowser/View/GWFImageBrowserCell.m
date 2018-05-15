//
//  GWFImageBrowserCell.m
//  GWFImageBrowser
//
//  Created by user on 2018/5/3.
//  Copyright © 2018年 user. All rights reserved.
//

#import "GWFImageBrowserCell.h"
#import "ProgressView.h"

@interface GWFImageBrowserCell () <UIGestureRecognizerDelegate,UIWebViewDelegate,WKNavigationDelegate> {
    UIImageView  *_imageView;

    ProgressView * progress;
}

@property (nonatomic,strong) WKWebView *webView;

@end

@implementation GWFImageBrowserCell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        progress = [[ProgressView alloc]init];
        progress.frame = CGRectMake(40, 60, 50, 50);
        progress.center = CGPointMake(self.contentView.center.x, self.contentView.center.y-30);
        progress.arcFinishColor = [UIColor grayColor];
        progress.arcUnfinishColor = [UIColor whiteColor];
        progress.arcBackColor = [UIColor grayColor];
        progress.percent = 0;
        [self.contentView addSubview:progress];
        
        _imageView = [[UIImageView  alloc] init];
        _imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.bounds.size.height);
        _imageView.center = self.contentView.center;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_imageView];
        
        _imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapDissMiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickCancel)];
        [_imageView addGestureRecognizer:tapDissMiss];
        
        //长按
        UILongPressGestureRecognizer * longPressImageView = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo)];
        longPressImageView.minimumPressDuration = 1.0;
        longPressImageView.delegate = self;
        [_imageView addGestureRecognizer:longPressImageView];
        // 如果长按确定偵測失败才會触发单击
        [tapDissMiss requireGestureRecognizerToFail:longPressImageView];
        
        // 读取gif图片数据
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/2)];
        _webView.center = self.contentView.center;
        _webView.contentMode = UIViewContentModeScaleAspectFit;
        _webView.backgroundColor = [UIColor clearColor];
        [_webView setOpaque: 0];
        _webView.navigationDelegate = self;
        _webView.userInteractionEnabled = YES;
        [self.contentView addSubview:_webView];
        UITapGestureRecognizer *tapDissMissB = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickCancel)];
        tapDissMissB.delegate = self;
        [_webView addGestureRecognizer:tapDissMissB];
        
        //长按
        UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo)];
        longPressGr.minimumPressDuration = 1.0;
        longPressGr.delegate = self;
        [_webView addGestureRecognizer:longPressGr];
        
        // 如果长按确定偵測失败才會触发单击
        [tapDissMissB requireGestureRecognizerToFail:longPressGr];
    }
    
    return self;
}

-(void)setIsLocal:(BOOL)isLocal {
    _isLocal = isLocal;
}

-(void)setImageString:(id)imageString {
    
    NSLog(@"id === %@",imageString);
    
    if (self.isLocal) {
        
        UIImage *image1;
        if ([imageString isKindOfClass:[UIImage class]]) {
            image1 = imageString;
        } else {
            image1 = [UIImage imageNamed:imageString];
        }
        
        // 大图等比例缩小
        UIImage *result = [UIImage scaleToSizeWithImage:image1 size:CGSizeMake(image1.size.width, image1.size.height)];
        _imageView.image = result;
    } else {
        NSString *urlStr = imageString;
        NSURL *url = [NSURL URLWithString:urlStr];
        if ([urlStr hasSuffix:@".gif"]) {
            _imageView.hidden = YES;
            _webView.hidden = NO;
//            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:20];

            // 获取沙盒目录
//            NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"353907e7525d4bf320b9a27fce5d71f6.gif"]];
//
//            NSURL *testUrl = [NSURL fileURLWithPath:fullPath];
            
            
            [_webView loadRequest:[NSURLRequest requestWithURL:url]];
            //进度条 KVO
            [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
            
        } else {
            _imageView.hidden = NO;
            _webView.hidden = YES;
            [_imageView sd_setImageWithURL:url];
        }
    }
    
}
/**
 *  页面加载完成之后调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    NSLog(@"%s", __FUNCTION__);
    // 禁用选中效果
    [self.webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none'" completionHandler:nil];
    [self.webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none'" completionHandler:nil];
    
}
#pragma mark - 监听加载进度
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    NSLog(@"estimatedProgress === %.2f",_webView.estimatedProgress);
    NSString *percentString = [NSString stringWithFormat:@"%.2f",_webView.estimatedProgress];
    float percent = [percentString floatValue];
    progress.hidden = NO;
    progress.percent = percent;
    if (percent == 1) {
        progress.hidden = YES;
    }
}
// 长按
- (void)longPressToDo {
    
}
// 单击
- (void)didClickCancel {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dissMissVC)]) {
        [self.delegate dissMissVC];
    }
}
// 允许多个手势并发
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}











@end

