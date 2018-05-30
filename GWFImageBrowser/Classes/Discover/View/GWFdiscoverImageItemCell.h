//
//  GWFdiscoverImageItemCell.h
//  GWFImageBrowser
//
//  Created by user on 2018/5/18.
//  Copyright © 2018年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GWFdiscoverImageItemCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *discoverImage;

@property (nonatomic, copy) NSString *videoPath;

@property (nonatomic, strong) UIImage *thumbImage;

@property (nonatomic, copy) NSString *durationtimer;


@property (nonatomic, copy) NSString *isType;

@end
