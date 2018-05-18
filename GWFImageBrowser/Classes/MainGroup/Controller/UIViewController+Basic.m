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
//    NSLog(@"parent ==== %@  ==== %@",parent,parent.childViewControllers);
    
    if (!isP) {
        if (parent.childViewControllers.count == 1 && ([parent.childViewControllers.lastObject isKindOfClass:[GWFHomeViewController class]] || [parent.childViewControllers.lastObject isKindOfClass:[GWFDiscoverViewController class]] || [parent.childViewControllers.lastObject isKindOfClass:[GWFMeViewController class]])) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOWTHEBUTTON" object:nil];
        } 
    }
    
}

/// 将十六进制的字符串转化为NSData
- (NSData *)transStrHexToData:(NSString *)strHex
{
    /// bytes索引
    NSUInteger j = 0;
    
    NSInteger len = strHex.length;
    
    if (len % 2 == 1) {
        /// 若不能被2整除则说明16进制的字符串不满足图片图。特此说明，假如只是单纯的把十六进制转换为NSData就把这个if干掉即可，
        return nil;
    }
    
    /// 动态分配内存
    Byte *bytes = (Byte *)malloc((len / 2 + 1) * sizeof(Byte));
    
    /// 初始化内存 其中memset的作用是在一段内存块中填充某个给定的值，它是对较大的结构体或数组进行清零操作的一种最快方法
    memset(bytes, '\0', (len / 2 + 1) * sizeof(Byte));
    
    /// for循环里面其实就是把16进制的字符串转化为字节数组的过程
    for (NSUInteger i = 0; i < strHex.length; i += 2) {
        
        /// 一字节byte是8位(比特)bit 一位就代表一个0或者1(即二进制) 每8位(bit)组成一个字节(Byte) 所以每一次取2为字符组合成一个字节 其实就是2个16进制的字符其实就是8位(bit)即一个字节byte
        NSString *str = [strHex substringWithRange:NSMakeRange(i, 2)];
        
        /// 将16进制字符串转化为十进制
        unsigned long uint_ch = strtoul([str UTF8String], 0, 16);
        
        bytes[j] = uint_ch;
        
        /// 自增
        j ++;
    }
    
    /// 将字节数组转化为NSData
    NSData *data = [[NSData alloc] initWithBytes:bytes length:len / 2];
    
    /// 释放内存
    free(bytes);
    
    return data;
}


@end
