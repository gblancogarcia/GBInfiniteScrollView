GBInfiniteScrollView
========================

`GBInfiniteScrollView` class provides an endlessly scroll view organized in pages. It is a subclass of `UIScrollView`, which allows users to scroll infinitely in horizontal and vertical direction. `GBInfiniteScrollView` also provides automatic scrolling feature.

A `GBInfiniteScrollView` object must have an object that acts as a data source and an object that acts as a delegate. The data source must adopt the `GBInfiniteScrollViewDataSource` protocol and the delegate must adopt the `GBInfiniteScrollViewDelegate` protocol. The data source provides the views that `GBInfiniteScrollView` needs to display. The delegate allows the adopting delegate to respond to scrolling operations.

`GBInfiniteScrollView` overrides the `layoutSubviews` method of `UIView` so that it calls `reloadData` only when you create a new instance of `GBInfiniteScrollView` or when you assign a new data source. Reloading the infinite scroll view clears current state, including the current view, but it is possible to specify the initial page index to display.

It is based on Apple StreetScroller iOS sample code.

[![](https://dl.dropboxusercontent.com/u/5359105/GBInfiniteScrollView/0.png)](https://dl.dropboxusercontent.com/u/5359105/GBInfiniteScrollView/0@2x.png)
[![](https://dl.dropboxusercontent.com/u/5359105/GBInfiniteScrollView/1.png)](https://dl.dropboxusercontent.com/u/5359105/GBInfiniteScrollView/1@2x.png)
[![](https://dl.dropboxusercontent.com/u/5359105/GBInfiniteScrollView/2.png)](https://dl.dropboxusercontent.com/u/5359105/GBInfiniteScrollView/2@2x.png)
[![](https://dl.dropboxusercontent.com/u/5359105/GBInfiniteScrollView/3.png)](https://dl.dropboxusercontent.com/u/5359105/GBInfiniteScrollView/3@2x.png)

## Requirements

`GBInfiniteScrollView` works on iOS 6.1 SDK or later and is compatible with ARC projects.

## Adding GBInfiniteScrollView to your project

### Cocoapods

[CocoaPods](http://cocoapods.org) is the recommended way to add GBInfiniteScrollView to your project.

1. Add a pod entry for `GBInfiniteScrollView` to your Podfile `pod 'GBInfiniteScrollView', '~> 1.6'`
2. Install the pod(s) by running `pod install`.
3. Include GBInfiniteScrollView wherever you need it with `#import <GBInfiniteScrollView/GBInfiniteScrollView.h>`.

For the page control subclass.

1. Add a pod entry for `GBInfiniteScrollView/PageControl` to your Podfile `pod 'GBInfiniteScrollView/PageControl'`
2. Install the pod(s) by running `pod install`.
3. Include GBInfiniteScrollViewWithPageControl wherever you need it with `#import <GBInfiniteScrollView/GBInfiniteScrollViewWithPageControl.h>`.

### Source files

You can directly add the header and implementation files to your project.

1. Download the [latest code version](https://github.com/gblancogarcia/GBInfiniteScrollView/archive/master.zip). 
2. Open your project in Xcode, then drag and drop the header and implementation files onto your project (use the "Product Navigator view"). Make sure to select Copy items when asked if you extracted the code archive outside of your project. 
3. Include `GBInfiniteScrollView` wherever you need it with `#import <GBInfiniteScrollView/GBInfiniteScrollView.h>`.

### Static library

You can also add `GBInfiniteScrollView` as a static library to your project or workspace. 

1. Download the [latest code version](https://github.com/gblancogarcia/GBInfiniteScrollView/archive/master.zip) or add the repository as a git submodule to your git-tracked project. 
2. Open your project in Xcode, then drag and drop `GBInfiniteScrollView.xcodeproj` onto your project or workspace (use the "Product Navigator view"). 
3. Select your target and go to the Build phases tab. In the Link Binary With Libraries section select the add button. On the sheet find and add `libGBInfiniteScrollView.a`. You might also need to add `GBInfiniteScrollView` to the Target Dependencies list. 
3. Include `GBInfiniteScrollView` wherever you need it with `#import <GBInfiniteScrollView/GBInfiniteScrollView.h>`.

## Usage

This is an example of use:

First, import `GBInfiniteScrollView` lib. Your view controller must conform to the `GBInfiniteScrollViewDataSource` and `GBInfiniteScrollViewDelegate` protocols.

```objective-c
#import <UIKit/UIKit.h>

#import <GBInfiniteScrollView/GBInfiniteScrollView.h>

@interface GBViewController : UIViewController <GBInfiniteScrollViewDataSource, GBInfiniteScrollViewDelegate>

@end
```

Then, initialize a `GBInfiniteScrollView` new instance.

```objective-c
GBInfiniteScrollView *infiniteScrollView = [[GBInfiniteScrollView alloc] initWithFrame:self.view.bounds];

infiniteScrollView.infiniteScrollViewDataSource = self;
infiniteScrollView.infiniteScrollViewDelegate = self;

infiniteScrollView.pageIndex = 0;
    
[self.view addSubview:infiniteScrollView];
    
[infiniteScrollView reloadData];

[infiniteScrollView startAutoScroll];

```

Finally, implement the `GBInfiniteScrollViewDataSource` and `GBInfiniteScrollViewDelegate` protocols methods.

```objective-c
- (void)infiniteScrollViewDidScrollNextPage:(GBInfiniteScrollView *)infiniteScrollView
{
    NSLog(@"Next page");
}

- (void)infiniteScrollViewDidScrollPreviousPage:(GBInfiniteScrollView *)infiniteScrollView
{
    NSLog(@"Previous page");
}

- (BOOL)infiniteScrollViewShouldScrollNextPage:(GBInfiniteScrollView *)infiniteScrollView
{
    return YES;
}

- (BOOL)infiniteScrollViewShouldScrollPreviousPage:(GBInfiniteScrollView *)infiniteScrollView
{
    return YES;
}

- (NSInteger)numberOfPagesInInfiniteScrollView:(GBInfiniteScrollView *)infiniteScrollView
{
    return self.data.count;
}

- (GBInfiniteScrollViewPage *)infiniteScrollView:(GBInfiniteScrollView *)infiniteScrollView pageAtIndex:(NSUInteger)index;
{
    GBPageRecord *record = [self.data objectAtIndex:index];
    GBInfiniteScrollViewPage *page = [infiniteScrollView dequeueReusablePage];
    
    if (page == nil) {
        page = [[GBInfiniteScrollViewPage alloc] initWithFrame:self.view.bounds style:GBInfiniteScrollViewPageStyleText];
    }
    
    page.textLabel.text = record.text;
    page.textLabel.textColor = record.textColor;
    page.contentView.backgroundColor = record.backgroundColor;
    page.textLabel.font = [UIFont fontWithName: @"HelveticaNeue-UltraLight" size:128.0f];
    
    return page;
}
```

## License

The MIT License (MIT)

Copyright (c) 2013 Gerardo Blanco

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
