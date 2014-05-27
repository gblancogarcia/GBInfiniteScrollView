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

/**
 *  Number of pages.
 */
@property (nonatomic) NSUInteger numberOfPages;

/**
 *  The current page index.
 */
@property (nonatomic, readwrite) NSUInteger currentPageIndex;

/**
 *  Array of visible indices.
 */
@property (nonatomic, strong) NSMutableArray *visibleIndices;

/**
 *  Visible pages.
 */
@property (nonatomic, strong) NSMutableArray *visiblePages;

/**
 *  Reusable pages.
 */
@property (nonatomic, strong) NSMutableArray *reusablePages;

/**
 *  A boolean value that determines whether automatic scroll is enabled.
 */
@property (nonatomic) BOOL autoScroll;

/**
 *  Automatic scrolling timer.
 */
@property (nonatomic, strong) NSTimer *timer;

/**
 *  A boolean value that determines whether there is need to reload.
 */
@property (nonatomic) BOOL needsReloadData;

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
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    if (!_visibleIndices) {
        _visibleIndices = [[NSMutableArray alloc] init];
    }
    
    return _visibleIndices;
}

- (NSMutableArray *)visiblePages
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    if (!_visiblePages) {
        _visiblePages = [[NSMutableArray alloc] init];
    }
    
    return _visiblePages;
}

- (NSMutableArray *)reusablePages
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    if (!_reusablePages) {
        _reusablePages = [[NSMutableArray alloc] init];
    }
    
    return _reusablePages;
}

#pragma mark - Setup

- (void)setup
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    self.backgroundColor = [UIColor clearColor];
    self.bounces = NO;
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.userInteractionEnabled = YES;
    self.exclusiveTouch = YES;

    [self setupDefautValues];
}

- (void)setupDefautValues
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    self.autoScroll = NO;
    self.shouldScrollingWrapDataSource = YES;
    self.pageIndex = [self firstPageIndex];
    self.currentPageIndex = [self firstPageIndex];
    self.scrollDirection = GBScrollDirectionHorizontal;
    self.autoScrollDirection = GBAutoScrollDirectionRightToLeft;
    self.interval = GBAutoScrollDefaultInterval;
}

- (void)setupTimer
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    if (self.timer) {
        [self.timer invalidate];
    }
    
    if (self.autoScroll) {
        if (self.autoScrollDirection == GBAutoScrollDirectionLeftToRight || self.autoScrollDirection == GBAutoScrollDirectionTopToBottom) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:self.interval
                                                          target:self
                                                        selector:@selector(scrollToPreviousPage)
                                                        userInfo:nil
                                                         repeats:YES];
        } else if (self.autoScrollDirection == GBAutoScrollDirectionRightToLeft || self.autoScrollDirection == GBAutoScrollDirectionBottomToTop){
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
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    return ([self numberOfPages] == 0);
}

- (BOOL)isNotEmpty
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    return (self.isEmpty ? NO : YES);
}

- (BOOL)singlePage
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    return ([self numberOfPages] == 1);
}

- (BOOL)isScrollNecessary
{
    return (self.isScrollNotNecessary ? NO : YES);
}

- (BOOL)isScrollNotNecessary
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    return ([self isEmpty] || [self singlePage]);
}

- (BOOL)isLastPage
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    return (self.currentPageIndex==[self lastPageIndex]?YES:NO);
}

- (BOOL)isFirstPage
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    return (self.currentPageIndex==[self firstPageIndex]?YES:NO);
}

#pragma mark - Pages

- (void)updateNumberOfPages
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    if (self.infiniteScrollViewDataSource &&
        [self.infiniteScrollViewDataSource respondsToSelector:@selector(numberOfPagesInInfiniteScrollView:)]) {
        self.numberOfPages = [self.infiniteScrollViewDataSource numberOfPagesInInfiniteScrollView:self];
    }
}

- (CGFloat)pageWidth
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    return self.frame.size.width;
}

- (CGFloat)pageHeight
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    return self.frame.size.height;
}

- (NSUInteger)firstPageIndex
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    return 0;
}

- (NSUInteger)lastPageIndex
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    return fmax([self firstPageIndex], [self numberOfPages] - 1);
}

- (NSUInteger)nextIndex:(NSUInteger)index
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    return (index == [self lastPageIndex]) ? [self firstPageIndex] : (index + 1);
}

- (NSUInteger)previousIndex:(NSUInteger)index
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    return (index == [self firstPageIndex]) ? [self lastPageIndex] : (index - 1);
}

- (void)updateCurrentPageIndex
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    self.currentPageIndex = (self.pageIndex > [self lastPageIndex]) ? [self lastPageIndex] : fmaxf(self.pageIndex, 0.0f);
}

- (NSUInteger)nextPageIndex
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    if (!self.shouldScrollingWrapDataSource && [self isLastPage]) return self.currentPageIndex;
    return [self nextIndex:self.currentPageIndex];
}

- (NSUInteger)previousPageIndex
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    if (!self.shouldScrollingWrapDataSource && [self isFirstPage]) return self.currentPageIndex;
    return [self previousIndex:self.currentPageIndex];
}

- (void)next
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    if (self.debug) {
        NSLog(@"GBInfiniteScrollView: Next: %lu", (unsigned long)[self nextPageIndex]);
    }
    
    self.currentPageIndex = [self nextPageIndex];
}

- (void)previous
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    if (self.debug) {
        NSLog(@"GBInfiniteScrollView: Previous: %lu", (unsigned long)[self previousPageIndex]);
    }
    
    self.currentPageIndex = [self previousPageIndex];
}

- (GBInfiniteScrollViewPage *)pageAtIndex:(NSUInteger)index
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    GBInfiniteScrollViewPage *page = nil;
    
    NSUInteger visibleIndex = [self.visibleIndices indexOfObject:[NSNumber numberWithUnsignedInteger:index]];
    
    if ((visibleIndex == NSNotFound) || (self.needsReloadData)) {
        if (self.infiniteScrollViewDataSource && [self.infiniteScrollViewDataSource respondsToSelector:@selector(infiniteScrollView:pageAtIndex:)]) {
            page = [self.infiniteScrollViewDataSource infiniteScrollView:self pageAtIndex:index];
        }
        
        self.needsReloadData = NO;
    } else {
        page = [self.visiblePages objectAtIndex:visibleIndex];
    }

    return page;
}

- (GBInfiniteScrollViewPage *)nextPage
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    return [self pageAtIndex:[self nextPageIndex]];
}

- (GBInfiniteScrollViewPage *)currentPage
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    return [self pageAtIndex:[self currentPageIndex]];
}

- (GBInfiniteScrollViewPage *)previousPage
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    return [self pageAtIndex:[self previousPageIndex]];
}

#pragma mark - Visible pages

- (NSUInteger)numberOfVisiblePages
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    return self.visibleIndices.count;
}

- (NSUInteger)firstVisiblePageIndex
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    NSNumber *firstVisibleIndex = [self.visibleIndices firstObject];
    return [firstVisibleIndex integerValue];
}

- (NSUInteger)lastVisiblePageIndex
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    NSNumber *lastVisibleIndex = [self.visibleIndices lastObject];
    return [lastVisibleIndex integerValue];
}

- (NSUInteger)nextVisiblePageIndex
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    return [self nextIndex:[self lastVisiblePageIndex]];
}

- (NSUInteger)previousVisiblePageIndex
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    return [self previousIndex:[self firstVisiblePageIndex]];
}

- (GBInfiniteScrollViewPage *)lastVisiblePage
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    return [self pageAtIndex:[self lastVisiblePageIndex]];
}

- (GBInfiniteScrollViewPage *)firstVisiblePage
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    return [self pageAtIndex:[self firstVisiblePageIndex]];
}

- (void)addNextVisiblePage:(GBInfiniteScrollViewPage *)page
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    if (self.debug) {
        NSLog(@"GBInfiniteScrollView: Adding next visible page: %lu", (unsigned long)[self nextVisiblePageIndex]);
    }
    
    [self addLastVisiblePage:page atIndex:[self nextVisiblePageIndex]];
}

- (void)addPreviousVisiblePage:(GBInfiniteScrollViewPage *)page
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    if (self.debug) {
       NSLog(@"GBInfiniteScrollView: Adding previous visible page: %lu", (unsigned long)[self previousVisiblePageIndex]);
    }
    
    [self addFirstVisiblePage:page atIndex:[self previousVisiblePageIndex]];
}

- (void)addLastVisiblePage:(GBInfiniteScrollViewPage *)page atIndex:(NSUInteger)index
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    NSUInteger visibleIndex = [self.visibleIndices indexOfObject:[NSNumber numberWithUnsignedInteger:index]];
    
    if (visibleIndex == NSNotFound && page) {
        [self.visibleIndices addObject:[NSNumber numberWithUnsignedInteger:index]];
        [self.visiblePages addObject:page];
        
        if (self.debug) {
           NSLog(@"GBInfiniteScrollView: Visible indices: %@", [self visibleIndicesDescription]);
        }
    }
}

- (void)addFirstVisiblePage:(GBInfiniteScrollViewPage *)page atIndex:(NSUInteger)index
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    NSUInteger visibleIndex = [self.visibleIndices indexOfObject:[NSNumber numberWithUnsignedInteger:index]];
    
    if (visibleIndex == NSNotFound && page) {
        [self.visibleIndices insertObject:[NSNumber numberWithUnsignedInteger:index] atIndex:0];
        [self.visiblePages insertObject:page atIndex:0.0f];
        
        if (self.debug) {
           NSLog(@"GBInfiniteScrollView: Visible indices: %@", [self visibleIndicesDescription]);
        }
    }
}

- (void)removeFirstVisiblePage
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    if (self.debug) {
       NSLog(@"GBInfiniteScrollView: Removing first visible page.");
    }
    
    GBInfiniteScrollViewPage *firstVisiblePage = [self firstVisiblePage];
    [firstVisiblePage removeFromSuperview];
    [self.reusablePages addObject:firstVisiblePage];
    [self.visibleIndices removeObjectAtIndex:0];
    [self.visiblePages removeObjectAtIndex:0];
    
    if (self.debug) {
       NSLog(@"GBInfiniteScrollView: Visible indices: %@", [self visibleIndicesDescription]);
    }
}

- (void)removeLastVisiblePage
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    if (self.debug) {
       NSLog(@"GBInfiniteScrollView: Removing last visible page.");
    }
    
    GBInfiniteScrollViewPage *lastVisiblePage = [self lastVisiblePage];
    [[self lastVisiblePage] removeFromSuperview];
    [self.reusablePages addObject:lastVisiblePage];
    [self.visibleIndices removeLastObject];
    [self.visiblePages removeLastObject];
    
    if (self.debug) {
       NSLog(@"GBInfiniteScrollView: Visible indices: %@", [self visibleIndicesDescription]);
    }
}

- (NSString *)visibleIndicesDescription
{
    NSString *description = @"";
    
    description = [description stringByAppendingString:[self.visibleIndices componentsJoinedByString:@", "]];
    
    return description;
}

#pragma mark - Reusable pages

- (GBInfiniteScrollViewPage *)dequeueReusablePage
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
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
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    return [self centerContentOffsetX] - [self distanceFromCenterOffsetX];
}

- (CGFloat)minContentOffsetY
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    return [self centerContentOffsetY] - [self distanceFromCenterOffsetY];
}

- (CGFloat)centerContentOffsetX
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    return [self pageWidth];
}

- (CGFloat)centerContentOffsetY
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    return [self pageHeight];
}

- (CGFloat)maxContentOffsetX
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    return [self centerContentOffsetX] + [self distanceFromCenterOffsetX];
}

- (CGFloat)maxContentOffsetY
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    return [self centerContentOffsetY] + [self distanceFromCenterOffsetY];
}

- (CGFloat)distanceFromCenterOffsetX
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    return [self pageWidth];
}

- (CGFloat)distanceFromCenterOffsetY
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    return [self pageHeight];
}

- (CGFloat)contentSizeWidth
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    return [self pageWidth] * 3.0f;
}

- (CGFloat)contentSizeHeight
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    return [self pageHeight] * 3.0f;
}

#pragma mark - Layout

- (void)reloadData
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    [self updateCurrentPageIndex];
    [self updateData];
}

- (void)updateData
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    self.needsReloadData = YES;
    
    [self updateNumberOfPages];
    
    [self.visiblePages enumerateObjectsUsingBlock:^(GBInfiniteScrollViewPage *visiblePage, NSUInteger idx, BOOL *stop) {
        [self.reusablePages addObject:visiblePage];
        [visiblePage removeFromSuperview];
    }];
    
    [self.visibleIndices removeAllObjects];
    [self.visiblePages removeAllObjects];
    
    [self layoutCurrentView];
}

- (void)resetReusablePages
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    [self.reusablePages removeAllObjects];
}

- (void)resetVisiblePages
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    NSUInteger currentPageIndex = [self currentPageIndex];
    GBInfiniteScrollViewPage *currentpage =  [self currentPage];
    
    if (currentpage) {
        if (self.debug) {
           NSLog(@"GBInfiniteScrollView: Reseting visible pages: %@", [self visibleIndicesDescription]);
        }
        
        [self.visibleIndices enumerateObjectsUsingBlock:^(NSNumber *visibleIndex, NSUInteger idx, BOOL *stop) {
            if (self.visiblePages.count>=idx) {
                GBInfiniteScrollViewPage *visiblePage = [self.visiblePages objectAtIndex:idx];
                
                if ([self currentPageIndex] != visibleIndex.integerValue) {
                    [self.reusablePages addObject:visiblePage];
                    [visiblePage removeFromSuperview];
                }
            }
        }];
        
        [self.visibleIndices removeAllObjects];
        [self.visibleIndices addObject:[NSNumber numberWithUnsignedInteger:currentPageIndex]];
        
        [self.visiblePages removeAllObjects];
        [self.visiblePages addObject:currentpage];
        
        if (self.debug) {
           NSLog(@"GBInfiniteScrollView: Visible pages reseted: %@", [self visibleIndicesDescription]);
        }
    }
}

- (void)layoutCurrentView
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    [self resetContentSize];
    [self centerContentOffset];
    
    GBInfiniteScrollViewPage *page = [self currentPage];
    
    if (self.scrollDirection == GBScrollDirectionHorizontal) {
        [self placePage:page atPointX:[self centerContentOffsetX]];
    } else {
        [self placePage:page atPointY:[self centerContentOffsetY]];
    }
    
    [self addFirstVisiblePage:page atIndex:self.currentPageIndex];
}

- (void)resetContentSize
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    if (self.scrollDirection == GBScrollDirectionHorizontal) {
        self.contentSize = CGSizeMake([self contentSizeWidth], self.frame.size.height);
    } else {
        self.contentSize = CGSizeMake(self.frame.size.width, [self contentSizeHeight]);
    }
}

- (void)centerContentOffset
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    if (self.scrollDirection == GBScrollDirectionHorizontal) {
        self.contentOffset = CGPointMake([self centerContentOffsetX], self.contentOffset.y);
    } else {
        self.contentOffset = CGPointMake(self.contentOffset.x, [self centerContentOffsetY]);
    }
}

- (void)recenterCurrentView
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    [self centerContentOffset];
    
    if (self.scrollDirection == GBScrollDirectionHorizontal) {
        [self movePage:[self currentPage] toPositionX:[self centerContentOffsetX]];
    } else {
        [self movePage:[self currentPage] toPositionY:[self centerContentOffsetY]];
    }
}

- (void)movePage:(GBInfiniteScrollViewPage *)page toPositionX:(CGFloat)positionX
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    CGRect frame = page.frame;
    frame.origin.x =  positionX;
    page.frame = frame;
}

- (void)movePage:(GBInfiniteScrollViewPage *)page toPositionY:(CGFloat)positionY
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    CGRect frame = page.frame;
    frame.origin.y =  positionY;
    page.frame = frame;
}

- (void)layoutSubviews
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    [super layoutSubviews];
    
    if ([self isScrollNecessary]) {
        [self recenterContent];
        
        CGRect visibleBounds = [self bounds];
        
        if (self.scrollDirection == GBScrollDirectionHorizontal) {
            CGFloat minimumVisibleX = CGRectGetMinX(visibleBounds);
            CGFloat maximumVisibleX = CGRectGetMaxX(visibleBounds);
            
            // Tile content in visible bounds.
            [self tileViewsFromMinX:minimumVisibleX toMaxX:maximumVisibleX];
        } else {
            CGFloat minimumVisibleY = CGRectGetMinY(visibleBounds);
            CGFloat maximumVisibleY = CGRectGetMaxY(visibleBounds);
            
            // Tile content in visible bounds.
            [self tileViewsFromMinY:minimumVisibleY toMaxY:maximumVisibleY];
        }
    } else {
        [self recenterCurrentView];
        [self updateNumberOfPages];
    }
}

- (void)recenterContent
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    CGPoint currentContentOffset = [self contentOffset];
    if (self.scrollDirection == GBScrollDirectionHorizontal) {
        CGFloat distanceFromCenterOffsetX = fabs(currentContentOffset.x - [self centerContentOffsetX]);
        
        if (distanceFromCenterOffsetX == [self distanceFromCenterOffsetX]) {
            if (currentContentOffset.x == [self minContentOffsetX]) {
                [self previous];
                [self didScrollToPreviousPage];
            } else if (currentContentOffset.x == [self maxContentOffsetX]) {
                [self next];
                [self didScrollToNextPage];
            }
            
            [self updateNumberOfPages];
            [self resetVisiblePages];
            [self recenterCurrentView];
            [self setupTimer];
        }
    } else {
        CGFloat distanceFromCenterOffsetY = fabs(currentContentOffset.y - [self centerContentOffsetY]);
        
        if (distanceFromCenterOffsetY == [self distanceFromCenterOffsetY]) {
            if (currentContentOffset.y == [self minContentOffsetY]) {
                [self previous];
                [self didScrollToPreviousPage];
            } else if (currentContentOffset.y == [self maxContentOffsetY]) {
                [self next];
                [self didScrollToNextPage];
            }
            
            [self updateNumberOfPages];
            [self resetVisiblePages];
            [self recenterCurrentView];
            [self setupTimer];
        }
    }
}

#pragma mark - Pages tiling

- (void)placePage:(GBInfiniteScrollViewPage *)page atPointX:(CGFloat)pointX
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    CGRect frame = [page frame];
    frame.origin.x = pointX;
    page.frame = frame;
    
    [self addSubview:page];
}

- (void)placePage:(GBInfiniteScrollViewPage *)page atPointY:(CGFloat)pointY
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    CGRect frame = [page frame];
    frame.origin.y = pointY;
    page.frame = frame;
    
    [self addSubview:page];
}

- (CGFloat)placePage:(GBInfiniteScrollViewPage *)page onRight:(CGFloat)rightEdge
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    CGRect frame = [page frame];
    frame.origin.x = rightEdge;
    page.frame = frame;
    
    [self addSubview:page];
    [self addNextVisiblePage:page];
    
    return CGRectGetMaxX(frame);
}

- (CGFloat)placePage:(GBInfiniteScrollViewPage *)page onBottom:(CGFloat)bottomEdge
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    CGRect frame = [page frame];
    frame.origin.y = bottomEdge;
    page.frame = frame;
    
    [self addSubview:page];
    [self addNextVisiblePage:page];
    
    return CGRectGetMaxY(frame);
}

- (CGFloat)placePage:(GBInfiniteScrollViewPage *)page onLeft:(CGFloat)leftEdge
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    CGRect frame = [page frame];
    frame.origin.x = leftEdge - [self pageWidth];
    page.frame = frame;
    
    [self addSubview:page];
    [self addPreviousVisiblePage:page];
    
    return CGRectGetMinX(frame);
}

- (CGFloat)placePage:(GBInfiniteScrollViewPage *)page onTop:(CGFloat)topEdge
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    CGRect frame = [page frame];
    frame.origin.y = topEdge - [self pageHeight];
    page.frame = frame;
    
    [self addSubview:page];
    [self addPreviousVisiblePage:page];
    
    return CGRectGetMinY(frame);
}

- (void)tileViewsFromMinX:(CGFloat)minimumVisibleX toMaxX:(CGFloat)maximumVisibleX
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));

    CGFloat rightEdge = CGRectGetMaxX([self lastVisiblePage].frame);
    // Add views that are missing on right side.
    if (rightEdge < maximumVisibleX) {
        if ([self firstVisiblePageIndex] != [self currentPageIndex]) {
            [self removeFirstVisiblePage];
        }

        if (![self isLastPage] || _shouldScrollingWrapDataSource) [self placePage:[self nextPage] onRight:rightEdge];
    }
    
    CGFloat leftEdge = CGRectGetMinX([self firstVisiblePage].frame);
    // Add views that are missing on left side.
    if (leftEdge > minimumVisibleX) {
        if ([self currentPageIndex] != [self lastVisiblePageIndex]) {
            [self removeLastVisiblePage];
        }

        if (![self isFirstPage] || _shouldScrollingWrapDataSource) [self placePage:[self previousPage] onLeft:leftEdge];
    }
}

- (void)tileViewsFromMinY:(CGFloat)minimumVisibleY toMaxY:(CGFloat)maximumVisibleY
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));

    CGFloat bottomEdge = CGRectGetMaxY([self lastVisiblePage].frame);
    // Add views that are missing on bottom side.
    if (bottomEdge < maximumVisibleY) {
        if ([self firstVisiblePageIndex] != [self currentPageIndex]) {
            [self removeFirstVisiblePage];
        }
        if (![self isLastPage] || _shouldScrollingWrapDataSource) [self placePage:[self nextPage] onBottom:bottomEdge];
    }
    
    CGFloat topEdge = CGRectGetMinY([self firstVisiblePage].frame);
    // Add views that are missing on top side.
    if (topEdge > minimumVisibleY) {
        if ([self currentPageIndex] != [self lastVisiblePageIndex]) {
            [self removeLastVisiblePage];
        }
        
        if (![self isFirstPage] || _shouldScrollingWrapDataSource) [self placePage:[self previousPage] onTop:topEdge];
    }
}

#pragma mark - Scroll

- (void)stopAutoScroll
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    self.autoScroll = NO;
    
    if (self.timer) {
        [self.timer invalidate];
    }
}

- (void)startAutoScroll
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    self.autoScroll = YES;
    
    [self setupTimer];
}

- (void)scrollToNextPage
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    if ([self isScrollNecessary]) {
        CGRect frame = [self currentPage].frame;
        CGFloat x = CGFLOAT_MAX;
        CGFloat y = CGFLOAT_MAX;
        
        if (self.scrollDirection == GBScrollDirectionHorizontal) {
            x = CGRectGetMaxX(frame);
            y = frame.origin.y;
        } else {
            x = frame.origin.x;
            y = CGRectGetMaxY(frame);
        }
        
        CGPoint point = CGPointMake(x, y);
        [self setContentOffset:point animated:YES];
    }
}

- (void)scrollToPreviousPage
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    if ([self isScrollNecessary]) {
        CGRect frame = [self currentPage].frame;
        CGFloat x = CGFLOAT_MAX;
        CGFloat y = CGFLOAT_MAX;
        
        if (self.scrollDirection == GBScrollDirectionHorizontal) {
            x = CGRectGetMinX(frame) - [self pageWidth];
            y = frame.origin.y;
        } else {
            x = frame.origin.x;
            y = CGRectGetMinY(frame) - [self pageHeight];
        }
        
        CGPoint point = CGPointMake(x, y);
        [self setContentOffset:point animated:YES];
    }
}

- (void)didScrollToNextPage
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    if (self.infiniteScrollViewDelegate &&
        [self.infiniteScrollViewDelegate respondsToSelector:@selector(infiniteScrollViewDidScrollNextPage:)]) {
        [self.infiniteScrollViewDelegate infiniteScrollViewDidScrollNextPage:self];
    }
}

- (void)didScrollToPreviousPage
{
    if(self.debug && self.verboseDebug)NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    if (self.infiniteScrollViewDelegate &&
        [self.infiniteScrollViewDelegate respondsToSelector:@selector(infiniteScrollViewDidScrollPreviousPage:)]) {
        [self.infiniteScrollViewDelegate infiniteScrollViewDidScrollPreviousPage:self];
    }
}

@end
