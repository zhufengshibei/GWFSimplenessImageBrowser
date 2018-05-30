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
@property (nonatomic, strong) UILabel *timerLabel;

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
        
        _logoView = [[UIImageView alloc] initWithFrame:CGRectMake(width-GENERAL_SIZE(44), 0, GENERAL_SIZE(44), GENERAL_SIZE(44))];
        [self.contentView addSubview:_logoView];
        
        _timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(width-GENERAL_SIZE(86), height-GENERAL_SIZE(50), GENERAL_SIZE(80), GENERAL_SIZE(44))];
        _timerLabel.textAlignment = NSTextAlignmentCenter;
        _timerLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        _timerLabel.font = LabelFont(22);
        _timerLabel.textColor = [UIColor whiteColor];
        _timerLabel.layer.cornerRadius = GENERAL_SIZE(5);
        _timerLabel.layer.masksToBounds = YES;
        [self.contentView addSubview:_timerLabel];
    }
    
    return self;
}
-(void)setIsType:(NSString *)isType {
    _isType = isType;
}
-(void)setThumbImage:(UIImage *)thumbImage {
    _thumbImage = thumbImage;
}
-(void)setDurationtimer:(NSString *)durationtimer {
    _durationtimer = durationtimer;
}

-(void)setDiscoverImage:(UIImage *)discoverImage {
    _timerLabel.hidden = YES;
    _imageView.image = discoverImage;
    _logoView.image = [UIImage imageNamed:@"imageLogo"];
    _logoView.frame = CGRectMake(self.contentView.bounds.size.width-GENERAL_SIZE(60), 0, GENERAL_SIZE(60), GENERAL_SIZE(60));
}
-(void)setVideoPath:(NSString *)videoPath {
    _imageView.image = _thumbImage;
    _logoView.image = [UIImage imageNamed:@"videoLogo"];
    _timerLabel.text = _durationtimer;
    _timerLabel.hidden = NO;
    _logoView.frame = CGRectMake((self.contentView.bounds.size.width-GENERAL_SIZE(60))/2, (self.contentView.bounds.size.height-GENERAL_SIZE(60))/2, GENERAL_SIZE(60), GENERAL_SIZE(60));
    
}


@end
