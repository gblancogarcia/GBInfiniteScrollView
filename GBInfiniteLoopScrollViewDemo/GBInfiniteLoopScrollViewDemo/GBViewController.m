//
//  GBViewController.m
//  GBInfiniteLoopScrollView
//
//  Created by Gerardo Blanco García on 25/08/13.
//  Copyright (c) 2013 Gerardo Blanco García. All rights reserved.
//

#import "GBViewController.h"

#import "GBInfiniteLoopScrollView.h"

@interface GBViewController ()

@property (nonatomic, retain) GBInfiniteLoopScrollView *infiniteLoopScrollView;
@property (nonatomic, retain) UIColor *color;
@property (nonatomic) int numberOfViews;

@end

@implementation GBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setup
{
    self.numberOfViews = 0;
    
    CGRect frame = self.view.bounds;
    UIImage *image = [UIImage imageNamed:@"Placeholder"];
    UIImageView *placeholder = [[UIImageView alloc] initWithImage:image];
    
    self.infiniteLoopScrollView = [[GBInfiniteLoopScrollView alloc] initWithFrame:frame
                                                                      placeholder:placeholder];
    
    [self.view addSubview:self.infiniteLoopScrollView];
    [self setupAddButton];
}

- (void)setupAddButton
{
    UIButton *addButton = [[UIButton alloc] init];
    [addButton setTitle:@"+" forState:UIControlStateNormal];
    addButton.titleLabel.font = [UIFont fontWithName: @"HelveticaNeue-UltraLight" size:64.0f];
    
    [addButton addTarget:self
                  action:@selector(addRandomColorView)
        forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:addButton];
    
    [addButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:addButton
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:1.0f
                                                              constant:96.0f];
    
    [self.view addConstraint:width];
    
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:addButton
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0f
                                                               constant:96.0f];
    
    [self.view addConstraint:height];
    
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:addButton
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0f
                                                               constant:0.0f];
    
    [self.view addConstraint:bottom];
    
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:addButton
                                                            attribute:NSLayoutAttributeLeft
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.view
                                                            attribute:NSLayoutAttributeLeft
                                                           multiplier:1.0f
                                                             constant:0.0f];
    
    [self.view addConstraint:left];
}

- (void)addRandomColorView
{
    UIView *view = [self randomColorView];
    [self.infiniteLoopScrollView addView:view];
}

- (UIView *)randomColorView
{
    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
    
    int i = self.numberOfViews;
    
    if (!self.color) {
        self.color = [self randomColor];
    }
    
    view.tag = i;
    
    view.backgroundColor = self.color;
    
    self.color = [self randomColor];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:@"%d", i];
    label.font = [UIFont fontWithName: @"HelveticaNeue-UltraLight" size:256.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = self.color;
    [label sizeToFit];
    [view addSubview:label];
    label.center = view.center;

    self.numberOfViews++;
    
    return view;
}

- (UIColor *)randomColor
{
    CGFloat hue = (arc4random() % 256 / 256.0f);
    CGFloat saturation = (arc4random() % 128 / 256.0f) + 0.5f;
    CGFloat brightness = (arc4random() % 128 / 256.0f) + 0.5f;
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1.0f];
    
    return color;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
