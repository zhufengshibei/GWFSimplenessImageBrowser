//
//  UIImage+GWFUIImage.m
//  BaiSiBudeJie
//
//  Created by zhufeng on 16/12/14.
//  Copyright © 2016年 zhufeng. All rights reserved.
//

#import "UIImage+GWFUIImage.h"

@implementation UIImage (GWFUIImage)

//快速生成一个不经过渲染的图片
+(UIImage *)imageOriginalWithUIImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

//设置图片圆形
-(instancetype)setupImageCircle {
    // 1.开启图形上下文
    // 比例因素:当前点与像素比例
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    // 2.描述裁剪区域
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    // 3.设置裁剪区域;
    [path addClip];
    // 4.画图片
    [self drawAtPoint:CGPointZero];
    // 5.取出图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 6.关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}

+(instancetype)setupCircleImageNamed:(NSString *)name {
    return [[self imageNamed:name] setupImageCircle];
}
#pragma mark -----改变显示图片的尺寸----------
+ (UIImage *)scaleToSizeWithImage:(UIImage *)image size:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


@end
