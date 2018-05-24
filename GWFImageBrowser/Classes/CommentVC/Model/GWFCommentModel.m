//
//  GWFCommentModel.m
//  GWFImageBrowser
//
//  Created by user on 2018/5/15.
//  Copyright © 2018年 user. All rights reserved.
//

#import "GWFCommentModel.h"

@implementation GWFCommentModel

-(NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}
-(NSMutableArray *)origionImageArray {
    if (!_origionImageArray) {
        _origionImageArray = [NSMutableArray array];
    }
    return _origionImageArray;
}

-(CGFloat)cellHeight {
    _cellHeight = 0;
    
    _cellHeight += GENERAL_SIZE(90);
    _cellHeight += GENERAL_SIZE(20);
    
    //计算文字的高
    //限制最大宽高
    CGSize textMaxSize = CGSizeMake(SCREEN_WIDTH - 2 * GENERAL_SIZE(40), MAXFLOAT);
    
    if (![self.topTitle isEqualToString:@""]) {
        _cellHeight += [self.topTitle boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : LabelFont(34)} context:nil].size.height + GENERAL_SIZE(20);
    }
    if (![self.topContent isEqualToString:@""]) {
        _cellHeight += [self.topContent boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : LabelFont(28)} context:nil].size.height + GENERAL_SIZE(20);
        _cellHeight += GENERAL_SIZE(20);
    }
    
    return _cellHeight;
}


@end


