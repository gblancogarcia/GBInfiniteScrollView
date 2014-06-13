//
//  GBInfiniteScrollViewWithPageControl.h
//  GBInfiniteScrollView
//
//  Created by Guillermo Saenz on 6/1/14.
//  Copyright (c) 2014 Gerardo Blanco García. All rights reserved.
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

#import "GBInfiniteScrollView.h"
#import "FXPageControl.h"

typedef enum : NSUInteger {
    GBPageControlPositionVerticalRight,     /**<
                                             * The page control position will be on the right side of the X axis.
                                             * ----------
                                             * |        |
                                             * |      . |
                                             * |      . |
                                             * |      . |
                                             * |      . |
                                             * |        |
                                             * ----------
                                             */
    GBPageControlPositionVerticalLeft,      /**<
                                             * The page control position will be on the left side of the X axis.
                                             * ----------
                                             * |        |
                                             * | .      |
                                             * | .      |
                                             * | .      |
                                             * | .      |
                                             * |        |
                                             * ----------
                                             * @warning Default
                                             */
    GBPageControlPositionHorizontalBottom,  /**<
                                             * The page control position will be on the bottom side of the Y axis.
                                             * ----------
                                             * |        |
                                             * |        |
                                             * |        |
                                             * |        |
                                             * |        |
                                             * |  ....  |
                                             * ----------
                                             * @warning Default
                                             */
    GBPageControlPositionHorizontalTop,     /**<
                                             * The page control position will be on the top side of the Y axis.
                                             * ----------
                                             * |  ....  |
                                             * |        |
                                             * |        |
                                             * |        |
                                             * |        |
                                             * |        |
                                             * ----------
                                             */
} GBPageControlPosition;

@class GBPageControlViewContainer;

#pragma mark - GBInfiniteScrollViewWithPageControl Interface

@interface GBInfiniteScrollViewWithPageControl : GBInfiniteScrollView

/**
 *  The position of the page control. The rotation is automatically set from the scrollDirection property.
 *  @warning Default: GBPageControlPositionHorizontalBottom | GBPageControlPositionVerticalLeft
 */
@property (nonatomic) GBPageControlPosition pageControlPosition;

/**
 *  Max number of dots. If 0 it won't be taken into account
 *  @warning Default value 0
 */
@property (nonatomic, assign) NSInteger maxDots;

/**
 *  Use this view only for the customization of the frame, center or rotation properties.
 */
@property (nonatomic, strong) GBPageControlViewContainer *pageControlViewContainer;

@end

#pragma mark - GBPageControlViewContainer Interface

@interface GBPageControlViewContainer : UIView;

/**
 *  See FXPageControl GitHub to see all the properties that can be customized.
 *  @warning Only for customizing purpose. For custom frame, center or rotation use the container.
 */
@property (nonatomic, strong) FXPageControl *pageControl;

@end
