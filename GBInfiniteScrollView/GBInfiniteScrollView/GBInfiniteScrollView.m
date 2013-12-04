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
@property (nonatomic, strong) NSMutableArray *visibleIndices;

// Visible pages.
@property (nonatomic, strong) NSMutableArray *visiblePages;

// Reusable pages.
@property (nonatomic, strong) NSMutableArray *reusablePages;

// A boolean value that determines whether automatic scroll is enabled.
@property (nonatomic) BOOL autoScroll;

// Automatic scrolling timer.
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation GBInfiniteScrollView

#pragma mark - Initialization

- (id)init
{
    return [self initWithFrame:[UIScreen mainScreen].applicationFrame];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
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

#pragma mark - Lazy instantiation

- (NSMutableArray *)visibleIndices
{
    if (!_visibleIndices) {
        _visibleIndices = [[NSMutableArray alloc] init];
    }
    
    return _visibleIndices;
}

- (NSMutableArray *)visiblePages
{
    if (!_visiblePages) {
        _visiblePages = [[NSMutableArray alloc] init];
    }
    
    return _visiblePages;
}

- (NSMutableArray *)reusablePages
{
    if (!_reusablePages) {
        _reusablePages = [[NSMutableArray alloc] init];
    }
    
    return _reusablePages;
}

#pragma mark - Setup

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    self.bounces = NO;
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.userInteractionEnabled = YES;
    self.exclusiveTouch = YES;

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

- (void)updateCurrentPageIndex
{
    self.currentPageIndex = (self.pageIndex > [self lastPageIndex]) ? [self lastPageIndex] : fmaxf(self.pageIndex, 0.0f);
}

- (NSUInteger)nextPageIndex
{
    return [self nextIndex:self.currentPageIndex];
}

- (NSUInteger)previousPageIndex
{
    return [self previousIndex:self.currentPageIndex];
}

- (void)next
{
    self.currentPageIndex = [self nextPageIndex];
}

- (void)previous
{
    self.currentPageIndex = [self previousPageIndex];
}

- (GBInfiniteScrollViewPage *)pageAtIndex:(NSUInteger)index
{
    GBInfiniteScrollViewPage *page = nil;
    
    NSUInteger visibleIndex = [self.visibleIndices indexOfObject:[NSNumber numberWithUnsignedInteger:index]];
    
    if (visibleIndex != NSNotFound) {
        page = [self.visiblePages objectAtIndex:visibleIndex];
    } else if (self.infiniteScrollViewDataSource &&
               [self.infiniteScrollViewDataSource respondsToSelector:@selector(infiniteScrollView:pageAtIndex:)]) {
        page = [self.infiniteScrollViewDataSource infiniteScrollView:self pageAtIndex:index];
    }
    
    return page;
}

- (GBInfiniteScrollViewPage *)nextPage
{
    return [self pageAtIndex:[self nextPageIndex]];
}

- (GBInfiniteScrollViewPage *)currentPage
{
    return [self pageAtIndex:[self currentPageIndex]];
}

- (GBInfiniteScrollViewPage *)previousPage
{
    return [self pageAtIndex:[self previousPageIndex]];
}

#pragma mark - Visible pages

- (NSUInteger)numberOfVisiblePages
{
    return self.visibleIndices.count;
}

- (NSUInteger)firstVisiblePageIndex
{
    NSNumber *firstVisibleIndex = [self.visibleIndices firstObject];
    return [firstVisibleIndex integerValue];
}

- (NSUInteger)lastVisiblePageIndex
{
    NSNumber *lastVisibleIndex = [self.visibleIndices lastObject];
    return [lastVisibleIndex integerValue];
}

- (NSUInteger)nextVisiblePageIndex
{
    return [self nextIndex:[self lastVisiblePageIndex]];
}

- (NSUInteger)previousVisiblePageIndex
{
    return [self previousIndex:[self firstVisiblePageIndex]];
}

- (GBInfiniteScrollViewPage *)lastVisiblePage
{
    return [self pageAtIndex:[self lastVisiblePageIndex]];
}

- (GBInfiniteScrollViewPage *)firstVisiblePage
{
    return [self pageAtIndex:[self firstVisiblePageIndex]];
}

- (void)addNextVisiblePage:(GBInfiniteScrollViewPage *)page
{
    [self.visibleIndices addObject:[NSNumber numberWithUnsignedInteger:[self nextVisiblePageIndex]]];
    [self.visiblePages addObject:page];
}

- (void)addPreviousVisiblePage:(GBInfiniteScrollViewPage *)page
{
    [self.visibleIndices insertObject:[NSNumber numberWithUnsignedInteger:[self previousVisiblePageIndex]] atIndex:0];
    [self.visiblePages insertObject:page atIndex:0];
}

- (void)removeFirstVisiblePage
{
    GBInfiniteScrollViewPage *firstVisiblePage = [self firstVisiblePage];
    [firstVisiblePage removeFromSuperview];
    [self.reusablePages addObject:firstVisiblePage];
    [self.visibleIndices removeObjectAtIndex:0];
    [self.visiblePages removeObjectAtIndex:0];
}

- (void)removeLastVisiblePage
{
    GBInfiniteScrollViewPage *lastVisiblePage = [self lastVisiblePage];
    [[self lastVisiblePage] removeFromSuperview];
    [self.reusablePages addObject:lastVisiblePage];
    [self.visibleIndices removeLastObject];
    [self.visiblePages removeLastObject];
}

#pragma mark - Reusable pages

- (GBInfiniteScrollViewPage *)dequeueReusablePage
{
    GBInfiniteScrollViewPage *page = nil;
    
    page = [self.reusablePages lastObject];
    
    if (page) {
        [self.reusablePages removeLastObject];
        [page prepareForReuse];
    }
    
    return page;
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
    [self resetVisiblePages];
    [self layoutCurrentView];
}

- (void)resetReusablePages
{
    [self.reusablePages removeAllObjects];
}

- (void)resetVisiblePages
{
    NSUInteger currentPageIndex = [self currentPageIndex];
    GBInfiniteScrollViewPage *currentpage =  [self currentPage];
    
    for (int i = 0; i < self.visibleIndices.count; i++) {
        NSNumber *visibleIndex = [self.visibleIndices objectAtIndex:i];
        GBInfiniteScrollViewPage *visiblePage = [self.visiblePages objectAtIndex:i];
        
        if ([self currentPageIndex] != visibleIndex.integerValue) {
            [self.reusablePages addObject:visiblePage];
            [visiblePage removeFromSuperview];
        }
    }
    
    [self.visibleIndices removeAllObjects];
    [self.visibleIndices addObject:[NSNumber numberWithUnsignedInteger:currentPageIndex]];
    
    [self.visiblePages removeAllObjects];
    [self.visiblePages addObject:currentpage];}

- (void)layoutCurrentView
{
    [self resetContentSize];
    [self centerContentOffset];
    [self placePage:[self currentPage] atPoint:[self centerContentOffsetX]];
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
    [self movePage:[self currentPage] toPositionX:[self centerContentOffsetX]];
}

- (void)movePage:(GBInfiniteScrollViewPage *)page toPositionX:(CGFloat)positionX
{
    CGRect frame = page.frame;
    frame.origin.x =  positionX;
    page.frame = frame;
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
            [self previous];
            [self didScrollToNextPage];
        } else if (currentContentOffset.x == [self maxContentOffsetX]) {
            [self next];
            [self didScrollToNextPage];
        }
        
        [self updateNumberOfPages];
        [self resetVisiblePages];
        [self recenterCurrentView];
        [self setupTimer];
    }
}

#pragma mark - Pages tiling

- (void)placePage:(GBInfiniteScrollViewPage *)page atPoint:(CGFloat)point
{
    CGRect frame = [page frame];
    frame.origin.x = point;
    page.frame = frame;
    
    [self addSubview:page];
}

- (CGFloat)placePage:(GBInfiniteScrollViewPage *)page onRight:(CGFloat)rightEdge
{
    CGRect frame = [page frame];
    frame.origin.x = rightEdge;
    page.frame = frame;
    
    [self addSubview:page];
    [self addNextVisiblePage:page];
    
    return CGRectGetMaxX(frame);
}

- (CGFloat)placePage:(GBInfiniteScrollViewPage *)page onLeft:(CGFloat)leftEdge
{
    CGRect frame = [page frame];
    frame.origin.x = leftEdge - [self pageWidth];
    page.frame = frame;
    
    [self addSubview:page];
    [self addPreviousVisiblePage:page];
    
    return CGRectGetMinX(frame);
}

- (void)tileViewsFromMinX:(CGFloat)minimumVisibleX toMaxX:(CGFloat)maximumVisibleX
{
    CGFloat rightEdge = CGRectGetMaxX([self lastVisiblePage].frame);

    // Add views that are missing on right side.
    if (rightEdge < maximumVisibleX) {
        if ([self firstVisiblePageIndex] != [self currentPageIndex]) {
            [self removeFirstVisiblePage];
        }

        [self placePage:[self nextPage] onRight:rightEdge];
    }
    
    CGFloat leftEdge = CGRectGetMinX([self firstVisiblePage].frame);
        
    // Add views that are missing on left side.
    if (leftEdge > minimumVisibleX) {
        if ([self currentPageIndex] != [self lastVisiblePageIndex]) {
            [self removeLastVisiblePage];
        }

        [self placePage:[self previousPage] onLeft:leftEdge];
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
        CGRect frame = [self currentPage].frame;
        CGFloat x = CGRectGetMaxX(frame);
        CGFloat y = frame.origin.y;
        CGPoint point = CGPointMake(x, y);
        [self setContentOffset:point animated:YES];
    }
}

- (void)scrollToPreviousPage
{
    if ([self isScrollNecessary]) {
        CGRect frame = [self currentPage].frame;
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
