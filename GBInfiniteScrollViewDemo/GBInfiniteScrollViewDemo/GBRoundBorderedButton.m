//
//  GBRoundBorderedButton.m
//  GBInfiniteScrollViewDemo
//
//  Created by Gerardo Blanco García on 08/02/14.
//  Copyright (c) 2014 ZIBLEC. All rights reserved.
//

#import "GBRoundBorderedButton.h"

static CGFloat const GBRoundBorderedButtonDefaultBorderWith = 2.0f;

@interface GBRoundBorderedButton()

@end

@implementation GBRoundBorderedButton

- (id)init
{
    self = [super init];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame normalColor:(UIColor *)normalColor highlightedColor:(UIColor *)highlightedColor borderWidth:(CGFloat) borderWidth
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.normalColor = normalColor;
        self.highlightedColor = highlightedColor;
        self.borderWidth = borderWidth;
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    [self setTitleColor:(self.normalColor ? self.normalColor : [self tintColor]) forState:UIControlStateNormal];
    [self setTitleColor:(self.highlightedColor ? self.highlightedColor : [UIColor whiteColor]) forState:UIControlStateHighlighted];
    
    [self setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    
    self.layer.cornerRadius = self.frame.size.height / 2.0f;
    self.layer.borderWidth = self.borderWidth ? self.borderWidth : GBRoundBorderedButtonDefaultBorderWith;
    
    [self refreshBorderColor];
}

- (void)setTintColor:(UIColor *)tintColor
{
    [super setTintColor:tintColor];
    [self setTitleColor:tintColor forState:UIControlStateNormal];
    [self refreshBorderColor];
}

- (void)setNormalColor:(UIColor *)normalColor
{
    _normalColor = normalColor;
    
    [self setTitleColor:(self.normalColor ? self.normalColor : [self tintColor]) forState:UIControlStateNormal];
    [self refreshBorderColor];
}

- (void)setHighlightedColor:(UIColor *)highlightedColor
{
    _highlightedColor = highlightedColor;
    
    [self setTitleColor:(self.highlightedColor ? self.highlightedColor : [UIColor whiteColor]) forState:UIControlStateHighlighted];
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    
    self.layer.borderWidth = _borderWidth ? _borderWidth : GBRoundBorderedButtonDefaultBorderWith;
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    [self refreshBorderColor];
}

- (void)refreshBorderColor
{
    self.layer.borderColor = [self isEnabled] ? [(self.normalColor ? self.normalColor : [self tintColor]) CGColor] : [[UIColor grayColor] CGColor];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    self.layer.backgroundColor = highlighted ? [(self.normalColor ? self.normalColor : [self tintColor]) CGColor] : [[UIColor clearColor] CGColor];
}

@end
