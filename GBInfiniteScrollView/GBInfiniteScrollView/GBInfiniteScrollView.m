//
//  GBInfiniteScrollView.h
//  GBInfiniteScrollView
//
//  Created by Gerardo Blanco García on 01/10/13.
//  Copyright (c) 2013 Gerardo Blanco García. All rights reserved.
//

#import "GBInfiniteScrollView.h"

static CGFloat const GBAutoScrollDefaultInterval = 3.0f;

@interface GBInfiniteScrollView ()

// Array of UIViews.
@property (nonatomic, retain) NSMutableArray *views;

// Array of pending views to add.
@property (nonatomic, retain) NSMutableArray *pendingViews;

// The placesholder view.
@property (nonatomic, retain) UIView *placeholder;

// The current page index.
@property (nonatomic) NSUInteger currentPageIndex;

// Array of visible indices.
@property (nonatomic, retain) NSMutableArray *visibleIndices;

// A boolean value that determines whether automatic scroll is enabled.
@property (nonatomic) BOOL autoScroll;

// Automatic scroll time interval.
@property (nonatomic) CGFloat interval;

// Automatic scroll timer.
@property (nonatomic, retain) NSTimer *timer;

// Automatic scroll direction (right to left or left to right).
@property (nonatomic) GBAutoScrollDirection direction;

@end

@implementation GBInfiniteScrollView

- (id)initWithFrame:(CGRect)frame views:(NSMutableArray *)views
{    
    self = [super initWithFrame:frame];
    if (self) {
        self.views = [views mutableCopy];
        self.autoScroll = NO;
        self.interval = 0.0f;
        self.direction = GBAutoScrollDirectionRightToLeft;
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame views:(NSMutableArray *)views autoScroll:(BOOL)autoScroll
{
    self = [super initWithFrame:frame];
    if (self) {
        self.views = [views mutableCopy];
        self.autoScroll = autoScroll;
        self.interval = GBAutoScrollDefaultInterval;
        self.direction = GBAutoScrollDirectionRightToLeft;
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame views:(NSMutableArray *)views autoScroll:(BOOL)autoScroll interval:(CGFloat)interval
{
    self = [super initWithFrame:frame];
    if (self) {
        self.views = [views mutableCopy];
        self.autoScroll = autoScroll;
        self.interval = interval;
        self.direction = GBAutoScrollDirectionRightToLeft;
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame views:(NSMutableArray *)views autoScroll:(BOOL)autoScroll interval:(CGFloat)interval direction:(GBAutoScrollDirection)direction
{
    self = [super initWithFrame:frame];
    if (self) {
        self.views = [views mutableCopy];
        self.autoScroll = autoScroll;
        self.interval = interval;
        self.direction = direction;
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame placeholder:(UIView *)placeholder
{
    self = [super initWithFrame:frame];
    if (self) {
        self.views = [[NSMutableArray alloc] init];
        self.placeholder = placeholder;
        self.autoScroll = NO;
        self.interval = 0.0f;
        self.direction = GBAutoScrollDirectionRightToLeft;
        [self setup];
    }
    return self;
}

#pragma mark - Setup

- (void)setup
{
    self.delegate = self;
    self.backgroundColor = [UIColor whiteColor];
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.bounces = NO;
    
    self.pendingViews = [[NSMutableArray alloc] init];
    self.currentPageIndex = [self firstPageIndex];
    self.visibleIndices = [[NSMutableArray alloc] init];
    
    if (self.isEmpty) {
        [self setupPlaceholder];
    } else {
        [self setupCurrentView];
    }
    
    [self setupContentSize];
    [self setupTimer];
}

- (void)setupPlaceholder
{
    [self addSubview:self.placeholder];
}

- (void)setupCurrentView
{
    [self placeView:[self currentView] onRight:[self centerContentOffsetX]];
}

- (void)setupContentSize
{
    self.contentSize = CGSizeMake([self contentSizeWidth], self.frame.size.height);
    self.contentOffset = CGPointMake([self centerContentOffsetX], self.contentOffset.y);
}

- (void)setupTimer
{
    if (self.autoScroll && [self isScrollNecessary]) {
        if (self.timer) {
            [self.timer invalidate];
        }
        
        if (self.direction == GBAutoScrollDirectionLeftToRight) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:self.interval
                                                          target:self
                                                        selector:@selector(scrollToPreviousPage)
                                                        userInfo:nil
                                                         repeats:YES];
        } else {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:self.interval
                                                          target:self
                                                        selector:@selector(scrollToNextPage)
                                                        userInfo:nil
                                                         repeats:YES];
        }
    }
}

#pragma mark - autoScroll

- (void)setAutoScroll:(BOOL)autoScroll interval:(CGFloat)interval
{
    self.autoScroll = autoScroll;
    self.interval = interval;
    self.direction = GBAutoScrollDirectionRightToLeft;
    [self setupTimer];
}

- (void)setAutoScroll:(BOOL)autoScroll interval:(CGFloat)interval direction:(GBAutoScrollDirection)direction
{
    self.autoScroll = autoScroll;
    self.interval = interval;
    self.direction = direction;
    [self setupTimer];
}

#pragma mark -

- (BOOL)isEmpty
{
    return ([self numberOfPages] == 0);
}

- (BOOL)isNotEmpty
{
    return (self.isEmpty ? NO : YES);
}

- (BOOL)singlePage
{
    return ([self numberOfPages] == 1);
}

- (BOOL)isScrollNecessary
{
    return (self.isScrollNotNecessary ? NO : YES);
}

- (BOOL)isScrollNotNecessary
{
    return ([self isEmpty] || [self singlePage]);
}

#pragma mark - Pages

- (NSUInteger)numberOfPages
{
    return [self.views count];
}

- (CGFloat)pageWidth
{
    return self.frame.size.width;
}

- (NSUInteger)firstPageIndex
{
    return 0;
}

- (NSUInteger)lastPageIndex
{
    return fmax([self firstPageIndex], [self numberOfPages] - 1);
}

- (NSUInteger)nextIndex:(NSUInteger)index
{
    return (index == [self lastPageIndex]) ? [self firstPageIndex] : (index + 1);
}

- (NSUInteger)previousIndex:(NSUInteger)index
{
    return (index == [self firstPageIndex]) ? [self lastPageIndex] : (index - 1);
}

- (NSUInteger)nextPageIndex
{
    return [self nextIndex:self.currentPageIndex];
}

- (NSUInteger)previousPageIndex
{
    return [self previousIndex:self.currentPageIndex];
}

- (void)nextPage
{
    self.currentPageIndex = [self nextPageIndex];
}

- (void)previousPage
{
    self.currentPageIndex = [self previousPageIndex];
}

#pragma mark - Views

- (UIView *)nextView
{
    return [self.views objectAtIndex:[self nextPageIndex]];
}

- (UIView *)currentView
{
    return [self.views objectAtIndex:[self currentPageIndex]];
}

- (UIView *)previousView
{
    return [self.views objectAtIndex:[self previousPageIndex]];
}

#pragma mark - Visible Views

- (NSUInteger)numberOfVisibleViews
{
    return self.visibleIndices.count;
}

- (NSUInteger)firstVisibleIndex
{
    NSNumber *firstVisibleIndex = [self.visibleIndices firstObject];
    return [firstVisibleIndex integerValue];
}

- (NSUInteger)lastVisibleIndex
{
    NSNumber *lastVisibleIndex = [self.visibleIndices lastObject];
    return [lastVisibleIndex integerValue];
}

- (UIView *)lastVisibleView
{
    return [self.views objectAtIndex:[self lastVisibleIndex]];
}

- (UIView *)firstVisibleView
{
    return [self.views objectAtIndex:[self firstVisibleIndex]];
}

- (void)addPreviousVisibleIndex
{
    NSUInteger previousVisibleIndex = [self previousIndex:[self firstVisibleIndex]];
    [self.visibleIndices insertObject:[NSNumber numberWithUnsignedInteger:previousVisibleIndex] atIndex:0];
}

- (void)removeFirstVisibleIndex
{
    [self.visibleIndices removeObjectAtIndex:0];
}

- (void)removeFirstVisibleView
{
    [[self firstVisibleView] removeFromSuperview];
    [self removeFirstVisibleIndex];
}

- (void)addNexVisibleIndex
{
    NSUInteger nextVisibleIndex = [self nextIndex:[self lastVisibleIndex]];
    [self.visibleIndices addObject:[NSNumber numberWithUnsignedInteger:nextVisibleIndex]];
}

- (void)removeLastVisibleIndex
{
    [self.visibleIndices removeLastObject];
}

- (void)removeLastVisibleView
{
    [[self lastVisibleView] removeFromSuperview];
    [self removeLastVisibleIndex];
}

#pragma mark - Content Offset

- (CGFloat)minContentOffsetX
{
    return [self centerContentOffsetX] - [self distanceFromCenterOffsetX];
}

- (CGFloat)centerContentOffsetX
{
    return ([self isScrollNecessary] ? [self pageWidth] : 0.0f);
}

- (CGFloat)maxContentOffsetX
{
    return [self centerContentOffsetX] + [self distanceFromCenterOffsetX];
}

- (CGFloat)distanceFromCenterOffsetX
{
    return ([self isScrollNecessary] ? [self pageWidth] : 0.0f);
}

- (CGFloat)contentSizeWidth
{
    CGFloat contentSizeWidth = [self pageWidth];
    
    if ([self isScrollNecessary]) {
        contentSizeWidth = [self pageWidth] * 3.0f;
    }
    
    return contentSizeWidth;
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if ([self isNotEmpty]) {
        // Recenter content if necessary.
        [self recenterIfNecessary];
        
        CGRect visibleBounds = [self bounds];
        CGFloat minimumVisibleX = CGRectGetMinX(visibleBounds);
        CGFloat maximumVisibleX = CGRectGetMaxX(visibleBounds);
        
        // Tile content in visible bounds.
        [self tileViewsFromMinX:minimumVisibleX toMaxX:maximumVisibleX];
    }
}

- (void)addPendingViews
{
    if (self.pendingViews.count != 0) {
        for(UIView *view in self.pendingViews) {
            [self.views addObject:view];
        }
        
        [self.pendingViews removeAllObjects];
    }
}

- (void)recenterIfNecessary
{
    CGPoint currentContentOffset = [self contentOffset];
    CGFloat distanceFromCenterOffsetX = fabs(currentContentOffset.x - [self centerContentOffsetX]);
    
    if (distanceFromCenterOffsetX == [self distanceFromCenterOffsetX]) {
        self.contentOffset = CGPointMake([self centerContentOffsetX], currentContentOffset.y);

        if (currentContentOffset.x == [self minContentOffsetX]) {
            [self previousPage];
        } else if (currentContentOffset.x == [self maxContentOffsetX]) {
            [self nextPage];
        }

        [self resetVisibleViews];
        [self recenterCurrentView];
        [self setupTimer];
        
        // Check if there is pending views to add.
        [self addPendingViews];
    }
}

- (void)resetVisibleViews
{
    for (NSNumber *index in self.visibleIndices) {
        if ([self currentPageIndex] != index.integerValue) {
            UIView *view = [self.views objectAtIndex:index.integerValue];
            [view removeFromSuperview];
        }
    }
    
    [self.visibleIndices removeAllObjects];
    [self.visibleIndices addObject:[NSNumber numberWithUnsignedInteger:[self currentPageIndex]]];
}

- (void)recenterCurrentView
{
    [self moveView:[self currentView] toPositionX:[self centerContentOffsetX]];
}

- (void)moveView:(UIView *)view deltaX:(CGFloat)delta
{
    CGPoint center = view.center;
    center.x +=  delta;
    view.center = center;
}

- (void)moveView:(UIView *)view toPositionX:(CGFloat)positionX
{
    CGRect frame = view.frame;
    frame.origin.x =  positionX;
    view.frame = frame;
}

#pragma mark - Views Tiling

- (CGFloat)placeView:(UIView *)view onRight:(CGFloat)rightEdge
{
    CGRect frame = [view frame];
    frame.origin.x = rightEdge;
    view.frame = frame;
    
    [self addSubview:view];
    
    [self addNexVisibleIndex];
    
    return CGRectGetMaxX(frame);
}

- (CGFloat)placeView:(UIView *)view onLeft:(CGFloat)leftEdge
{
    CGRect frame = [view frame];
    frame.origin.x = leftEdge - [self pageWidth];
    view.frame = frame;
    
    [self addSubview:view];
    
    [self addPreviousVisibleIndex];
    
    return CGRectGetMinX(frame);
}

- (void)tileViewsFromMinX:(CGFloat)minimumVisibleX toMaxX:(CGFloat)maximumVisibleX
{
    CGFloat rightEdge = CGRectGetMaxX([self lastVisibleView].frame);

    // Add views that are missing on right side.
    if (rightEdge < maximumVisibleX) {
        if ([self firstVisibleIndex] != [self currentPageIndex]) {
            [self removeFirstVisibleView];
        }

        [self placeView:[self nextView] onRight:rightEdge];
    }
    
    CGFloat leftEdge = CGRectGetMinX([self firstVisibleView].frame);
        
    // Add views that are missing on left side.
    if (leftEdge > minimumVisibleX) {
        if ([self currentPageIndex] != [self lastVisibleIndex]) {
            [self removeLastVisibleView];
        }

        [self placeView:[self previousView] onLeft:leftEdge];
    }
}

- (void)addView:(UIView *)view
{
    if ([self isEmpty]) {
        [self.views addObject:view];
        [self.placeholder removeFromSuperview];
        [self setupCurrentView];
    } else if ([self singlePage]) {
        [self.views addObject:view];
        [self setupContentSize];
        [self setupTimer];
        [self recenterCurrentView];
    } else {
        [self setupTimer];
        [self.pendingViews addObject:view];
    }
}

- (void)resetWithViews:(NSMutableArray *)views
{
    for (NSNumber *index in self.visibleIndices) {
        UIView *view = [self.views objectAtIndex:index.integerValue];
        [view removeFromSuperview];
    }
    
    [self.visibleIndices removeAllObjects];
    
    self.views = views;
    self.pendingViews = [[NSMutableArray alloc] init];
    self.currentPageIndex = [self firstPageIndex];
    
    if (self.isEmpty) {
        [self setupPlaceholder];
    } else {
        [self setupCurrentView];
    }
    
    [self setupContentSize];
    [self setupTimer];
}

#pragma mark - Scroll

- (void)scrollToNextPage
{
    if ([self isScrollNecessary]) {
        CGRect frame = [self currentView].frame;
        CGFloat x = CGRectGetMaxX(frame);
        CGFloat y = frame.origin.y;
        CGPoint point = CGPointMake(x, y);
        [self setContentOffset:point animated:YES];
    }
}

- (void)scrollToPreviousPage
{
    if ([self isScrollNecessary]) {
        CGRect frame = [self currentView].frame;
        CGFloat x = CGRectGetMinX(frame) - [self pageWidth];
        CGFloat y = frame.origin.y;
        CGPoint point = CGPointMake(x, y);
        [self setContentOffset:point animated:YES];
    }
}

@end