//
//  GBInfiniteScrollView.h
//  GBInfiniteScrollView
//
//  Created by Gerardo Blanco García on 01/10/13.
//  Copyright (c) 2013 Gerardo Blanco García. All rights reserved.
//

//  GBInfiniteScrollViewParent is a UIScrollView subclass that relies heavily on MOScrollView.
//
//  MOScrollView
//
//  Created by Jan Christiansen on 6/20/12.
//  Copyright (c) 2012, Monoid - Development and Consulting - Jan Christiansen
//
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  * Redistributions of source code must retain the above copyright
//  notice, this list of conditions and the following disclaimer.
//
//  * Redistributions in binary form must reproduce the above
//  copyright notice, this list of conditions and the following
//  disclaimer in the documentation and/or other materials provided
//  with the distribution.
//
//  * Neither the name of Monoid - Development and Consulting -
//  Jan Christiansen nor the names of other
//  contributors may be used to endorse or promote products derived
//  from this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
//  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
//  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
//  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
//  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
//  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
//  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
//  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
//  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import "GBInfiniteScrollView.h"

/** 
 * Constants used for Newton approximation of cubic function root. 
 */
const static double kApproximationTolerance = 0.00000001;
const static int kMaximumSteps = 10;

@interface GBInfiniteScrollViewParent ()

/**
 * Display link used to trigger event to scroll the view.
 */
@property(nonatomic) CADisplayLink *displayLink;

/**
 * States whether the animation has started.
 */
@property(nonatomic) BOOL animationStarted;

/**
 * Time at the begining of an animation.
 */
@property(nonatomic) CFTimeInterval beginTime;

/**
 * The content offset at the begining of an animation.
 */
@property(nonatomic) CGPoint beginContentOffset;

/**
 * The delta between the contentOffset at the start of the animation and the contentOffset at the end of the animation.
 */
@property(nonatomic) CGPoint deltaContentOffset;

/**
 *  Sets the contentOffset of the ScrollView and animates the transition.
 *
 * @param contentOffset A point (expressed in points) that is offset from the content view’s origin.
 */
- (void)setContentOffsetWithCustomDuration:(CGPoint)contentOffset;

/**
 *  Cancel the ongoing animation.
 */
- (void)cancelAnimation;

@end

@implementation GBInfiniteScrollViewParent

#pragma mark - Initialization

- (id)init
{
    return [self initWithFrame:[UIScreen mainScreen].applicationFrame];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupDefaultValuesParent];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setupDefaultValuesParent];
    }
    
    return self;
}

#pragma mark - SetupDefaultValuesParent

- (void)setupDefaultValuesParent
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    self.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    // Default setContentOffset time animation
    self.animationDuration = 0.25f;
}

#pragma mark - Set ContentOffset with Custom Animation

- (void)setContentOffsetWithCustomDuration:(CGPoint)contentOffset
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    self.deltaContentOffset = CGPointMinus(contentOffset, self.contentOffset);
    
    if (!self.displayLink) {
        self.displayLink = [CADisplayLink
                            displayLinkWithTarget:self
                            selector:@selector(updateContentOffset:)];
        self.displayLink.frameInterval = 1;
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                               forMode:NSDefaultRunLoopMode];
    } else {
        self.displayLink.paused = NO;
    }
}

- (void)updateContentOffset:(CADisplayLink *)displayLink
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (self.beginTime == 0.0) {
        self.beginTime = self.displayLink.timestamp;
        self.beginContentOffset = self.contentOffset;
    } else {
        CFTimeInterval deltaTime = displayLink.timestamp - self.beginTime;
        
        // Ratio of duration that went by
        CGFloat progress = (CGFloat)(deltaTime / self.animationDuration);
        
        if (progress < 1.0) {
            // Ratio adjusted by timing function
            CGFloat adjustedProgress = (CGFloat)timingFunctionValue(self.timingFunction, progress);
            if (1 - adjustedProgress < 0.001) {
                [self stopAnimation];
            } else {
                [self updateProgress:adjustedProgress];
            }
        } else {
            [self stopAnimation];
        }
    }
}

- (void)updateProgress:(CGFloat)progress
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    CGPoint currentDeltaContentOffset = CGPointScalarMult(progress, self.deltaContentOffset);
    self.contentOffset = CGPointAdd(self.beginContentOffset, currentDeltaContentOffset);
}

- (void)stopAnimation
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    self.displayLink.paused = YES;
    self.beginTime = 0.0;
    
    self.contentOffset = CGPointAdd(self.beginContentOffset, self.deltaContentOffset);
    
    if (self.delegate
        && [self.delegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
        // Inform delegate about end of animation
        [self.delegate scrollViewDidEndScrollingAnimation:self];
    }
}

- (void)cancelAnimation
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    self.displayLink.paused = YES;
    self.beginTime = 0.0;
}

#pragma mark - Math

CGPoint CGPointScalarMult(CGFloat s, CGPoint p) {
    return CGPointMake(s * p.x, s * p.y);
}

CGPoint CGPointAdd(CGPoint p, CGPoint q) {
    return CGPointMake(p.x + q.x, p.y + q.y);
}

CGPoint CGPointMinus(CGPoint p, CGPoint q) {
    return CGPointMake(p.x - q.x, p.y - q.y);
}

double cubicFunctionValue(double a, double b, double c, double d, double x) {
    return (a*x*x*x)+(b*x*x)+(c*x)+d;
}

double cubicDerivativeValue(double a, double b, double c, double __unused d, double x) {
    // Derivation of the cubic (a*x*x*x)+(b*x*x)+(c*x)+d
    return (3*a*x*x)+(2*b*x)+c;
}

double rootOfCubic(double a, double b, double c, double d, double startPoint) {
    // We use 0 as start point as the root will be in the interval [0,1]
    double x = startPoint;
    double lastX = 1;
    
    // Approximate a root by using the Newton-Raphson method
    int y = 0;
    while (y <= kMaximumSteps && fabs(lastX - x) > kApproximationTolerance) {
        lastX = x;
        x = x - (cubicFunctionValue(a, b, c, d, x) / cubicDerivativeValue(a, b, c, d, x));
        y++;
    }
    
    return x;
}

double timingFunctionValue(CAMediaTimingFunction *function, double x) {
    float a[2];
    float b[2];
    float c[2];
    float d[2];
    
    [function getControlPointAtIndex:0 values:a];
    [function getControlPointAtIndex:1 values:b];
    [function getControlPointAtIndex:2 values:c];
    [function getControlPointAtIndex:3 values:d];
    
    // Look for t value that corresponds to provided x
    double t = rootOfCubic(-a[0]+3*b[0]-3*c[0]+d[0], 3*a[0]-6*b[0]+3*c[0], -3*a[0]+3*b[0], a[0]-x, x);
    
    // Return corresponding y value
    double y = cubicFunctionValue(-a[1]+3*b[1]-3*c[1]+d[1], 3*a[1]-6*b[1]+3*c[1], -3*a[1]+3*b[1], a[1], t);
    
    return y;
}

@end

static CGFloat const GBAutoScrollDefaultInterval = 3.0f;

@interface GBInfiniteScrollView ()  <UIGestureRecognizerDelegate>

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

/**
 *  A boolean value that determines whether it is allowed to scroll to next page.
 */
@property (nonatomic) BOOL shouldScrollNextPage;

/**
 *  A boolean value that determines whether it is allowed to scroll to previous page.
 */
@property (nonatomic) BOOL shouldScrollPreviousPage;

@property (nonatomic, strong) UIPanGestureRecognizer *infiniteScrollViewPanGestureRecognizer;


@property (nonatomic) BOOL needsUpdatePageIndex;
@property (nonatomic) NSUInteger newPageIndex;
@property (nonatomic) CGSize pageSize;

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
        [self setUp];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setUp];
    }
    
    return self;
}

#pragma mark - Lazy instantiation

- (NSMutableArray *)visibleIndices
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (!_visibleIndices) {
        _visibleIndices = [[NSMutableArray alloc] init];
    }
    
    return _visibleIndices;
}

- (NSMutableArray *)visiblePages
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (!_visiblePages) {
        _visiblePages = [[NSMutableArray alloc] init];
    }
    
    return _visiblePages;
}

- (NSMutableArray *)reusablePages
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (!_reusablePages) {
        _reusablePages = [[NSMutableArray alloc] init];
    }
    
    return _reusablePages;
}

#pragma mark - SetUp

- (void)setUp
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    self.backgroundColor = [UIColor clearColor];
    self.bounces = NO;
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.userInteractionEnabled = YES;
    self.useInfiniteScrollPanGestureRecognizer = YES;
    
    [self setupTapGesture];
    
    [self setUpDefautValues];
}

- (void)setupTapGesture
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if ([self isTapEnabled]) {
        self.exclusiveTouch = YES;
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(tapOnScrollView)];
        
        [self addGestureRecognizer:gesture];
    } else {
        self.exclusiveTouch = NO;
    }
}

- (void)setupPanGesture
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (self.useInfiniteScrollPanGestureRecognizer) {
        self.infiniteScrollViewPanGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self
                                                                                             action:@selector(panOnScrollView:)];
        self.infiniteScrollViewPanGestureRecognizer.delegate = self;
        [self addGestureRecognizer:self.infiniteScrollViewPanGestureRecognizer];
    }
}

- (void)setUpDefautValues
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    self.autoScroll = NO;
    self.shouldScrollingWrapDataSource = YES;
    self.pageIndex = [self firstPageIndex];
    self.currentPageIndex = [self firstPageIndex];
    self.scrollDirection = GBScrollDirectionHorizontal;
    self.autoScrollDirection = GBAutoScrollDirectionRightToLeft;
    self.interval = GBAutoScrollDefaultInterval;
    self.shouldScrollNextPage = YES;
    self.shouldScrollPreviousPage = YES;
}

- (void)setUpTimer
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (self.timer) {
        [self.timer invalidate];
    }
    
    if (self.autoScroll) {
        if (self.autoScrollDirection == GBAutoScrollDirectionLeftToRight ||
            self.autoScrollDirection == GBAutoScrollDirectionTopToBottom) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:self.interval
                                                          target:self
                                                        selector:@selector(scrollToPreviousPage)
                                                        userInfo:nil
                                                         repeats:YES];
        } else if (self.autoScrollDirection == GBAutoScrollDirectionRightToLeft ||
                   self.autoScrollDirection == GBAutoScrollDirectionBottomToTop){
            self.timer = [NSTimer scheduledTimerWithTimeInterval:self.interval
                                                          target:self
                                                        selector:@selector(scrollToNextPage)
                                                        userInfo:nil
                                                         repeats:YES];
        }
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

#pragma mark - Propertys

// Setter Method
- (void)setTapEnabled:(BOOL)tapEnabled {
    _tapEnabled = tapEnabled;
    [self setupTapGesture];
}

- (void)setUseInfiniteScrollPanGestureRecognizer:(BOOL)useInfiniteScrollPanGestureRecognizer
{
    _useInfiniteScrollPanGestureRecognizer = useInfiniteScrollPanGestureRecognizer;
    
    if (self.useInfiniteScrollPanGestureRecognizer) {
        if (self.infiniteScrollViewPanGestureRecognizer == nil) {
           [self setupPanGesture];
        }
    } else {
        [self removeGestureRecognizer:self.infiniteScrollViewPanGestureRecognizer];
        self.infiniteScrollViewPanGestureRecognizer = nil;
    }
}

#pragma mark - Tap

- (void)tapOnScrollView
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (self.infiniteScrollViewDelegate &&
        [self.infiniteScrollViewDelegate respondsToSelector:@selector(infiniteScrollView:didTapAtIndex:)]) {
        [self.infiniteScrollViewDelegate infiniteScrollView:self didTapAtIndex:self.currentPageIndex];
    }
}

#pragma mark - Pan

-(void)panOnScrollView:(UIPanGestureRecognizer*)pan
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        [self cancelAnimation];
        [self stopAutoScroll];
    }else if (pan.state == UIGestureRecognizerStateEnded){
        [self startAutoScroll];
    }
    
    if (self.infiniteScrollViewDelegate &&
        [self.infiniteScrollViewDelegate respondsToSelector:@selector(infiniteScrollViewDidPan:)]) {
        [self.infiniteScrollViewDelegate infiniteScrollViewDidPan:pan];
    }
}

#pragma mark - Convenient methods

- (BOOL)isEmpty
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    return ([self numberOfPages] == 0);
}

- (BOOL)isNotEmpty
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    return (self.isEmpty ? NO : YES);
}

- (BOOL)singlePage
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    return ([self numberOfPages] == 1);
}

- (BOOL)isScrollNecessary
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    return (self.isScrollNotNecessary ? NO : YES);
}

- (BOOL)isScrollNotNecessary
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    return ([self isEmpty] || [self singlePage]);
}

- (BOOL)isLastPage
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    return (self.currentPageIndex == [self lastPageIndex] ? YES : NO);
}

- (BOOL)isFirstPage
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    return (self.currentPageIndex == [self firstPageIndex] ? YES : NO);
}

- (NSUInteger)numberOfPagesOnTheRightBetweenFirstIndex:(NSUInteger)firstIndex andSecondIndex:(NSUInteger)secondIndex
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    NSUInteger numberOfPages = 0;

    if (firstIndex < secondIndex) {
        numberOfPages = secondIndex - firstIndex - 1;
    } else if (firstIndex > secondIndex) {
        numberOfPages = ([self lastPageIndex] - firstIndex) + (secondIndex - [self firstPageIndex]);
    }
    
    return numberOfPages;
}

- (NSUInteger)numberOfPagesOnTheLeftBetweenFirstIndex:(NSUInteger)firstIndex andSecondIndex:(NSUInteger)secondIndex
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    NSUInteger numberOfPages = 0;
    
    if (firstIndex < secondIndex) {
        numberOfPages = ([self lastPageIndex] - secondIndex) + (firstIndex - [self firstPageIndex]);
    } else if (firstIndex > secondIndex) {
        numberOfPages = firstIndex - secondIndex - 1;
    }
    
    return numberOfPages;
}

#pragma mark - Pages

- (void)updateNumberOfPages
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (self.infiniteScrollViewDataSource &&
        [self.infiniteScrollViewDataSource respondsToSelector:@selector(numberOfPagesInInfiniteScrollView:)]) {
        self.numberOfPages = [self.infiniteScrollViewDataSource numberOfPagesInInfiniteScrollView:self];
    }
}

- (void)updatePageIndex
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (self.needsUpdatePageIndex) {
        self.currentPageIndex = self.newPageIndex;
        self.needsUpdatePageIndex = NO;
    
        [self resetVisiblePages];
        [self resetLayout];
    }
}

- (CGFloat)pageWidth
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    return self.frame.size.width;
}

- (CGFloat)pageHeight
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    return self.frame.size.height;
}

- (NSUInteger)firstPageIndex
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    return 0;
}

- (NSUInteger)lastPageIndex
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if ([self numberOfPages] == 0)
        return 0;
    
    return fmax([self firstPageIndex], [self numberOfPages] - 1);
}

- (NSUInteger)nextIndex:(NSUInteger)index
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    return (index == [self lastPageIndex]) ? [self firstPageIndex] : (index + 1);
}

- (NSUInteger)previousIndex:(NSUInteger)index
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    return (index == [self firstPageIndex]) ? [self lastPageIndex] : (index - 1);
}

- (void)updateCurrentPageIndex
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    self.currentPageIndex = (self.pageIndex > [self lastPageIndex]) ? [self lastPageIndex] : fmaxf(self.pageIndex, 0.0f);
}

- (NSUInteger)nextPageIndex
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (!self.shouldScrollingWrapDataSource && [self isLastPage]) {
        return self.currentPageIndex;
    }
    
    return [self nextIndex:self.currentPageIndex];
}

- (NSUInteger)previousPageIndex
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (!self.shouldScrollingWrapDataSource && [self isFirstPage]) {
        return self.currentPageIndex;
    }
    
    return [self previousIndex:self.currentPageIndex];
}

- (void)next
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (self.isDebugModeOn) {
        NSLog(@"GBInfiniteScrollView: Next: %lu", (unsigned long)[self nextPageIndex]);
    }

    self.currentPageIndex = [self nextPageIndex];
}

- (void)previous
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (self.isDebugModeOn) {
        NSLog(@"GBInfiniteScrollView: Previous: %lu", (unsigned long)[self previousPageIndex]);
    }
    
    self.currentPageIndex = [self previousPageIndex];
}

- (GBInfiniteScrollViewPage *)pageAtIndex:(NSUInteger)index
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    GBInfiniteScrollViewPage *page = nil;
    
    NSUInteger visibleIndex = [self.visibleIndices indexOfObject:[NSNumber numberWithUnsignedInteger:index]];
    
    if ((visibleIndex == NSNotFound) || (self.needsReloadData)) {
        if (self.infiniteScrollViewDataSource &&
            [self.infiniteScrollViewDataSource respondsToSelector:@selector(infiniteScrollView:pageAtIndex:)]) {
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
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    return [self pageAtIndex:[self nextPageIndex]];
}

- (GBInfiniteScrollViewPage *)currentPage
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    return [self pageAtIndex:[self currentPageIndex]];
}

- (GBInfiniteScrollViewPage *)previousPage
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    return [self pageAtIndex:[self previousPageIndex]];
}

#pragma mark - Visible pages

- (NSUInteger)numberOfVisiblePages
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    return self.visibleIndices.count;
}

- (NSUInteger)firstVisiblePageIndex
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    NSNumber *firstVisibleIndex = [self.visibleIndices firstObject];
    return [firstVisibleIndex integerValue];
}

- (NSUInteger)lastVisiblePageIndex
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    NSNumber *lastVisibleIndex = [self.visibleIndices lastObject];
    return [lastVisibleIndex integerValue];
}

- (NSUInteger)nextVisiblePageIndex
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    return [self nextIndex:[self lastVisiblePageIndex]];
}

- (NSUInteger)previousVisiblePageIndex
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    return [self previousIndex:[self firstVisiblePageIndex]];
}

- (GBInfiniteScrollViewPage *)lastVisiblePage
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    return [self pageAtIndex:[self lastVisiblePageIndex]];
}

- (GBInfiniteScrollViewPage *)firstVisiblePage
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    return [self pageAtIndex:[self firstVisiblePageIndex]];
}

- (void)addNextVisiblePage:(GBInfiniteScrollViewPage *)page
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (self.isDebugModeOn) {
        NSLog(@"GBInfiniteScrollView: Adding next visible page: %lu", (unsigned long)[self nextVisiblePageIndex]);
    }
    
    [self addLastVisiblePage:page atIndex:[self nextVisiblePageIndex]];
}

- (void)addPreviousVisiblePage:(GBInfiniteScrollViewPage *)page
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (self.isDebugModeOn) {
       NSLog(@"GBInfiniteScrollView: Adding previous visible page: %lu", (unsigned long)[self previousVisiblePageIndex]);
    }
    
    [self addFirstVisiblePage:page atIndex:[self previousVisiblePageIndex]];
}

- (void)addLastVisiblePage:(GBInfiniteScrollViewPage *)page atIndex:(NSUInteger)index
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    NSUInteger visibleIndex = [self.visibleIndices indexOfObject:[NSNumber numberWithUnsignedInteger:index]];
    
    if (visibleIndex == NSNotFound && page) {
        [self.visibleIndices addObject:[NSNumber numberWithUnsignedInteger:index]];
        [self.visiblePages addObject:page];
        
        if (self.isDebugModeOn) {
           NSLog(@"GBInfiniteScrollView: Visible indices: %@", [self visibleIndicesDescription]);
        }
    }
}

- (void)addFirstVisiblePage:(GBInfiniteScrollViewPage *)page atIndex:(NSUInteger)index
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    NSUInteger visibleIndex = [self.visibleIndices indexOfObject:[NSNumber numberWithUnsignedInteger:index]];
    
    if (visibleIndex == NSNotFound && page) {
        [self.visibleIndices insertObject:[NSNumber numberWithUnsignedInteger:index] atIndex:0];
        [self.visiblePages insertObject:page atIndex:0.0f];
        
        if (self.isDebugModeOn) {
           NSLog(@"GBInfiniteScrollView: Visible indices: %@", [self visibleIndicesDescription]);
        }
    }
}

- (void)removeFirstVisiblePage
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (self.isDebugModeOn) {
       NSLog(@"GBInfiniteScrollView: Removing first visible page.");
    }
    
    GBInfiniteScrollViewPage *firstVisiblePage = [self firstVisiblePage];
    [firstVisiblePage removeFromSuperview];
    [self.reusablePages addObject:firstVisiblePage];
    [self.visibleIndices removeObjectAtIndex:0];
    [self.visiblePages removeObjectAtIndex:0];
    
    if (self.isDebugModeOn) {
       NSLog(@"GBInfiniteScrollView: Visible indices: %@", [self visibleIndicesDescription]);
    }
}

- (void)removeLastVisiblePage
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (self.isDebugModeOn) {
       NSLog(@"GBInfiniteScrollView: Removing last visible page.");
    }
    
    GBInfiniteScrollViewPage *lastVisiblePage = [self lastVisiblePage];
    [[self lastVisiblePage] removeFromSuperview];
    [self.reusablePages addObject:lastVisiblePage];
    [self.visibleIndices removeLastObject];
    [self.visiblePages removeLastObject];
    
    if (self.isDebugModeOn) {
       NSLog(@"GBInfiniteScrollView: Visible indices: %@", [self visibleIndicesDescription]);
    }
}

- (NSString *)visibleIndicesDescription
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    NSString *description = @"";
    
    description = [description stringByAppendingString:[self.visibleIndices componentsJoinedByString:@", "]];
    
    return description;
}

#pragma mark - Reusable pages

- (GBInfiniteScrollViewPage *)dequeueReusablePage
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
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
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (self.shouldScrollPreviousPage == NO) {
        return [self centerContentOffsetX];
    }
    
    return [self centerContentOffsetX] - [self distanceFromCenterOffsetX];
}

- (CGFloat)minContentOffsetY
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (self.shouldScrollPreviousPage == NO) {
        return [self centerContentOffsetX];
    }
    
    return [self centerContentOffsetY] - [self distanceFromCenterOffsetY];
}

- (CGFloat)centerContentOffsetX
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (self.shouldScrollPreviousPage == NO) {
        return 0.0f;
    }
    
    return [self pageWidth];
}

- (CGFloat)centerContentOffsetY
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (self.shouldScrollPreviousPage == NO) {
        return 0.0f;
    }
    
    return [self pageHeight];
}

- (CGFloat)maxContentOffsetX
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (self.shouldScrollNextPage == NO) {
        return [self centerContentOffsetX];
    }
    
    return [self centerContentOffsetX] + [self distanceFromCenterOffsetX];
}

- (CGFloat)maxContentOffsetY
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (self.shouldScrollNextPage == NO) {
        return [self centerContentOffsetX];
    }
    
    return [self centerContentOffsetY] + [self distanceFromCenterOffsetY];
}

- (CGFloat)distanceFromCenterOffsetX
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    return [self pageWidth];
}

- (CGFloat)distanceFromCenterOffsetY
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    return [self pageHeight];
}

- (CGFloat)contentSizeWidth
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    int multiplier = 3;
    
    if ((self.shouldScrollNextPage == NO) && (self.shouldScrollPreviousPage == NO)) {
        multiplier = 1;
    } else if ((self.shouldScrollNextPage == NO) || (self.shouldScrollPreviousPage == NO)) {
        multiplier = 2;
    }
    
    return [self pageWidth] * multiplier;
}

- (CGFloat)contentSizeHeight
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    int multiplier = 3;
    
    if ((self.shouldScrollNextPage == NO) && (self.shouldScrollPreviousPage == NO)) {
        multiplier = 1;
    } else if ((self.shouldScrollNextPage == NO) || (self.shouldScrollPreviousPage == NO)) {
        multiplier = 2;
    }
    
    return [self pageHeight] * multiplier;
}

#pragma mark - Layout

- (void)reloadData
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    [self updateNumberOfPages];
    [self updateCurrentPageIndex];
    [self updateData];
}

- (void)updateData
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    self.needsReloadData = YES;
    
    [self.visiblePages enumerateObjectsUsingBlock:^(GBInfiniteScrollViewPage *visiblePage, NSUInteger idx, BOOL *stop) {
        [self.reusablePages addObject:visiblePage];
        [visiblePage removeFromSuperview];
    }];
    
    [self.visibleIndices removeAllObjects];
    [self.visiblePages removeAllObjects];
    
    [self shouldScroll];
    [self resetLayout];
}

- (void)resetLayout
{
    [self layoutCurrentView];
}

- (void)resetReusablePages
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    [self.reusablePages removeAllObjects];
}

- (void)resetVisiblePages
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    NSUInteger currentPageIndex = [self currentPageIndex];
    GBInfiniteScrollViewPage *currentpage =  [self currentPage];
    
    if (currentpage) {
        if (self.isDebugModeOn) {
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
        
        if (self.isDebugModeOn) {
           NSLog(@"GBInfiniteScrollView: Visible pages reseted: %@", [self visibleIndicesDescription]);
        }
    }
}

- (void)layoutCurrentView
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
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
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (self.scrollDirection == GBScrollDirectionHorizontal) {
        self.contentSize = CGSizeMake([self contentSizeWidth], self.frame.size.height);
    } else {
        self.contentSize = CGSizeMake(self.frame.size.width, [self contentSizeHeight]);
    }
}

- (void)centerContentOffset
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (self.scrollDirection == GBScrollDirectionHorizontal) {
        self.contentOffset = CGPointMake([self centerContentOffsetX], self.contentOffset.y);
    } else {
        self.contentOffset = CGPointMake(self.contentOffset.x, [self centerContentOffsetY]);
    }
}

- (void)recenterCurrentView
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    [self centerContentOffset];
    
    if (self.scrollDirection == GBScrollDirectionHorizontal) {
        [self movePage:[self currentPage] toPositionX:[self centerContentOffsetX]];
    } else {
        [self movePage:[self currentPage] toPositionY:[self centerContentOffsetY]];
    }
}

- (void)movePage:(GBInfiniteScrollViewPage *)page toPositionX:(CGFloat)positionX
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    CGRect frame = page.frame;
    frame.origin.x =  positionX;
    page.frame = frame;
}

- (void)movePage:(GBInfiniteScrollViewPage *)page toPositionY:(CGFloat)positionY
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    CGRect frame = page.frame;
    frame.origin.y =  positionY;
    page.frame = frame;
}

- (void)layoutSubviews
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }

    [super layoutSubviews];
    
    if ((self.scrollDirection == GBScrollDirectionHorizontal && self.pageSize.width  != self.frame.size.width) ||
        (self.scrollDirection == GBScrollDirectionVertical   && self.pageSize.height != self.frame.size.height)) {
        self.pageSize = self.frame.size;
        [self layoutCurrentView];
    }
    
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
    
    [self layoutIfNeeded];
}

- (void)recenterContent
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
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
            [self updatePageIndex];
            [self resetVisiblePages];
            [self recenterCurrentView];
            [self setUpTimer];
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
            [self updatePageIndex];
            [self resetVisiblePages];
            [self recenterCurrentView];
            [self setUpTimer];
        }
    }
}

#pragma mark - Pages tiling

- (void)placePage:(GBInfiniteScrollViewPage *)page atPointX:(CGFloat)pointX
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    CGRect frame = [page frame];
    frame.origin.x = pointX;
    frame.size = self.frame.size;
    page.frame = frame;
    
    [self addSubview:page];
}

- (void)placePage:(GBInfiniteScrollViewPage *)page atPointY:(CGFloat)pointY
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    CGRect frame = [page frame];
    frame.origin.y = pointY;
    frame.size = self.frame.size;
    page.frame = frame;
    
    [self addSubview:page];
}

- (CGFloat)placePage:(GBInfiniteScrollViewPage *)page onRight:(CGFloat)rightEdge
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    CGRect frame = [page frame];
    frame.origin.x = rightEdge;
    frame.size = self.frame.size;
    page.frame = frame;
    
    [self addSubview:page];
    [self addNextVisiblePage:page];
    
    return CGRectGetMaxX(frame);
}

- (CGFloat)placePage:(GBInfiniteScrollViewPage *)page onBottom:(CGFloat)bottomEdge
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    CGRect frame = [page frame];
    frame.origin.y = bottomEdge;
    frame.size = self.frame.size;
    page.frame = frame;
    
    [self addSubview:page];
    [self addNextVisiblePage:page];
    
    return CGRectGetMaxY(frame);
}

- (CGFloat)placePage:(GBInfiniteScrollViewPage *)page onLeft:(CGFloat)leftEdge
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    CGRect frame = [page frame];
    frame.origin.x = leftEdge - [self pageWidth];
    frame.size = self.frame.size;
    page.frame = frame;
    
    [self addSubview:page];
    [self addPreviousVisiblePage:page];
    
    return CGRectGetMinX(frame);
}

- (CGFloat)placePage:(GBInfiniteScrollViewPage *)page onTop:(CGFloat)topEdge
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    CGRect frame = [page frame];
    frame.origin.y = topEdge - [self pageHeight];
    frame.size = self.frame.size;
    page.frame = frame;
    
    [self addSubview:page];
    [self addPreviousVisiblePage:page];
    
    return CGRectGetMinY(frame);
}

- (void)tileViewsFromMinX:(CGFloat)minimumVisibleX toMaxX:(CGFloat)maximumVisibleX
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    CGFloat rightEdge = CGRectGetMaxX([self lastVisiblePage].frame);
    
    // Add views that are missing on right side.
    if (rightEdge < maximumVisibleX) {
        if ([self firstVisiblePageIndex] != [self currentPageIndex]) {
            [self removeFirstVisiblePage];
        }

        if (![self isLastPage] || self.shouldScrollingWrapDataSource) {
            [self placePage:[self nextPage] onRight:rightEdge];
        }
    }
    
    CGFloat leftEdge = CGRectGetMinX([self firstVisiblePage].frame);
    
    // Add views that are missing on left side.
    if (leftEdge > minimumVisibleX) {
        if ([self currentPageIndex] != [self lastVisiblePageIndex]) {
            [self removeLastVisiblePage];
        }

        if (![self isFirstPage] || self.shouldScrollingWrapDataSource) {
            [self placePage:[self previousPage] onLeft:leftEdge];
        }
    }
}

- (void)tileViewsFromMinY:(CGFloat)minimumVisibleY toMaxY:(CGFloat)maximumVisibleY
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    CGFloat bottomEdge = CGRectGetMaxY([self lastVisiblePage].frame);
    // Add views that are missing on bottom side.
    
    if (bottomEdge < maximumVisibleY) {
        if ([self firstVisiblePageIndex] != [self currentPageIndex]) {
            [self removeFirstVisiblePage];
        }
        
        if (![self isLastPage] || self.shouldScrollingWrapDataSource) {
            [self placePage:[self nextPage] onBottom:bottomEdge];
        }
    }
    
    CGFloat topEdge = CGRectGetMinY([self firstVisiblePage].frame);
    
    // Add views that are missing on top side.
    if (topEdge > minimumVisibleY) {
        if ([self currentPageIndex] != [self lastVisiblePageIndex]) {
            [self removeLastVisiblePage];
        }
        
        if (![self isFirstPage] || self.shouldScrollingWrapDataSource) {
            [self placePage:[self previousPage] onTop:topEdge];
        }
    }
}

#pragma mark - Scroll

- (void)stopAutoScroll
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    self.autoScroll = NO;
    
    if (self.timer) {
        [self.timer invalidate];
    }
}

- (void)startAutoScroll
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    self.autoScroll = YES;
    
    [self shouldScroll];
    // ???: is necessary? [self resetLayout];
    [self setUpTimer];
}

- (void)scrollToNextPage
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if ([self isScrollNecessary] && self.shouldScrollNextPage) {
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
        
        // Notify delegate we're going to the next page
        if ([self.infiniteScrollViewDelegate respondsToSelector:@selector(infiniteScrollViewWillScrollNextPage:)]) {
            [self.infiniteScrollViewDelegate infiniteScrollViewWillScrollNextPage:self];
        }
        
        CGPoint point = CGPointMake(x, y);
        [self setContentOffsetWithCustomDuration:point];
    }
}

- (void)scrollToPreviousPage
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if ([self isScrollNecessary] && self.shouldScrollPreviousPage) {
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
        
        
        // Notify delegate we're going to the next page
        if ([self.infiniteScrollViewDelegate respondsToSelector:@selector(infiniteScrollViewWillScrollPreviousPage:)]) {
            [self.infiniteScrollViewDelegate infiniteScrollViewWillScrollPreviousPage:self];
        }
        
        CGPoint point = CGPointMake(x, y);
        [self setContentOffsetWithCustomDuration:point];
    }
}

- (void)didScrollToNextPage
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (self.infiniteScrollViewDelegate) {
        if ([self.infiniteScrollViewDelegate respondsToSelector:@selector(infiniteScrollViewDidScrollNextPage:)]) {
            [self.infiniteScrollViewDelegate infiniteScrollViewDidScrollNextPage:self];
        }
    }
    
    [self shouldScroll];
}

- (void)didScrollToPreviousPage
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (self.infiniteScrollViewDelegate) {
        if ([self.infiniteScrollViewDelegate respondsToSelector:@selector(infiniteScrollViewDidScrollPreviousPage:)]) {
            [self.infiniteScrollViewDelegate infiniteScrollViewDidScrollPreviousPage:self];
        }
    }
    
    [self shouldScroll];
}

- (void)shouldScroll
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (self.infiniteScrollViewDelegate) {
        if ([self.infiniteScrollViewDelegate respondsToSelector:@selector(infiniteScrollViewShouldScrollNextPage:)]) {
            self.shouldScrollNextPage = [self.infiniteScrollViewDelegate infiniteScrollViewShouldScrollNextPage:self];
        } else {
            self.shouldScrollNextPage = YES;
        }
        
        if ([self.infiniteScrollViewDelegate respondsToSelector:@selector(infiniteScrollViewShouldScrollPreviousPage:)]) {
            self.shouldScrollPreviousPage = [self.infiniteScrollViewDelegate infiniteScrollViewShouldScrollPreviousPage:self];
        } else {
            self.shouldScrollPreviousPage = YES;
        }
        
        [self resetContentSize];
    } else {
        self.shouldScrollNextPage = YES;
        self.shouldScrollPreviousPage = YES;
    }
}

- (void)scrollToPageAtIndex:(NSUInteger)index animated:(BOOL)animated
{
    if (self.isDebugModeOn && self.isVerboseDebugModeOn) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (index <= self.numberOfPages && self.needsUpdatePageIndex == NO) {
        if (animated) {
            [self shouldScroll];
            [self resetLayout];
            
            long numberOfPagesOnTheRight = [self numberOfPagesOnTheRightBetweenFirstIndex:self.currentPageIndex
                                                                           andSecondIndex:index];
            
            long numberOfPagesOnTheLeft = [self numberOfPagesOnTheLeftBetweenFirstIndex:self.currentPageIndex
                                                                         andSecondIndex:index];
            
            if (numberOfPagesOnTheRight <= numberOfPagesOnTheLeft) {
                CGFloat rightEdge = CGRectGetMaxX([self currentPage].frame);
                
                if (![self isLastPage] || self.shouldScrollingWrapDataSource) {
                    [self placePage:[self pageAtIndex:index] onRight:rightEdge];
                    [self scrollToNextPage];
                }
            } else {
                CGFloat leftEdge = CGRectGetMinX([self currentPage].frame);
                
                if (![self isFirstPage] || self.shouldScrollingWrapDataSource) {
                    [self placePage:[self pageAtIndex:index] onLeft:leftEdge];
                    [self scrollToPreviousPage];
                }
            }
            
            self.needsUpdatePageIndex = YES;
            self.newPageIndex = index;
        } else {
            self.currentPageIndex = index;
            [self resetLayout];
            [self resetVisiblePages];
        }
    }
}

#pragma mark - UIGestureRecognizer Delegate

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    //If the usage of the UIPanGestureRecognizer is enabled, we need to enable simultaneously gesture recognizing. If not, it's not needed.
    return self.useInfiniteScrollPanGestureRecognizer;
}


@end
