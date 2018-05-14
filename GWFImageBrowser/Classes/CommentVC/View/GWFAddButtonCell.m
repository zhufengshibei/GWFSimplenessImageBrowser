//
//  GWFAddButtonCell.m
//  GWFImageBrowser
//
//  Created by user on 2018/5/14.
//  Copyright © 2018年 user. All rights reserved.
//

#import "GWFAddButtonCell.h"

@implementation GWFAddButtonCell {
    UIImageView   *_addImageView;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        _addImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _addImageView.userInteractionEnabled = YES;
        _addImageView.image = [UIImage imageNamed:@"ic_add_photo"];
        [self.contentView addSubview:_addImageView];
    }
    
    return self;
}

@end
