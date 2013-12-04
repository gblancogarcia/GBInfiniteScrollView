//
//  GBViewController.m
//  GBInfiniteScrollViewDemo
//
//  Created by Gerardo Blanco García on 01/10/13.
//  Copyright (c) 2013 Gerardo Blanco García. All rights reserved.
//

#import "GBViewController.h"

#import "GBPageRecord.h"

static CGFloat const GBNumberOfPages = 1000.0f;
static CGFloat const GBMaxNumberOfPages = 10000.0f;

@interface GBViewController ()

@property (nonatomic, strong) UIImageView *placeholder;
@property (nonatomic, strong) NSMutableArray *data;
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
    self.data = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < GBNumberOfPages; i++) {
        [self addRandomColorPage];
    }
    
    self.infiniteScrollView = [[GBInfiniteScrollView alloc] initWithFrame:self.view.bounds];
    self.infiniteScrollView.infiniteScrollViewDataSource = self;
    self.infiniteScrollView.infiniteScrollViewDelegate = self;
    self.infiniteScrollView.pageIndex = 0;
    self.infiniteScrollView.interval = 1.0f;
    
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
                       action:@selector(addRandomColorPage)
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
        
        if (self.data.count < 2) {
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

- (void)addRandomColorPage
{
    if (self.data.count >= GBMaxNumberOfPages) {
        self.addButton.hidden = YES;
    } else {
        [self.data addObject:[self randomColorPageRecord]];
    }
    
    if (self.data.count > 1) {
        self.stopOrStartButton.hidden = NO;
    }
}

- (GBPageRecord *)randomColorPageRecord
{
    GBPageRecord *pageRecord = [[GBPageRecord alloc] init];
    
    pageRecord.index = self.data.count;
    pageRecord.text = [NSString stringWithFormat: @"%lu", (unsigned long)[self.data count]];
    pageRecord.backgroundColor = self.color;
    self.color = [self nextColor:self.color];
    pageRecord.textColor = self.color;

    return pageRecord;
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
    // NSLog(@"Next page");
}

- (void)infiniteScrollViewDidScrollPreviousPage:(GBInfiniteScrollView *)infiniteScrollView
{
    // NSLog(@"Previous page");
}

- (NSInteger)numberOfPagesInInfiniteScrollView:(GBInfiniteScrollView *)infiniteScrollView
{
    return self.data.count;
}

//- (GBInfiniteScrollViewPage *)infiniteScrollView:(GBInfiniteScrollView *)infiniteScrollView pageAtIndex:(NSUInteger)index;
//{
//    GBPageRecord *record = [self.data objectAtIndex:index];
//    GBInfiniteScrollViewPage *page = [infiniteScrollView dequeueReusablePage];
//    
//    if (page == nil) {
//        page = [[GBInfiniteScrollViewPage alloc] initWithFrame:self.view.bounds style:GBInfiniteScrollViewPageStyleText];
//    }
//    
//    page.textLabel.text = record.text;
//    page.textLabel.textColor = record.textColor;
//    page.contentView.backgroundColor = record.backgroundColor;
//
//    page.textLabel.font = [UIFont fontWithName: @"HelveticaNeue-UltraLight" size:[self fontSizeForNumber:record.index]];
//    
//    return page;
//}

- (GBInfiniteScrollViewPage *)infiniteScrollView:(GBInfiniteScrollView *)infiniteScrollView pageAtIndex:(NSUInteger)index;
{
    GBPageRecord *record = [self.data objectAtIndex:index];
    GBInfiniteScrollViewPage *page = [infiniteScrollView dequeueReusablePage];
    
    if (page == nil) {
        page = [[GBInfiniteScrollViewPage alloc] initWithFrame:self.view.bounds style:GBInfiniteScrollViewPageStyleCustom];
    }
    
    UIView *customView = [[UIView alloc] initWithFrame:self.view.bounds];
    customView.backgroundColor = record.backgroundColor;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = record.text;
    label.textColor = record.textColor;
    label.font = [UIFont fontWithName: @"HelveticaNeue-UltraLight" size:[self fontSizeForNumber:record.index]];
    label.textAlignment = NSTextAlignmentCenter;
    label.center = customView.center;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    
    [customView addSubview:label];
    
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:label
                                                               attribute:NSLayoutAttributeCenterX
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:customView
                                                               attribute:NSLayoutAttributeCenterX
                                                              multiplier:1.0f
                                                                constant:0.0f];
    
    [customView addConstraint:centerX];
    
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:label
                                                               attribute:NSLayoutAttributeCenterY
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:customView
                                                               attribute:NSLayoutAttributeCenterY
                                                              multiplier:1.0f
                                                                constant:0.0f];
    
    [customView addConstraint:centerY];
    
    page.customView = customView;
    
    return page;
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
