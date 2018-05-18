//
//  GWFDataBaseManager.h
//  GWFImageBrowser
//
//  Created by user on 2018/5/16.
//  Copyright © 2018年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GWFDataBaseManager : NSObject

+ (instancetype)shareManager;

// 创建数据库
- (void)createdDataBase;
- (void)setDataForDataBase:(id)objc;
- (NSMutableArray *)loadDataForTopDetails;
@end
