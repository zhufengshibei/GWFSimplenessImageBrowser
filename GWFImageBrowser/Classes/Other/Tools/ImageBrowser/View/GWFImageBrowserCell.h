//
//  GWFImageBrowserCell.h
//  GWFImageBrowser
//
//  Created by user on 2018/5/3.
//  Copyright © 2018年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GWFImageBrowserCellDelegate <NSObject>
@optional

- (void)dissMissVC;

@end

@interface GWFImageBrowserCell : UICollectionViewCell

@property (nonatomic, weak) id <GWFImageBrowserCellDelegate> delegate;

@property (nonatomic, assign) BOOL isLocal;

@property (nonatomic, copy) NSString *imageString;

@end
