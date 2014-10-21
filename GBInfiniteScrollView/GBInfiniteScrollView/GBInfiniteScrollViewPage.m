//
//  GBInfiniteScrollViewPage.m
//  GBInfiniteScrollView
//
//  Created by Gerardo Blanco García on 02/12/13.
//  Copyright (c) 2013 Gerardo Blanco García. All rights reserved.
//

#import "GBInfiniteScrollViewPage.h"

CGFloat const GBInfiniteScrollViewPageMargin = 16.0f;

UIViewAutoresizing const GBInfiniteScrollViewPageResizeAll = UIViewAutoresizingFlexibleLeftMargin |
                                                             UIViewAutoresizingFlexibleWidth |
                                                             UIViewAutoresizingFlexibleRightMargin |
                                                             UIViewAutoresizingFlexibleTopMargin |
                                                             UIViewAutoresizingFlexibleHeight |
                                                             UIViewAutoresizingFlexibleBottomMargin;

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

- (void)setCustomView:(UIView *)customView
{
    if (_customView) {
        [_customView removeFromSuperview];
    }
    
    _customView = customView;
    
    if (_customView && (self.style == GBInfiniteScrollViewPageStyleCustom)) {
        [self setupCustomView];
    }
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
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:self.bounds];
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.clipsToBounds = YES;
        _contentView.userInteractionEnabled = YES;
        _contentView.exclusiveTouch = YES;
        _contentView.autoresizesSubviews = YES;
        _contentView.autoresizingMask = GBInfiniteScrollViewPageResizeAll;
        
        [self addSubview:_contentView];
    }
}

- (void)setupTextLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.autoresizingMask = GBInfiniteScrollViewPageResizeAll;
        
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
            _textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        }
        
        _textLabel.textAlignment = NSTextAlignmentCenter;
        
        [_contentView addSubview:_textLabel];
    }
}

- (void)setupImageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.autoresizingMask = GBInfiniteScrollViewPageResizeAll;
        
        [_contentView addSubview:_imageView];
    }
}

- (void)setupCustomView
{
    if (_customView) {
        [_contentView addSubview:_customView];
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
