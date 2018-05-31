//
//  GWFDiscoverCell.h
//  GWFImageBrowser
//
//  Created by user on 2018/5/16.
//  Copyright © 2018年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GWFCommentModel.h"

@protocol GWFDiscoverCellDelegate <NSObject>

@optional
- (void)didImageItemWithIndexPath:(NSIndexPath *)currentIndexPath imageArray:(NSMutableArray *)imageArr dataModel:(GWFCommentModel *)model attachName:(NSString *)attachName;

@end

@interface GWFDiscoverCell : UITableViewCell

@property (nonatomic,weak) id <GWFDiscoverCellDelegate> delegate;

@property (nonatomic, strong) GWFCommentModel *commentModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
