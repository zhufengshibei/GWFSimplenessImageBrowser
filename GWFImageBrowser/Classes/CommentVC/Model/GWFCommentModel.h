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
@property (nonatomic, strong) NSMutableArray *origionImageArray;
@property (nonatomic, copy) NSString *topID;
@property (nonatomic, copy) NSString *jsonStr;
@property (nonatomic, copy) NSString *origionImageJsonStr;

@property (nonatomic, copy) NSString *postTime;

@property (nonatomic, assign) CGFloat cellHeight;

@end

