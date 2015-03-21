//
//  GBInfiniteScrollViewWithPageControl.m
//  GBInfiniteScrollView
//
//  Created by Guillermo Saenz on 6/1/14.
//  Copyright (c) 2014 Gerardo Blanco García. All rights reserved.
//

#import "GBInfiniteScrollViewWithPageControl.h"

@interface GBInfiniteScrollViewWithPageControl ()

@property (nonatomic, getter = isPageControlRotated) BOOL pageControlRotated;

@property (nonatomic) CGSize pageSize;

@end

@implementation GBInfiniteScrollViewWithPageControl

#pragma mark - Initialization

- (id)init
{
    return [super init];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupSubClass];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setupSubClass];
    }
    
    return self;
}

#pragma mark - Setup

- (void)setupSubClass
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }

    [self setDelegate:self];
    
    self.pageControlViewContainer = [[GBPageControlViewContainer alloc] init];
    
    [self setPageControlPosition:GBPageControlPositionHorizontalBottom];
    [self setPageControlRotated:NO];
    [self setMaxDots:0];
}

- (void)setupDefaultValuesPageControl
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    
    [self.pageControlViewContainer setFrame:[self pageControlFrame]];
    
    [self checkOrientation];
    
    [self.pageControlViewContainer setCenter:[self pageControlCenter]];
    
    [self.pageControlViewContainer.pageControl setNumberOfPages:[self.infiniteScrollViewDataSource numberOfPagesInInfiniteScrollView:self]];
    [self.pageControlViewContainer.pageControl setCurrentPage:self.currentPageIndex];

    if (![self.superview.subviews containsObject:self.pageControlViewContainer])[self.superview addSubview:self.pageControlViewContainer];
}

- (CGRect)pageControlFrame
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    CGRect pageControlFrame = self.pageControlViewContainer.frame;
    pageControlFrame.size.height = [self.pageControlViewContainer.pageControl sizeForNumberOfPages:1].height;
    
    if ([self needsRotation]) {
        pageControlFrame.size.width = self.frame.size.height;
    }else{
        pageControlFrame.size.width = self.frame.size.width;
    }
    
    return pageControlFrame;
}

- (CGPoint)pageControlCenter
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    CGPoint pageControlCenter = CGPointZero;
    switch ([self getPageControlPosition]) {
        case GBPageControlPositionHorizontalBottom:
            pageControlCenter.x = self.frame.origin.x + self.pageControlViewContainer.frame.size.width/2;
            pageControlCenter.y = self.frame.origin.y + self.frame.size.height - self.pageControlViewContainer.frame.size.height/2;
            break;
        case GBPageControlPositionHorizontalTop:
            pageControlCenter.x = self.frame.origin.x + self.pageControlViewContainer.frame.size.width/2;
            pageControlCenter.y = self.frame.origin.y + self.pageControlViewContainer.frame.size.height/2;
            break;
        case GBPageControlPositionVerticalLeft:
            pageControlCenter.x = self.frame.origin.x + self.pageControlViewContainer.frame.size.width/2;
            pageControlCenter.y = self.frame.origin.y + self.pageControlViewContainer.frame.size.height/2;
            break;
        case GBPageControlPositionVerticalRight:
            pageControlCenter.x = self.frame.origin.x + self.frame.size.width - self.pageControlViewContainer.frame.size.width/2;
            pageControlCenter.y = self.frame.origin.y + self.pageControlViewContainer.frame.size.height/2;
            break;
        default:
            pageControlCenter = self.center;
            break;
    }
    
    return pageControlCenter;
}

- (GBPageControlPosition)getPageControlPosition
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (self.scrollDirection==GBScrollDirectionHorizontal) {
        if (self.pageControlPosition!=GBPageControlPositionHorizontalBottom && self.pageControlPosition!=GBPageControlPositionHorizontalTop) {
            if (self.pageControlPosition==GBPageControlPositionVerticalLeft) {
                self.pageControlPosition = GBPageControlPositionHorizontalBottom;
            }else{
                self.pageControlPosition = GBPageControlPositionHorizontalTop;
            }
        }
    }else{
        if (self.pageControlPosition!=GBPageControlPositionVerticalLeft && self.pageControlPosition!=GBPageControlPositionVerticalRight) {
            if (self.pageControlPosition==GBPageControlPositionHorizontalBottom) {
                self.pageControlPosition = GBPageControlPositionVerticalLeft;
            }else{
                self.pageControlPosition = GBPageControlPositionVerticalRight;
            }
        }
    }
    
    return self.pageControlPosition;
}

- (void)checkOrientation
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if ([self needsRotation]) {
        [self.pageControlViewContainer setTransform:CGAffineTransformRotate(self.pageControlViewContainer.transform, M_PI_2)];
        [self setPageControlRotated:YES];
    }
}

- (BOOL)needsRotation
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (self.scrollDirection==GBScrollDirectionVertical && !self.isPageControlRotated) {
        return YES;
    }
    
    return NO;
}

- (BOOL)fitsPageControlSizeForNumberOfPages:(NSInteger)numberOfPages
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }

    FXPageControl *pageControl = self.pageControlViewContainer.pageControl;
    
    NSInteger maxDotNumber = 0;
    
    if (self.isPageControlRotated) {
        maxDotNumber = (self.pageControlViewContainer.frame.size.height - pageControl.dotSpacing) / (pageControl.dotSize+pageControl.dotSpacing);
    }else{
        maxDotNumber = (self.pageControlViewContainer.frame.size.width - pageControl.dotSpacing) / (pageControl.dotSize+pageControl.dotSpacing);
    }
    
    return numberOfPages<=maxDotNumber;
}

#pragma mark - Layout

- (void)didMoveToSuperview
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [super didMoveToSuperview];
    
    [self setupDefaultValuesPageControl];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if ((self.scrollDirection == GBScrollDirectionHorizontal && self.pageSize.width  != self.frame.size.width) ||
        (self.scrollDirection == GBScrollDirectionVertical   && self.pageSize.height != self.frame.size.height)) {
        self.pageSize = self.frame.size;
        [self setupDefaultValuesPageControl];
    }
}

- (void)setupPageControl
{
    NSInteger numberOfPages = [self.infiniteScrollViewDataSource numberOfPagesInInfiniteScrollView:self];
    
    if ([self fitsPageControlSizeForNumberOfPages:numberOfPages]) {
        if (self.maxDots>0) {
            if (numberOfPages<=self.maxDots) {
                [self.pageControlViewContainer.pageControl setNumberOfPages:numberOfPages];
            }else{
                [self.pageControlViewContainer.pageControl setNumberOfPages:self.maxDots];
            }
        }else{
            [self.pageControlViewContainer.pageControl setNumberOfPages:numberOfPages];
        }
    }else{
        [self.pageControlViewContainer.pageControl setNumberOfPages:0];
    }
}

- (void)reloadData
{
    [self setupPageControl];
    [super reloadData];
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [self setupPageControl];
    if ([self.infiniteScrollViewDelegate respondsToSelector:@selector(infiniteScrollViewWillBeginDragging:)]) {
        [self.infiniteScrollViewDelegate infiniteScrollViewWillBeginDragging:self];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if ([self.infiniteScrollViewDelegate respondsToSelector:@selector(infiniteScrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
        [self.infiniteScrollViewDelegate infiniteScrollViewWillEndDragging:self withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }

    if (self.pageControlViewContainer.pageControl.numberOfPages>=self.currentPageIndex) {
        [self.pageControlViewContainer.pageControl setCurrentPage:self.currentPageIndex];
    }
}

@end

@implementation GBPageControlViewContainer

- (id)init
{
    self = [super init];
    
    if (self) {
        [self setupView];
    }
    
    return self;
}

- (void)setupView{
    [self setClipsToBounds:YES];
    
    self.pageControl = [[FXPageControl alloc] init];
    [self.pageControl setBackgroundColor:[UIColor clearColor]];
    [self.pageControl setDefersCurrentPageDisplay:YES];
    
    [self addSubview:self.pageControl];
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    frame.origin = CGPointZero;
    
    [self.pageControl setFrame:frame];
}

@end
