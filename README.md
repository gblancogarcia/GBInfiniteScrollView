GBInfiniteScrollView
========================

The GBInfiniteScrollView class provides an endlessly scroll view organized in pages. It is an UIScrollView subclass that can scroll infinitely in the horizontal direction. GBInfiniteScrollView also provides auto scroll functionality. It allows you to add views dynamically. It is based on Apple StreetScroller iOS sample code.

[![](https://dl.dropboxusercontent.com/u/5359105/GBInfiniteScrollView/Launch-thumb.png)](https://dl.dropboxusercontent.com/u/5359105/GBInfiniteScrollView/Launch.png)
[![](https://dl.dropboxusercontent.com/u/5359105/GBInfiniteScrollView/0-thumb.png)](https://dl.dropboxusercontent.com/u/5359105/GBInfiniteScrollView/0.png)
[![](https://dl.dropboxusercontent.com/u/5359105/GBInfiniteScrollView/1-thumb.png)](https://dl.dropboxusercontent.com/u/5359105/GBInfiniteScrollView/1.png)
[![](https://dl.dropboxusercontent.com/u/5359105/GBInfiniteScrollView/2-thumb.png)](https://dl.dropboxusercontent.com/u/5359105/GBInfiniteScrollView/2.png)
[![](https://dl.dropboxusercontent.com/u/5359105/GBInfiniteScrollView/Multitask-thumb.png)](https://dl.dropboxusercontent.com/u/5359105/GBInfiniteScrollView/Multitask.png)

## Requirements

GBInfiniteScrollView works on iOS 7 SDK or later and is compatible with ARC projects.

## Adding GBInfiniteScrollView to your project

### Source files

You can directly add the `GBInfiniteScrollView.h` and `GBInfiniteScrollView.m` source files to your project.

1. Download the [latest code version](https://github.com/gblancogarcia/GBInfiniteScrollView/archive/master.zip). 
2. Open your project in Xcode, then drag and drop `GBInfiniteScrollView.h` and `GBInfiniteScrollView.m` onto your project (use the "Product Navigator view"). Make sure to select Copy items when asked if you extracted the code archive outside of your project. 
3. Include GBInfiniteScrollView wherever you need it with `#import "GBInfiniteScrollView.h"`.

### Static library

You can also add GBInfiniteScrollView as a static library to your project or workspace. 

1. Download the [latest code version](https://github.com/gblancogarcia/GBInfiniteScrollView/archive/master.zip) or add the repository as a git submodule to your git-tracked project. 
2. Open your project in Xcode, then drag and drop `GBInfiniteScrollView.xcodeproj` onto your project or workspace (use the "Product Navigator view"). 
3. Select your target and go to the Build phases tab. In the Link Binary With Libraries section select the add button. On the sheet find and add `libGBInfiniteScrollView.a`. You might also need to add `GBInfiniteScrollView` to the Target Dependencies list. 
4. Include GBInfiniteScrollView wherever you need it with `#import <GBInfiniteScrollView/GBInfiniteScrollView.h>`.

## Usage

To use it, you simply need to an instance of GBInfiniteScrollView.

First, initialize the GBInfiniteScrollView with a placeholder or an array of views.
```objective-c
// A convenience initializer that initializes the GBInfiniteScrollView with the placeholder UIView.
- (id)initWithFrame:(CGRect)frame placeholder:(UIView *)placeholder;

// A convenience initializer that initializes the GBInfiniteScrollView with the array of UIViews.
- (id)initWithFrame:(CGRect)frame views:(NSMutableArray *)views;
```

There are also available the following Initializers:

```objective-c
// A convenience initializer that initializes the GBInfiniteScrollView with the array of UIViews and the automatic scroll flag.
- (id)initWithFrame:(CGRect)frame views:(NSMutableArray *)views autoScroll:(BOOL)autoScroll;

// A convenience initializer that initializes the GBInfiniteScrollView with the array of UIViews, the automatic scroll flag and the automatic time interval.
- (id)initWithFrame:(CGRect)frame views:(NSMutableArray *)views autoScroll:(BOOL)autoScroll interval:(CGFloat)interval;

// A convenience initializer that initializes the GBInfiniteScrollView with the array of UIViews, the automatic scroll flag, the automatic time interval and the automatic scroll direction.
- (id)initWithFrame:(CGRect)frame views:(NSMutableArray *)views autoScroll:(BOOL)autoScroll interval:(CGFloat)interval direction:(GBAutoScrollDirection)direction;
```

You can enable/disable and configure the auto scroll functionality with the following methods:

```objective-c
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
```

Add a view or and array of views:

```objective-c
// Adds a view.
- (void)addView:(UIView *)view;

// Resets the GBInfiniteScrollView and initializes it with the array of UIViews.
- (void)resetWithViews:(NSMutableArray *)views;
```

It is possible to get the current view with the following method:

```objective-c
// Gets the current view.
- (UIView *)currentView;
```

It is also avaliable a delegete that conforms the `GBInfiniteScrollViewDelegate` protocol:


```objective-c
// Infinite scroll view delegate.
@property (nonatomic, assign) id <GBInfiniteScrollViewDelegate> infiniteScrollViewDelegate;
```


```objective-c
@protocol GBInfiniteScrollViewDelegate <NSObject>

@optional

// Called when the GBInfiniteScrollView scrolled to next page.
- (void)infiniteScrollViewDidScrollNextPage:(GBInfiniteScrollView *)infiniteScrollView;

// Called when the GBInfiniteScrollView scrolled to previous page.
- (void)infiniteScrollViewDidScrollPreviousPage:(GBInfiniteScrollView *)infiniteScrollView;

@end
```

##License (MIT)

Copyright (c) 2013 Gerardo Blanco

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
