//
//  GWFDataBaseManager.m
//  GWFImageBrowser
//
//  Created by user on 2018/5/16.
//  Copyright © 2018年 user. All rights reserved.
//

#import "GWFDataBaseManager.h"
#import "GWFCommentModel.h"

@interface GWFDataBaseManager ()

@property (nonatomic, strong) FMDatabase *db;

@end

@implementation GWFDataBaseManager

+ (instancetype)shareManager {
    static GWFDataBaseManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[GWFDataBaseManager alloc] init];
    });
    return manager;
}
// 创建数据库
- (void)createdDataBase {
    _db = [FMDatabase databaseWithPath:DataBasePath];
    BOOL isOpen = [_db open];
    if (isOpen) {
        NSLog(@"数据库已打开 == %d",isOpen);
        NSLog(@"%@",DataBasePath);
        // 建表
        [self createdDataBaseTable];
    } else {
        NSLog(@"数据库打开失败，请重新操作");
    }
    
}
// 创建数据库
- (void)createdDataBaseTable {
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_topDetails (id integer PRIMARY KEY AUTOINCREMENT, topTitle text NOT NULL, topContent text NOT NULL, jsonStr text, videoString text, thumbImagesJsonStr text, timesJsonStr text, topType text, postTime text NOT NULL);"];
}
- (void)setDataForDataBase:(id)objc {
    GWFCommentModel *model = (GWFCommentModel *)objc;
    // 插入数据前先清空表中的数据
//    [_db executeUpdate:@"DELETE FROM t_topDetails;"];
    [_db executeUpdate:@"INSERT INTO t_topDetails (topTitle, topContent, jsonStr, videoString, thumbImagesJsonStr, timesJsonStr, topType, postTime) VALUES (?, ?, ?, ?, ?, ?, ?, ?);",model.topTitle, model.topContent, model.jsonStr, model.videoString, model.thumbImagesJsonStr, model.timesJsonStr, model.topType,  model.postTime];
}

#pragma mark -- 查询数据
- (NSMutableArray *)loadDataForTopDetails
{
    // 根据请求参数生成对应的查询SQL语句
    // 执行SQL
    FMResultSet *set = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM t_topDetails;"]];
    
    NSMutableArray *statuses = [NSMutableArray array];
    [statuses removeAllObjects];

    while (set.next) {
        GWFCommentModel *model = [[GWFCommentModel alloc] init];
        
        model.jsonStr = [set objectForColumn:@"jsonStr"];
        model.videoString = [set objectForColumn:@"videoString"];
        model.thumbImagesJsonStr = [set objectForColumn:@"thumbImagesJsonStr"];
        model.timesJsonStr = [set objectForColumn:@"timesJsonStr"];
        
        if (model.jsonStr != nil && ![model.jsonStr isKindOfClass:[NSNull class]]) {
            id tmp = [NSJSONSerialization JSONObjectWithData:[model.jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments | NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
            
            if (tmp) {
                if ([tmp isKindOfClass:[NSArray class]]) {
                    for (NSString *str in tmp) {
                        NSData * imageData =[[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
                        UIImage *photo = [UIImage imageWithData:imageData];
                        [model.imageArray addObject:photo];
                    }
                }
            }
        }
        
        if (model.thumbImagesJsonStr != nil && ![model.thumbImagesJsonStr isKindOfClass:[NSNull class]]) {
            id tmpThumb = [NSJSONSerialization JSONObjectWithData:[model.thumbImagesJsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments | NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
            
            if (tmpThumb) {
                if ([tmpThumb isKindOfClass:[NSArray class]]) {
                    for (NSString *str in tmpThumb) {
                        NSData * imageData =[[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
                        UIImage *photo = [UIImage imageWithData:imageData];
                        [model.thumbsArray addObject:photo];
                    }
                }
            }
        }
        
        if (model.videoString != nil && ![model.videoString isKindOfClass:[NSNull class]]) {
            model.videoArray = [model.videoString componentsSeparatedByString:@","];
        }
        if (model.timesJsonStr != nil && ![model.timesJsonStr isKindOfClass:[NSNull class]]) {
            model.timesArray = [model.timesJsonStr componentsSeparatedByString:@","];
        }
        model.topType = [set stringForColumn:@"topType"];
        model.topTitle = [set stringForColumn:@"topTitle"];
        model.topContent = [set stringForColumn:@"topContent"];
        model.topID = [set stringForColumn:@"id"];
        model.postTime = [set stringForColumn:@"postTime"];
        [statuses addObject:model];
    }
    return statuses;
}
-(void)removeCurrentDataWithTopicId:(NSString *)topId {
    NSString *deleteSql = [NSString stringWithFormat:@"delete from t_topDetails where Id = %@" ,topId];
    
    BOOL res = [_db executeUpdate:deleteSql];
    if (res) {
        NSLog(@"删除成功！");
    } else {
        NSLog(@"删除失败！");
    }
}

@end
