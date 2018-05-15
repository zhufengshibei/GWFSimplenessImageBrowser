//
//  UIViewController+Basic.m
//  KPChina
//
//  Created by PC开发 on 2017/5/26.
//  Copyright © 2017年 PC开发. All rights reserved.
//

#import "UIViewController+Basic.h"

@implementation UIViewController (Basic) 

- (void)willMoveToParentViewController:(UIViewController*)parent{

}
- (void)didMoveToParentViewController:(UIViewController*)parent{

    BOOL isP = [(AppDelegate *)[UIApplication sharedApplication].delegate isPresent];
    NSLog(@"parent ==== %@  ==== %@",parent,parent.childViewControllers);
    
    if (!isP) {
        if (parent.childViewControllers.count == 1 && ([parent.childViewControllers.lastObject isKindOfClass:[GWFHomeViewController class]] || [parent.childViewControllers.lastObject isKindOfClass:[GWFDiscoverViewController class]] || [parent.childViewControllers.lastObject isKindOfClass:[GWFMeViewController class]])) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOWTHEBUTTON" object:nil];
        } 
    }
    
}


@end
