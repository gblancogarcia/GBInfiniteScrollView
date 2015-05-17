//
//  GBInfiniteScrollViewPage.h
//  GBInfiniteScrollView
//
//  Created by Gerardo Blanco García on 02/12/13.
//  Copyright (c) 2013 Gerardo Blanco García. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GBInfiniteScrollViewPageStyle) {
    /** Page Style Custom. */
    GBInfiniteScrollViewPageStyleCustom,
    /** Page Style Text. */
    GBInfiniteScrollViewPageStyleText,
    /** Page Style Image */
    GBInfiniteScrollViewPageStyleImage
};

@interface GBInfiniteScrollViewPage : UIView

/**
*  Initializes and returns a newly allocated view object with the specified page style.
*
*  @param style The GBInfiniteScrollViewPageStyle type.
*
*  @return An initialized view object or nil if the object couldn't be created.
*/
- (id)initWithStyle:(GBInfiniteScrollViewPageStyle)style;

/**
 *  Initializes and returns a newly allocated view object with the specified frame rectangle.
 *
 *  @param frame The frame rectangle for the view, measured in points. The origin of the frame is relative to the 
 *               superview in which you plan to add it. This method uses the frame rectangle to set the center and 
 *               bounds properties accordingly.
 *  @param style The GBInfiniteScrollViewPageStyle type.
 *
 *  @return An initialized view object or nil if the object couldn't be created.
 */
- (id)initWithFrame:(CGRect)frame style:(GBInfiniteScrollViewPageStyle)style;

/**
 * Contains the content view.
 */
@property (nonatomic, strong, readonly) UIView *contentView;

/**
 * Contains the custom text label.
 */
@property (nonatomic, strong, readonly) UILabel *textLabel;

/**
 * Contains the custom image view.
 */
@property (nonatomic, strong, readonly) UIImageView *imageView;

/**
 * Contains the custom view.
 */
@property (nonatomic, strong) UIView *customView;

/**
 * Prepair the object for reuse.
 */
- (void)prepareForReuse;

@end
