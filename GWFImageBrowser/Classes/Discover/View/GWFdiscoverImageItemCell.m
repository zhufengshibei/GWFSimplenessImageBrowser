//
//  GWFdiscoverImageItemCell.m
//  GWFImageBrowser
//
//  Created by user on 2018/5/18.
//  Copyright © 2018年 user. All rights reserved.
//

#import "GWFdiscoverImageItemCell.h"

@interface GWFdiscoverImageItemCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *logoView;

@end


@implementation GWFdiscoverImageItemCell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        CGFloat height = self.contentView.bounds.size.height, width = self.contentView.bounds.size.width;
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_imageView];
        
        _logoView = [[UIImageView alloc] initWithFrame:CGRectMake(width-GENERAL_SIZE(32), 0, GENERAL_SIZE(32), GENERAL_SIZE(32))];
        [self.contentView addSubview:_logoView];
    }
    
    return self;
}

-(void)setDiscoverImage:(UIImage *)discoverImage {
    _imageView.image = discoverImage;
    _logoView.image = [UIImage imageNamed:@"imageLogo"];
}
-(void)setVideoPath:(NSString *)videoPath {
    _imageView.image = [self thumbnailImageForVideo:[NSURL fileURLWithPath:videoPath] atTime:0];
    _logoView.image = [UIImage imageNamed:@"videoLogo"];
}

//videoURL:本地视频路径    time：用来控制视频播放的时间点图片截取
-(UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
    
    return thumbnailImage;
}

@end
