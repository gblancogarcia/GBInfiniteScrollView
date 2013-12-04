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

#pragma mark - Lazy instantiation

- (UIView *)contentView
{
    if (!_contentView) {
        [self setupContentView];
    }
    
    return _contentView;
}

- (void)setCustomView:(UIView *)customView
{
    if (_customView) {
        [_customView removeFromSuperview];
    }
    
    _customView = customView;
    
    if (self.style == GBInfiniteScrollViewPageStyleCustom) {
        [self setupCustomView];
    }
}

#pragma mark - Setup

- (void)setup
{
    if (self.style == GBInfiniteScrollViewPageStyleText) {
        [self setupTextLabel];
    } else if (self.style == GBInfiniteScrollViewPageStyleImage) {
        [self setupImageView];
    }
}

- (void)setupContentView
{
    if (!_contentView) {
        _contentView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.clipsToBounds = YES;
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        _contentView.userInteractionEnabled = YES;
        _contentView.exclusiveTouch = YES;
        
        [self addSubview:_contentView];
        
        NSDictionary *views = @{@"contentView" : _contentView};
        
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

- (void)setupCustomView
{
    if (self.customView) {
        [self.contentView addSubview:_customView];
        [self.contentView sendSubviewToBack:_customView];
        
        self.customView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.contentView addSubview:_customView];
        
        NSDictionary *views = @{@"customView" : self.customView};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[customView]|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:views]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[customView]|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:views]];
        
        
    }
}

#pragma mark - Reuse

- (void)prepareForReuse
{
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    self.textLabel = nil;
    self.imageView = nil;
    self.customView = nil;
    
    [self setup];
}

@end
