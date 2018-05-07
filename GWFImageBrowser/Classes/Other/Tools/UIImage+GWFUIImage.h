//
//  UIImage+GWFUIImage.h
//  BaiSiBudeJie
//
//  Created by zhufeng on 16/12/14.
//  Copyright © 2016年 zhufeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (GWFUIImage)

//快速生成一个不经过渲染的图片
+(UIImage *)imageOriginalWithUIImageName:(NSString *)imageName;

-(instancetype)setupImageCircle;

+ (instancetype)setupCircleImageNamed:(NSString *)name;

+ (UIImage *)scaleToSizeWithImage:(UIImage *)image size:(CGSize)size;

@end
