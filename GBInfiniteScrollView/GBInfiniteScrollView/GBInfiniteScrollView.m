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

// Number of pages.
@property (nonatomic) NSUInteger numberOfPages;

// The current page index.
@property (nonatomic, readwrite) NSUInteger currentPageIndex;

// Array of visible indices.
@property (nonatomic, retain) NSMutableArray *visibleIndices;

// A boolean value that determines whether automatic scroll is enabled.
@property (nonatomic) BOOL autoScroll;

// Automatic scrolling timer.
@property (nonatomic, retain) NSTimer *timer;

@end

@implementation GBInfiniteScrollView

#pragma mark - Initializers

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

#pragma mark - Lazy instantiation

- (NSMutableArray *)visibleIndices
{
    if (!_visibleIndices) {
        _visibleIndices = [[NSMutableArray alloc] init];
    }
    
    return _visibleIndices;
}


#pragma mark - Setup

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    self.bounces = NO;
    self.delegate = self;
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;

    [self setupDefautValues];
}

- (void)setupDefautValues
{
    self.autoScroll = NO;
    self.pageIndex = [self firstPageIndex];
    self.currentPageIndex = [self firstPageIndex];
    self.direction = GBAutoScrollDirectionRightToLeft;
    self.interval = GBAutoScrollDefaultInterval;
}

- (void)setupTimer
{
    if (self.timer) {
        [self.timer invalidate];
    }
    
    if (self.autoScroll) {
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

#pragma mark - Convenient methods

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

- (void)updateNumberOfPages
{
    if (self.infiniteScrollViewDataSource &&
        [self.infiniteScrollViewDataSource respondsToSelector:@selector(numberOfPagesInInfiniteScrollView:)]) {
        self.numberOfPages = [self.infiniteScrollViewDataSource numberOfPagesInInfiniteScrollView:self];
    }
}

- (void)updateCurrentPageIndex
{
    self.currentPageIndex = (self.pageIndex > [self lastPageIndex]) ? [self lastPageIndex] : fmaxf(self.pageIndex, 0.0f);
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

- (UIView *)viewAtPageIndex:(NSUInteger)pageIndex
{
    UIView *viewAtPageIndex = nil;
    
    if (self.infiniteScrollViewDataSource &&
        [self.infiniteScrollViewDataSource respondsToSelector:@selector(infiniteScrollView:viewAtPageIndex:)]) {
        return [self.infiniteScrollViewDataSource infiniteScrollView:self viewAtPageIndex:pageIndex];
    }
    
    return viewAtPageIndex;
}

- (UIView *)nextView
{
    return [self viewAtPageIndex:[self nextPageIndex]];
}

- (UIView *)currentView
{
    return [self viewAtPageIndex:[self currentPageIndex]];
}

- (UIView *)previousView
{
    return [self viewAtPageIndex:[self previousPageIndex]];
}

#pragma mark - Visible views

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
    return [self.infiniteScrollViewDataSource infiniteScrollView:self viewAtPageIndex:[self lastVisibleIndex]];
}

- (UIView *)firstVisibleView
{
    return [self.infiniteScrollViewDataSource infiniteScrollView:self viewAtPageIndex:[self firstVisibleIndex]];
}

- (void)addCurrentVisibleIndex
{
    [self.visibleIndices addObject:[NSNumber numberWithUnsignedInteger:self.currentPageIndex]];
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

- (void)addNextVisibleIndex
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

#pragma mark - Content offset

- (CGFloat)minContentOffsetX
{
    return [self centerContentOffsetX] - [self distanceFromCenterOffsetX];
}

- (CGFloat)centerContentOffsetX
{
    return [self pageWidth];
}

- (CGFloat)maxContentOffsetX
{
    return [self centerContentOffsetX] + [self distanceFromCenterOffsetX];
}

- (CGFloat)distanceFromCenterOffsetX
{
    return [self pageWidth];
}

- (CGFloat)contentSizeWidth
{
    return [self pageWidth] * 3.0f;
}

#pragma mark - Layout

- (void)reloadData
{
    [self updateNumberOfPages];
    [self updateCurrentPageIndex];
    [self resetVisibleViews];
    [self layoutCurrentView];
}

- (void)resetVisibleViews
{
    for (NSNumber *index in self.visibleIndices) {
        if ([self currentPageIndex] != index.integerValue) {
            UIView *view = [self.infiniteScrollViewDataSource infiniteScrollView:self viewAtPageIndex:index.integerValue];
            [view removeFromSuperview];
        }
    }
    
    [self.visibleIndices removeAllObjects];
    [self.visibleIndices addObject:[NSNumber numberWithUnsignedInteger:[self currentPageIndex]]];
}


- (void)layoutCurrentView
{
    [self resetContentSize];
    [self centerContentOffset];
    [self placeView:[self currentView] atPoint:[self centerContentOffsetX]];
}

- (void)resetContentSize
{
    self.contentSize = CGSizeMake([self contentSizeWidth], self.frame.size.height);
}
- (void)centerContentOffset
{
    self.contentOffset = CGPointMake([self centerContentOffsetX], self.contentOffset.y);
}

- (void)recenterCurrentView
{
    [self centerContentOffset];
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

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if ([self isScrollNecessary]) {
        [self recenterContent];
        
        CGRect visibleBounds = [self bounds];
        CGFloat minimumVisibleX = CGRectGetMinX(visibleBounds);
        CGFloat maximumVisibleX = CGRectGetMaxX(visibleBounds);
        
        // Tile content in visible bounds.
        [self tileViewsFromMinX:minimumVisibleX toMaxX:maximumVisibleX];
    } else {
        [self recenterCurrentView];
        [self updateNumberOfPages];
    }
}

- (void)recenterContent
{
    CGPoint currentContentOffset = [self contentOffset];
    CGFloat distanceFromCenterOffsetX = fabs(currentContentOffset.x - [self centerContentOffsetX]);
    
    if (distanceFromCenterOffsetX == [self distanceFromCenterOffsetX]) {
        if (currentContentOffset.x == [self minContentOffsetX]) {
            [self previousPage];
            [self didScrollToNextPage];
        } else if (currentContentOffset.x == [self maxContentOffsetX]) {
            [self nextPage];
            [self didScrollToNextPage];
        }
        
        [self updateNumberOfPages];
        [self resetVisibleViews];
        [self recenterCurrentView];
        [self setupTimer];
    }
}

#pragma mark - Views tiling

- (void)placeView:(UIView *)view atPoint:(CGFloat)point
{
    CGRect frame = [view frame];
    frame.origin.x = point;
    view.frame = frame;
    
    [self addSubview:view];
}

- (CGFloat)placeView:(UIView *)view onRight:(CGFloat)rightEdge
{
    CGRect frame = [view frame];
    frame.origin.x = rightEdge;
    view.frame = frame;
    
    [self addSubview:view];
    
    [self addNextVisibleIndex];
    
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

#pragma mark - Scroll

- (void)stopAutoScroll
{
    self.autoScroll = NO;
    
    if (self.timer) {
        [self.timer invalidate];
    }
}

- (void)startAutoScroll
{
    self.autoScroll = YES;
    
    [self setupTimer];
}

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

- (void)didScrollToNextPage
{
    if (self.infiniteScrollViewDelegate &&
        [self.infiniteScrollViewDelegate respondsToSelector:@selector(infiniteScrollViewDidScrollNextPage:)]) {
        [self.infiniteScrollViewDelegate infiniteScrollViewDidScrollNextPage:self];
    }
}

- (void)didScrollToPreviousPage
{
    if (self.infiniteScrollViewDelegate &&
        [self.infiniteScrollViewDelegate respondsToSelector:@selector(infiniteScrollViewDidScrollPreviousPage:)]) {
        [self.infiniteScrollViewDelegate infiniteScrollViewDidScrollPreviousPage:self];
    }
}

@end
