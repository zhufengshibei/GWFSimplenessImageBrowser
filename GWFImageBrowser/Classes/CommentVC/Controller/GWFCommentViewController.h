//
//  GWFCommentViewController.h
//  GWFImageBrowser
//
//  Created by user on 2018/5/2.
//  Copyright © 2018年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GWFBaseViewController.h"

typedef void(^EditDoneBlock)(void);

@interface GWFCommentViewController : GWFBaseViewController

@property (nonatomic,copy) EditDoneBlock doneBlack;

@end
