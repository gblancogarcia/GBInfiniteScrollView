//
//  GBInfiniteScrollView.h
//  GBInfiniteScrollView
//
//  Created by Gerardo Blanco García on 01/10/13.
//  Copyright (c) 2013 Gerardo Blanco García. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense,  and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
//  CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
//  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
//  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <UIKit/UIKit.h>

#import "GBInfiniteScrollViewPage.h"

typedef NS_ENUM(NSInteger, GBAutoScrollDirection) {
    GBAutoScrollDirectionRightToLeft,  // Automatic scrolling from right to left. (default)
    GBAutoScrollDirectionLeftToRight,  // Automatic scrolling from left to right.
};

@protocol GBInfiniteScrollViewDelegate;
@protocol GBInfiniteScrollViewDataSource;

// GBInfiniteScrollView class provides an endlessly scroll view organized in pages. It is a subclass of UIScrollView,
// which allows users to scroll infinitely in the horizontal direction. GBInfiniteScrollView also provides automatic
// scrolling feature.
//
// A GBInfiniteScrollView object must have an object that acts as a data source and an object that acts as a delegate.
// The data source must adopt the GBInfiniteScrollViewDataSource protocol and the delegate must adopt the
// GBInfiniteScrollViewDelegate protocol. The data source provides the views that GBInfiniteScrollView needs to display.
// The delegate allows the adopting delegate to respond to scrolling operations.
//
// GBInfiniteScrollView overrides the layoutSubviews method of UIView so that it calls reloadData only when you create a
// new instance of GBInfiniteScrollView or when you assign a new data source. Reloading the infinite scroll view clears
// current state, including the current view, but it is possible to specify the initial page index to display.
//
// It is based on Apple StreetScroller iOS sample code.

@interface GBInfiniteScrollView : UIScrollView <UIScrollViewDelegate>

// Infinite scroll view data source.
@property (nonatomic, assign) id <GBInfiniteScrollViewDataSource> infiniteScrollViewDataSource;

// Infinite scroll view delegate.
@property (nonatomic, assign) id <GBInfiniteScrollViewDelegate> infiniteScrollViewDelegate;

// Returns an initialized infinite scroll view.
- (id)init;

// Returns an initialized infinite scroll view from a given frame.
- (id)initWithFrame:(CGRect)frame;

// Returns an initialized infinite scroll view from data in a given unarchiver.
- (id)initWithCoder:(NSCoder *)aDecoder;

// Automatic scrolling time interval.
@property (nonatomic) CGFloat interval;

// Automatic scrolling direction (right to left or left to right).
@property (nonatomic) GBAutoScrollDirection direction;

// Initial page index.
@property (nonatomic) NSUInteger pageIndex;

// The current page index.
@property (nonatomic, readonly) NSUInteger currentPageIndex;

// Gets the current view.
- (GBInfiniteScrollViewPage *)currentPage;

// Reloads everything from scratch.
- (void)reloadData;

// Stops automatic scrolling.
- (void)stopAutoScroll;

// Starts automatic scrolling.
- (void)startAutoScroll;

// Returns a reusable infinite scroll view page object.
- (GBInfiniteScrollViewPage *)dequeueReusablePage;

@end

//  This protocol represents the data model object.
@protocol GBInfiniteScrollViewDataSource<NSObject>

@required

// Tells the data source to return the number of pages. (required)
- (NSInteger)numberOfPagesInInfiniteScrollView:(GBInfiniteScrollView *)infiniteScrollView;

// Asks the data source for a view to display in a particular page index. (required)
- (GBInfiniteScrollViewPage *)infiniteScrollView:(GBInfiniteScrollView *)infiniteScrollView pageAtIndex:(NSUInteger)index;

@end

//  This protocol allows the adopting delegate to respond to scrolling operations.
@protocol GBInfiniteScrollViewDelegate<NSObject>

@optional

// Called when the GBInfiniteScrollView has scrolled to next page.
- (void)infiniteScrollViewDidScrollNextPage:(GBInfiniteScrollView *)infiniteScrollView;

// Called when the GBInfiniteScrollView has scrolled to previous page.
- (void)infiniteScrollViewDidScrollPreviousPage:(GBInfiniteScrollView *)infiniteScrollView;

@end