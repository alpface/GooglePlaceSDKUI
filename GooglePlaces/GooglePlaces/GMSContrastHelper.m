//
//  GMSContrastHelper.m
//  GooglePlaceSDKUI
//
//  Created by xiaoyuan on 2018/10/31.
//  Copyright © 2018 erlinyou. All rights reserved.
//

#import "GMSContrastHelper.h"

@implementation UIColor (GMSRgbExtensions)

//获取RGB值
+ (void)getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color {
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel,
                                                 1,
                                                 1,
                                                 8,
                                                 4,
                                                 rgbColorSpace,
                                                 bitmapInfo);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    
    for (int component = 0; component < 3; component++) {
        components[component] = resultingPixel[component];
    }
}



@end

@implementation GMSContrastHelper

/// 判断颜色是不是亮色
+ (BOOL)isLightColor:(UIColor *)color {
    CGFloat components[3];
    [UIColor getRGBComponents:components forColor:color];
    //    NSLog(@"%f %f %f", components[0], components[1], components[2]);
    
    CGFloat num = components[0] + components[1] + components[2];
    if (num < 382) {
        return NO;
    }
    else {
        return YES;
    }
}

@end
