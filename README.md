GBInfiniteLoopScrollView
========================

GBInfiniteLoopScrollView is an endlessly UIScrollView organized in pages. It is based on Apple StreetScroller iOS sample code.  It allows you to add UIViews dynamically.

[![](https://dl.dropboxusercontent.com/u/5359105/GBInfiniteLoopScrollView/Launch-thumb.png)](https://dl.dropboxusercontent.com/u/5359105/GBInfiniteLoopScrollView/Launch.png)
[![](https://dl.dropboxusercontent.com/u/5359105/GBInfiniteLoopScrollView/0-thumb.png)](https://dl.dropboxusercontent.com/u/5359105/GBInfiniteLoopScrollView/0.png)
[![](https://dl.dropboxusercontent.com/u/5359105/GBInfiniteLoopScrollView/1-thumb.png)](https://dl.dropboxusercontent.com/u/5359105/GBInfiniteLoopScrollView/1.png)
[![](https://dl.dropboxusercontent.com/u/5359105/GBInfiniteLoopScrollView/2-thumb.png)](https://dl.dropboxusercontent.com/u/5359105/GBInfiniteLoopScrollView/2.png)

## Requirements

GBInfiniteLoopScrollView works on iOS 7 SDK or later and is compatible with ARC projects.

## Adding GBInfiniteLoopScrollView to your project

### Source files

You can directly add the `GBInfiniteLoopScrollView.h` and `GBInfiniteLoopScrollView.m` source files to your project.

1. Download the [latest code version](https://github.com/gblancogarcia/GBInfiniteLoopScrollView/archive/master.zip). 
2. Open your project in Xcode, then drag and drop `GBInfiniteLoopScrollView.h` and `GBInfiniteLoopScrollView.m` onto your project (use the "Product Navigator view"). Make sure to select Copy items when asked if you extracted the code archive outside of your project. 
3. Include GBInfiniteLoopScrollView wherever you need it with `#import "GBInfiniteLoopScrollView.h"`.

## Usage

To use it, you simply need to an an instance of GBInfiniteLoopScrollView.

Init with a placeholder.
```objective-c
GBInfiniteLoopScrollView *scrollView = [[GBInfiniteLoopScrollView alloc] initWithFrame:frame 
                                                                           placeholder:placeholder];
```
Init with an array of views.
```objective-c
GBInfiniteLoopScrollView *scrollView = [[GBInfiniteLoopScrollView alloc] initWithFrame:frame 
                                                                           views:views];
```
Add a view.
```objective-c
[scrollView addView:view];
```

##License (MIT)

Copyright (c) 2013 Gerardo Blanco

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
