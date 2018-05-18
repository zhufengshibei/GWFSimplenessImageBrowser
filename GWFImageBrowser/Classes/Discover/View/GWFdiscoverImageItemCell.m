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
    }
    
    return self;
}

-(void)setDiscoverImage:(UIImage *)discoverImage {
    _imageView.image = discoverImage;
}

@end
