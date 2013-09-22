GBInfiniteLoopScrollView
========================

GBInfiniteLoopScrollView is a subclass of UIView. It contains an endlessly horizontal scrollable UIScrollView.

## Screenshots

[![](https://dl.dropboxusercontent.com/u/5359105/GBInfiniteLoopScrollView/Launch-thumb.png)](https://dl.dropboxusercontent.com/u/5359105/GBInfiniteLoopScrollView/Launch.png)
[![](https://dl.dropboxusercontent.com/u/5359105/GBInfiniteLoopScrollView/0-thumb.png)](https://dl.dropboxusercontent.com/u/5359105/GBInfiniteLoopScrollView/0.png)
[![](https://dl.dropboxusercontent.com/u/5359105/GBInfiniteLoopScrollView/1-thumb.png)](https://dl.dropboxusercontent.com/u/5359105/GBInfiniteLoopScrollView/1.png)
[![](https://dl.dropboxusercontent.com/u/5359105/GBInfiniteLoopScrollView/2-thumb.png)](https://dl.dropboxusercontent.com/u/5359105/GBInfiniteLoopScrollView/2.png)

## Requirements

GBInfiniteLoopScrollView works on iOS 7 and is compatible with ARC projects.

## Adding GBInfiniteLoopScrollView to your project

### Source files

You can directly add the `GBInfiniteLoopScrollView.h` and `GBInfiniteLoopScrollView.m` source files to your project.

1. Download the [latest code version](https://github.com/gblancogarcia/GBInfiniteLoopScrollView/archive/master.zip). 
2. Open your project in Xcode, then drag and drop `GBInfiniteLoopScrollView.h` and `GBInfiniteLoopScrollView.m` onto your project (use the "Product Navigator view"). Make sure to select Copy items when asked if you extracted the code archive outside of your project. 
3. Include GBInfiniteLoopScrollView wherever you need it with `#import "GBInfiniteLoopScrollView.h"`.

## Usage

```objective-c

#import "GBInfiniteLoopScrollView.h"

GBInfiniteLoopScrollView *infiniteLoopScrollView = [[GBInfiniteLoopScrollView alloc] initWithFrame:frame placeholder:placeholder];
}];
[infiniteLoopScrollView addView:view];
```

[...]
