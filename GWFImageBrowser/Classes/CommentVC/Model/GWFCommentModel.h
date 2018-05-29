//
//  GWFCommentModel.h
//  GWFImageBrowser
//
//  Created by user on 2018/5/15.
//  Copyright © 2018年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GWFCommentModel : NSObject

@property (nonatomic, copy) NSString *topTitle;
@property (nonatomic, copy) NSString *topContent;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) NSArray *videoArray;
@property (nonatomic, copy) NSString *topID;
@property (nonatomic, copy) NSString *jsonStr;
@property (nonatomic, copy) NSString *videoString;

@property (nonatomic, copy) NSString *postTime;

/**
 * 帖子类型
 * 0：无图无视频； 1：图片； 2：视频
 */
@property (nonatomic, copy) NSString *topType;

@property (nonatomic, assign) CGFloat cellHeight;

@end

