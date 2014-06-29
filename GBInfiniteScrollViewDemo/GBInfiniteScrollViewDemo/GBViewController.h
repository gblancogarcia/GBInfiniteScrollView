//
//  GBViewController.h
//  GBInfiniteScrollViewDemo
//
//  Created by Gerardo Blanco García on 01/10/13.
//  Copyright (c) 2013 Gerardo Blanco García. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GAITrackedViewController.h"

#import <GBInfiniteScrollView/GBInfiniteScrollView.h>

@interface GBViewController : GAITrackedViewController <GBInfiniteScrollViewDataSource, GBInfiniteScrollViewDelegate>

@end
