//
//  GBViewController.m
//  GBInfiniteScrollViewDemo
//
//  Created by Gerardo Blanco García on 01/10/13.
//  Copyright (c) 2013 Gerardo Blanco García. All rights reserved.
//

#import "GBViewController.h"

static CGFloat const GBNumberOfViews = 1000.0f;
static CGFloat const GBMaxNumberOfViews = 10000.0f;

@interface GBViewController ()

@property (nonatomic, strong) UIImageView *placeholder;
@property (nonatomic, strong) NSMutableArray *views;
@property (nonatomic, strong) GBInfiniteScrollView *infiniteScrollView;
@property (nonatomic, strong) UIButton *stopOrStartButton;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIColor *color;

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
    self.views = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < GBNumberOfViews; i++) {
        [self addRandomColorView];
    }
    
    self.infiniteScrollView = [[GBInfiniteScrollView alloc] initWithFrame:self.view.bounds];
    self.infiniteScrollView.infiniteScrollViewDataSource = self;
    self.infiniteScrollView.infiniteScrollViewDelegate = self;
    self.infiniteScrollView.pageIndex = 0;
    
    [self.view addSubview:self.infiniteScrollView];
    
    [self.infiniteScrollView reloadData];
    
    [self setupAddButton];
    [self setupStopOrPlayButton];
}

- (void)setupAddButton
{
    self.addButton = [[UIButton alloc] init];
    [self.addButton setTitle:@"+" forState:UIControlStateNormal];
    self.addButton.titleLabel.font = [UIFont fontWithName: @"HelveticaNeue-UltraLight" size:64.0f];
    
    [self.addButton addTarget:self
                       action:@selector(addRandomColorView)
             forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.addButton];
    
    [self.addButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.addButton
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:1.0f
                                                              constant:96.0f];
    
    [self.view addConstraint:width];
    
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.addButton
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0f
                                                               constant:96.0f];
    
    [self.view addConstraint:height];
    
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.addButton
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0f
                                                               constant:0.0f];
    
    [self.view addConstraint:bottom];
    
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.addButton
                                                            attribute:NSLayoutAttributeLeft
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.view
                                                            attribute:NSLayoutAttributeLeft
                                                           multiplier:1.0f
                                                             constant:0.0f];
    
    [self.view addConstraint:left];
}

- (void)setupStopOrPlayButton
{
    if (!self.stopOrStartButton) {
        self.stopOrStartButton = [[UIButton alloc] init];
        [self.stopOrStartButton setTitle:@"Start" forState:UIControlStateNormal];
        [self.stopOrStartButton addTarget:self
                                   action:@selector(stopOrStartAutoScroll)
                         forControlEvents:UIControlEventTouchUpInside];
        
        if (self.views.count < 2) {
            self.stopOrStartButton.hidden = YES;
        }
        
        [self.view addSubview:self.stopOrStartButton];
        
        [self.stopOrStartButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.stopOrStartButton
                                                                  attribute:NSLayoutAttributeBottom
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0f
                                                                   constant:-24.0f];
        
        [self.view addConstraint:bottom];
        
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.stopOrStartButton
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.view
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0f
                                                                  constant:-32.0f];
        
        [self.view addConstraint:right];
    }
}

- (void)addRandomColorView
{
    if (self.views.count >= GBMaxNumberOfViews) {
        self.addButton.hidden = YES;
    } else {
        [self.views addObject:[self randomColorView]];
    }
    
    if (self.views.count > 1) {
        self.stopOrStartButton.hidden = NO;
    }
}

- (UIView *)randomColorView
{
    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
    view.clipsToBounds = YES;
    
    int i = self.views.count;
    
    view.tag = i;
    
    view.backgroundColor = self.color;
    
    self.color = [self nextColor:self.color];
    
    UILabel *label = [[UILabel alloc] init];
    
    label.font = [UIFont fontWithName: @"HelveticaNeue-UltraLight" size:[self fontSizeForNumber:i]];
    label.text = [NSString stringWithFormat:@"%d", i];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = self.color;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [label sizeToFit];

    [view addSubview:label];
    
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:label
                                                            attribute:NSLayoutAttributeLeft
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:view
                                                            attribute:NSLayoutAttributeLeft
                                                           multiplier:1.0f
                                                             constant:16.0f];
    
    [view addConstraint:left];
    
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:label
                                                             attribute:NSLayoutAttributeRight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:view
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1.0f
                                                              constant:-16.0f];
    
    [view addConstraint:right];
    
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:label
                                                               attribute:NSLayoutAttributeCenterY
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:view
                                                               attribute:NSLayoutAttributeCenterY
                                                              multiplier:1.0f
                                                                constant:0.0f];
    
    [view addConstraint:centerY];

    return view;
}

- (UIColor *)color
{
    if (!_color) {
        _color = [self randomColor];
    }
    
    return _color;
}

- (UIColor *)randomColor
{
    CGFloat hue = (arc4random() % 256 / 256.0f);
    CGFloat saturation = (arc4random() % 128 / 256.0f) + 0.5f;
    CGFloat brightness = (arc4random() % 128 / 256.0f) + 0.5f;
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1.0f];
    
    return color;
}

static CGFloat const GBGoldenRatio = 0.618033988749895f;

- (UIColor *)nextColor:(UIColor *)color
{
    UIColor *nextColor;
    
    CGFloat hue;
    CGFloat saturation;
    CGFloat brightness;
    CGFloat alpha;
    
    BOOL success = [color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    
    if (success) {
        hue = fmodf(hue + GBGoldenRatio, 1.0);
        nextColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1.0f];
    }
    
    return nextColor;
}

- (void)stopOrStartAutoScroll
{
    if ([self.stopOrStartButton.titleLabel.text isEqualToString:@"Stop"]) {
        [self.infiniteScrollView stopAutoScroll];
        [self.stopOrStartButton setTitle:@"Start" forState:UIControlStateNormal];
    } else {
        [self.infiniteScrollView startAutoScroll];
        [self.stopOrStartButton setTitle:@"Stop" forState:UIControlStateNormal];
    }
}

- (void)infiniteScrollViewDidScrollNextPage:(GBInfiniteScrollView *)infiniteScrollView
{
    NSLog(@"Next page");
}

- (void)infiniteScrollViewDidScrollPreviousPage:(GBInfiniteScrollView *)infiniteScrollView
{
    NSLog(@"Previous page");
}

- (NSInteger)numberOfPagesInInfiniteScrollView:(GBInfiniteScrollView *)infiniteScrollView
{
    NSLog(@"%d", self.views.count);
    return self.views.count;
}

- (UIView *)infiniteScrollView:(GBInfiniteScrollView *)infiniteScrollView viewAtPageIndex:(NSUInteger)pageIndex
{
    return[self.views objectAtIndex:pageIndex];
}

- (CGFloat)fontSizeForNumber:(int)number
{
    CGFloat scale = 0;
    
    if (number >= 100.0f) {
        scale = 1;
    } else if (number >= 1000.0f) {
        scale = 2;
    }
    
    return 192.0f - (64.0f * scale);
}

@end
