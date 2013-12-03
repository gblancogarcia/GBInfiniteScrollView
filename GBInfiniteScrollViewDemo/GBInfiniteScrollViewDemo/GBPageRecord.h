//
//  GBRecord.h
//  GBInfiniteScrollViewDemo
//
//  Created by Gerardo Blanco García on 02/12/13.
//  Copyright (c) 2013 Gerardo Blanco García. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GBPageRecord : NSObject

@property (nonatomic) NSUInteger index;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *backgroundColor;

@end
