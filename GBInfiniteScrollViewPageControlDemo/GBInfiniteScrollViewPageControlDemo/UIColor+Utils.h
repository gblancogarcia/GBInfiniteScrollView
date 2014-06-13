//
//  UIColor+Utils.h
//  GBInfiniteScrollViewDemo
//
//  Created by Gerardo Blanco García on 08/02/14.
//  Copyright (c) 2014 ZIBLEC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Utils)

+ (UIColor *)colorFromHexCode:(NSString *)hexString;

+ (UIColor *)blendedColorWithForegroundColor:(UIColor *)foregroundColor
                             backgroundColor:(UIColor *)backgroundColor
                                percentBlend:(CGFloat)percentBlend;

+ (UIColor *)brightRedColor;

@end
