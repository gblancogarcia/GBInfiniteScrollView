//
//  GBInfiniteScrollViewPage.m
//  GBInfiniteScrollView
//
//  Created by Gerardo Blanco García on 02/12/13.
//  Copyright (c) 2013 Gerardo Blanco García. All rights reserved.
//

#import "GBInfiniteScrollViewPage.h"

CGFloat const GBInfiniteScrollViewPageMargin = 16.0f;

@interface GBInfiniteScrollViewPage ()

@property (nonatomic) GBInfiniteScrollViewPageStyle style;

@property (nonatomic, strong, readwrite) UIView *contentView;

@property (nonatomic, strong, readwrite) UILabel *textLabel;

@property (nonatomic, strong, readwrite) UIImageView *imageView;

@end

@implementation GBInfiniteScrollViewPage

#pragma mark - Setup

- (id)initWithStyle:(GBInfiniteScrollViewPageStyle)style
{
    self = [self initWithFrame:[UIScreen mainScreen].applicationFrame];
    
    if (self) {
        self.style = style;
        [self setup];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(GBInfiniteScrollViewPageStyle)style
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.style = style;
        [self setup];
    }
    
    return self;
}

#pragma mark - Setup

- (void)setup
{
    [self setupContentView];
    
    if (self.style == GBInfiniteScrollViewPageStyleText) {
        [self setupTextLabel];
    } else if (self.style == GBInfiniteScrollViewPageStyleImage) {
        [self setupImageView];
    }
}

- (void)setupContentView
{
    if (!self.contentView) {
        self.contentView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.contentView.clipsToBounds = YES;
        self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addSubview:self.contentView];
        
        NSDictionary *views = @{@"contentView" : self.contentView};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:views]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:views]];
    }
}

- (void)setupTextLabel
{
    if (!self.textLabel) {
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.contentView addSubview:self.textLabel];
        
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.textLabel
                                                                attribute:NSLayoutAttributeLeft
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.contentView
                                                                attribute:NSLayoutAttributeLeft
                                                               multiplier:1.0f
                                                                 constant:GBInfiniteScrollViewPageMargin];
        
        [self.contentView addConstraint:left];
        
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.textLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0f
                                                                  constant:GBInfiniteScrollViewPageMargin * -1];
        
        [self.contentView addConstraint:right];
        
        NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self.textLabel
                                                                   attribute:NSLayoutAttributeCenterY
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.contentView
                                                                   attribute:NSLayoutAttributeCenterY
                                                                  multiplier:1.0f
                                                                    constant:0.0f];
        
        [self.contentView addConstraint:centerY];
    }
}

- (void)setupImageView
{
    if (!self.imageView) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.contentView addSubview:self.imageView];
        
        NSDictionary *views = @{@"imageView" : self.imageView};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView]|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:views]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView]|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:views]];
    }
}

- (void)setBackgroundView:(UIView *)backgroundView
{
    _backgroundView = backgroundView;
    
    if (_backgroundView) {
        _backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addSubview:_backgroundView];
        [self sendSubviewToBack:_backgroundView];
        
        NSDictionary *views = @{@"backgroundView" : _backgroundView};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[backgroundView]|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:views]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[backgroundView]|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:views]];
    }
}

- (void)prepareForReuse
{
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    self.textLabel = nil;
    self.imageView = nil;
    self.backgroundView = nil;
    
    [self setup];
}

@end
