//
//  GBInfiniteScrollView.h
//  GBInfiniteScrollView
//
//  Created by Gerardo Blanco García on 01/10/13.
//  Copyright (c) 2013 Gerardo Blanco García. All rights reserved.
//

// This code is distributed under the terms and conditions of the MIT license.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
// documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
// Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
// WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GBAutoScrollDirection) {
    GBAutoScrollDirectionRightToLeft,  // Automatic scroll from right to left. This is the default.
    GBAutoScrollDirectionLeftToRight,  // Automatic scroll from left to right.
};

@protocol GBInfiniteScrollViewDelegate;

// The GBInfiniteScrollView class provides an endlessly scroll view organized in pages. It is an UIScrollView
// subclass that can scroll infinitely in the horizontal direction. GBInfiniteScrollView also provides auto scroll
// functionality. It allows you to add views dynamically. It is based on Apple StreetScroller iOS sample code.
@interface GBInfiniteScrollView : UIScrollView <UIScrollViewDelegate>

// Infinite scroll view delegate.
@property (nonatomic, assign) id <GBInfiniteScrollViewDelegate> infiniteScrollViewDelegate;

// A convenience initializer that initializes the GBInfiniteScrollView with the placeholder UIView.
- (id)initWithFrame:(CGRect)frame placeholder:(UIView *)placeholder;

// A convenience initializer that initializes the GBInfiniteScrollView with the array of UIViews.
- (id)initWithFrame:(CGRect)frame views:(NSMutableArray *)views;

// A convenience initializer that initializes the GBInfiniteScrollView with the array of UIViews and the automatic
// scroll flag.
- (id)initWithFrame:(CGRect)frame views:(NSMutableArray *)views autoScroll:(BOOL)autoScroll;

// A convenience initializer that initializes the GBInfiniteScrollView with the array of UIViews, the automatic
// scroll flag and the automatic time interval.
- (id)initWithFrame:(CGRect)frame views:(NSMutableArray *)views autoScroll:(BOOL)autoScroll interval:(CGFloat)interval;

// A convenience initializer that initializes the GBInfiniteScrollView with the array of UIViews, the automatic
// scroll flag, the automatic time interval and the automatic scroll direction.
- (id)initWithFrame:(CGRect)frame views:(NSMutableArray *)views autoScroll:(BOOL)autoScroll interval:(CGFloat)interval direction:(GBAutoScrollDirection)direction;

// Sets the automatic scroll flag.
- (void)setAutoScroll:(BOOL)autoScroll;

// Sets the automatic scroll flag and the automatic time interval.
- (void)setAutoScroll:(BOOL)autoScroll interval:(CGFloat)interval;

// Sets the automatic scroll flag, the automatic time interval and the automatic scroll direction.
- (void)setAutoScroll:(BOOL)autoScroll interval:(CGFloat)interval direction:(GBAutoScrollDirection)direction;

// Stops automatic scroll.
- (void)stopAutoScroll;

// Starts automatic scroll.
- (void)startAutoScroll;

// Adds a view.
- (void)addView:(UIView *)view;

// Resets the GBInfiniteScrollView and initializes it with the array of UIViews.
- (void)resetWithViews:(NSMutableArray *)views;

// Gets the current view.
- (UIView *)currentView;

@end

@protocol GBInfiniteScrollViewDelegate <NSObject>

@optional

// Called when the GBInfiniteScrollView has scrolled to next page.
- (void)infiniteScrollViewDidScrollNextPage:(GBInfiniteScrollView *)infiniteScrollView;

// Called when the GBInfiniteScrollView has scrolled to previous page.
- (void)infiniteScrollViewDidScrollPreviousPage:(GBInfiniteScrollView *)infiniteScrollView;

@end
