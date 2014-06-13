//
//  GBRoundBorderedButton.h
//  GBInfiniteScrollViewDemo
//
//  Created by Gerardo Blanco García on 08/02/14.
//  Copyright (c) 2014 ZIBLEC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBRoundBorderedButton : UIButton

@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *highlightedColor;
@property (nonatomic) CGFloat borderWidth;

- (id)initWithFrame:(CGRect)frame normalColor:(UIColor *)normalColor highlightedColor:(UIColor *)highlightedColor borderWidth:(CGFloat) borderWidth;

@end
