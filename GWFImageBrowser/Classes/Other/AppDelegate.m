//
//  AppDelegate.m
//  GWFImageBrowser
//
//  Created by user on 2018/4/24.
//  Copyright © 2018年 user. All rights reserved.
//

#import "AppDelegate.h"
#import "GWFTabBarController.h"
#import "JYCWindow.h"

@interface AppDelegate ()

@property(nonatomic,strong)JYCWindow *jycWindow;

@end

@implementation AppDelegate


- (void)showFloatWindow{
    self.jycWindow = [[JYCWindow alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-80, SCREEN_HEIGHT-150, 50, 50) mainImageName:@"timg1.png" bgcolor:[UIColor lightGrayColor] animationColor:[UIColor purpleColor]];
    //    __weak __typeof(self)weakSelf = self;
    
    self.jycWindow.callService = ^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"JUMPOTHERCONTROLLER" object:nil];
        
        //        __strong __typeof(weakSelf)strongSelf = weakSelf;
        //
        //        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"拨打候鸟旅居网客服电话？" message:@"4000301679" preferredStyle:UIAlertControllerStyleAlert];
        //        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        //        UIAlertAction *defintAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //
        //            UIApplication *app = [UIApplication sharedApplication];
        //
        //            NSString *strUrl = [NSString stringWithFormat:@"tel://4000301679"];
        //
        //            NSURL *url = [NSURL URLWithString:strUrl];
        //
        //            [app openURL:url ];
        //        }];
        //
        //        [alert addAction:cancleAction];
        //        [alert addAction:defintAction];
        //        [strongSelf.window.rootViewController presentViewController:alert animated:YES completion:nil];
        
        
    };
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self showFloatWindow];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    // 1.添加子控制器
    GWFTabBarController *tabbarVC = [[GWFTabBarController alloc] init];
    // 2.设置根控制器
    self.window.rootViewController = tabbarVC;
    
    [self.window makeKeyAndVisible];
    
    // 创建数据库
    [[GWFDataBaseManager shareManager] createdDataBase];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if(![fileManager fileExistsAtPath:kVideoPath])  // 视频文件夹
    {
        [fileManager createDirectoryAtPath:kVideoPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if(![fileManager fileExistsAtPath:kImagePath])  // 图片文件夹
    {
        [fileManager createDirectoryAtPath:kImagePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return YES;
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
