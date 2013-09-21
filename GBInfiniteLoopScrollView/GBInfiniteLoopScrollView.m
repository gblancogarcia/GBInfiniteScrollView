#import "GBInfiniteLoopScrollView.h"

@interface GBInfiniteLoopScrollView ()

@property (nonatomic, retain) NSMutableArray *views;
@property (nonatomic, retain) NSMutableArray *pendingViews;
@property (nonatomic, retain) UIView *placeholder;
@property (nonatomic) NSUInteger currentPageIndex;
@property (nonatomic, retain) NSMutableArray *visibleIndices;

@end

@implementation GBInfiniteLoopScrollView

- (id)initWithFrame:(CGRect)frame views:(NSMutableArray *)views
{    
    self = [super initWithFrame:frame];
    if (self) {
        self.views = [views mutableCopy];
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

- (int)numberOfPages
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
    NSLog(@"Current page index: %d", self.currentPageIndex);
}

- (void)previousPage
{
    self.currentPageIndex = [self previousPageIndex];
    NSLog(@"Current page index: %d", self.currentPageIndex);
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

- (int)numberOfVisibleViews
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
    [self.visibleIndices insertObject:[NSNumber numberWithInt:previousVisibleIndex] atIndex:0];
    NSLog(@"Visible indices : %@ ", [self visibleIndicesDescription]);
}

- (void)removeFirstVisibleIndex
{
    [self.visibleIndices removeObjectAtIndex:0];
    NSLog(@"Visible indices : %@ ", [self visibleIndicesDescription]);
}

- (void)removeFirstVisibleView
{
    [[self firstVisibleView] removeFromSuperview];
    [self removeFirstVisibleIndex];
}

- (void)addNexVisibleIndex
{
    NSUInteger nextVisibleIndex = [self nextIndex:[self lastVisibleIndex]];
    [self.visibleIndices addObject:[NSNumber numberWithInt:nextVisibleIndex]];
    NSLog(@"Visible indices : %@ ", [self visibleIndicesDescription]);
}

- (void)removeLastVisibleIndex
{
    [self.visibleIndices removeLastObject];
    NSLog(@"Visible indices : %@ ", [self visibleIndicesDescription]);
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

// Recenter content to achieve impression of infinite scrolling.
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
        NSLog(@"Pending views : %@ ", [self arrayDescription:[self pendingViews]]);
        
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
        
        // Check if there is pending views to add.
        [self addPendingViews];
    }
}

- (void) resetVisibleViews
{
    for (NSNumber *index in self.visibleIndices) {
        if ([self currentPageIndex] != index.integerValue) {
            UIView *view = [self.views objectAtIndex:index.integerValue];
            [view removeFromSuperview];
        }
    }
    
    [self.visibleIndices removeAllObjects];
    [self.visibleIndices addObject:[NSNumber numberWithInt:[self currentPageIndex]]];
    
    NSLog(@"Visible indices : %@ ", [self visibleIndicesDescription]);
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
        NSLog(@"[%2.f, %2.f]", rightEdge, maximumVisibleX);
        
        if ([self firstVisibleIndex] != [self currentPageIndex]) {
            [self removeFirstVisibleView];
        }

        NSLog(@"Adding view %d on right. %.2f", [self nextView].tag, rightEdge);
        [self placeView:[self nextView] onRight:rightEdge];
    }
    
    CGFloat leftEdge = CGRectGetMinX([self firstVisibleView].frame);
        
    // Add views that are missing on left side.

    if (leftEdge > minimumVisibleX) {
        NSLog(@"[%2.f, %2.f]", leftEdge, minimumVisibleX);
        
        if ([self currentPageIndex] != [self lastVisibleIndex]) {
            [self removeLastVisibleView];
        }

        NSLog(@"Adding view %d on left. %.2f", [self previousView].tag, leftEdge);
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
        [self recenterCurrentView];
    } else {
        [self.pendingViews addObject:view];
    }
}

-(NSString *)arrayDescription:(NSArray *)array
{
    NSMutableString *description = [NSMutableString string];

    if (array) {
        [description appendString:@"["];
    
        for (int i = 0 ; i < array.count ; i++) {
            UIView *view = [array objectAtIndex:i];
        
            [description appendString:[NSString stringWithFormat:@"%d", view.tag]];
        
            if (i != array.count - 1) {
                [description appendString:@", "];
            }
        }
    
        [description appendString:@"]"];
    }
    
    return [description copy];
}

-(NSString *)visibleIndicesDescription
{
    NSMutableString *description = [NSMutableString string];
    
    if (self.visibleIndices) {
        [description appendString:@"["];
        
        for (int i = 0 ; i < self.visibleIndices.count ; i++) {
            NSNumber *index = [self.visibleIndices objectAtIndex:i];
            UIView *view = [self.views objectAtIndex:index.integerValue];

            [description appendString:[NSString stringWithFormat:@"%d", view.tag]];
            
            if (i != self.visibleIndices.count - 1) {
                [description appendString:@", "];
            }
        }
        
        [description appendString:@"]"];
    }
    
    return [description copy];
}

@end