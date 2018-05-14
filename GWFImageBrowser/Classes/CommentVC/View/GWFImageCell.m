//
//  GWFImageCell.m
//  GWFImageBrowser
//
//  Created by user on 2018/5/14.
//  Copyright © 2018年 user. All rights reserved.
//

#import "GWFImageCell.h"

@implementation GWFImageCell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self.contentView addSubview:self.imageView];
        [self.imageView addSubview:self.deleteBtn];
    }
    
    return self;
}
-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}

- (UIButton *)deleteBtn{
    if (!_deleteBtn) {
        self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.frame = CGRectMake(60, -6, 25, 25);
        [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"common_del_circle"] forState:UIControlStateNormal];
    }
    return _deleteBtn;
}

@end
