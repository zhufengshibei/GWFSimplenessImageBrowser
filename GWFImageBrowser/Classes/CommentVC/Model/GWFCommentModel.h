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
@property (nonatomic, strong) NSArray *imageArray;

@end

