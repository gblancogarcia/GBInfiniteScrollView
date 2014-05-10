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
@property (nonatomic, strong) UIButton *directionButton;
@property (nonatomic, strong) UIButton *infoButton;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *stopButton;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic) GBAutoScrollDirection direction;
@property(nonatomic) CGAffineTransform rightToLeftTransform;
@property(nonatomic) CGAffineTransform leftToRightTransform;
@property(nonatomic) BOOL debug;

@end

@implementation GBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUp];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.debug) {
        NSLog(@"View Did Appear");
    }
    
    [self.infiniteScrollView updateData];
}

- (void)setUp
{
    self.debug = YES;
    self.data = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < GBNumberOfPages; i++) {
        [self addRandomColorPage];
    }
    
    self.infiniteScrollView = [[GBInfiniteScrollView alloc] initWithFrame:self.view.bounds];
    self.infiniteScrollView.infiniteScrollViewDataSource = self;
    self.infiniteScrollView.infiniteScrollViewDelegate = self;
    self.infiniteScrollView.debug = self.debug;
    self.infiniteScrollView.interval = 3.0f;
    self.infiniteScrollView.pageIndex = 0;
    self.infiniteScrollView.direction = GBAutoScrollDirectionRightToLeft;

    [self.view addSubview:self.infiniteScrollView];
    
    [self.infiniteScrollView reloadData];
    
    [self setUpDirectionButton];
    [self setUpInfoButton];
    [self setUpAddButton];
    [self setUpPlayButton];
    [self setUpStopButton];
}

- (void)setUpDirectionButton
{
    self.directionButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 64.0f, 64.0f)];
    
    [self.directionButton setImage:[UIImage imageNamed:@"ArrowButton"] forState:UIControlStateNormal];
    [self.directionButton setImage:[UIImage imageNamed:@"ArrowButtonHighlighted"] forState:UIControlStateHighlighted];
    
    [self.directionButton addTarget:self
                       action:@selector(switchDirection)
             forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.directionButton];
    
    [self.directionButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    CGFloat constant = 24.0f;
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        constant -= 20.0f;
    }
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.directionButton
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1.0f
                                                               constant:constant];
    
    [self.view addConstraint:top];
    
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.directionButton
                                                            attribute:NSLayoutAttributeLeft
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.view
                                                            attribute:NSLayoutAttributeLeft
                                                           multiplier:1.0f
                                                             constant:16.0f];
    
    [self.view addConstraint:left];
    
    self.leftToRightTransform = self.directionButton.transform;
    self.rightToLeftTransform = CGAffineTransformRotate(self.directionButton.transform, M_PI);
    self.directionButton.transform = self.rightToLeftTransform;
}

- (void)setUpInfoButton
{
    self.infoButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 64.0f, 64.0f)];
    
    [self.infoButton setImage:[UIImage imageNamed:@"InfoButton"] forState:UIControlStateNormal];
    [self.infoButton setImage:[UIImage imageNamed:@"InfoButtonHighlighted"] forState:UIControlStateHighlighted];
    
    [self.infoButton addTarget:self
                             action:@selector(info)
                   forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.infoButton];
    
    [self.infoButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    CGFloat constant = 24.0f;
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        constant -= 20.0f;
    }
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.infoButton
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.view
                                                           attribute:NSLayoutAttributeTop
                                                          multiplier:1.0f
                                                            constant:constant];
    
    [self.view addConstraint:top];
    
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.infoButton
                                                            attribute:NSLayoutAttributeRight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.view
                                                            attribute:NSLayoutAttributeRight
                                                           multiplier:1.0f
                                                             constant:-16.0f];
    
    [self.view addConstraint:right];
}

- (void)setUpAddButton
{
    self.addButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 64.0f, 64.0f)];
    
    [self.addButton setImage:[UIImage imageNamed:@"AddButton"] forState:UIControlStateNormal];
    [self.addButton setImage:[UIImage imageNamed:@"AddButtonHighlighted"] forState:UIControlStateHighlighted];

    [self.addButton addTarget:self
                       action:@selector(addRandomColorPage)
             forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.addButton];
    
    [self.addButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.addButton
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0f
                                                               constant:-16.0f];
    
    [self.view addConstraint:bottom];
    
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.addButton
                                                            attribute:NSLayoutAttributeLeft
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.view
                                                            attribute:NSLayoutAttributeLeft
                                                           multiplier:1.0f
                                                             constant:16.0f];
    
    [self.view addConstraint:left];
}

- (void)setUpPlayButton
{
    if (!self.playButton) {
        self.playButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 64.0f, 64.0f)];

        [self.playButton setImage:[UIImage imageNamed:@"PlayButton"] forState:UIControlStateNormal];
        [self.playButton setImage:[UIImage imageNamed:@"PlayButtonHighlighted"] forState:UIControlStateHighlighted];
        
        [self.playButton addTarget:self
                                   action:@selector(startAutoScroll)
                         forControlEvents:UIControlEventTouchUpInside];
        
        if (self.data.count < 2) {
            self.playButton.hidden = YES;
        }
        
        [self.view addSubview:self.playButton];
        
        [self.playButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.playButton
                                                                  attribute:NSLayoutAttributeBottom
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0f
                                                                   constant:-16.0f];
        
        [self.view addConstraint:bottom];
        
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.playButton
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.view
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0f
                                                                  constant:-16.0f];
        
        [self.view addConstraint:right];
    }
}

- (void)setUpStopButton
{
    if (!self.stopButton) {
        self.stopButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 64.0f, 64.0f)];
        
        [self.stopButton setImage:[UIImage imageNamed:@"StopButton"] forState:UIControlStateNormal];
        [self.stopButton setImage:[UIImage imageNamed:@"StopButtonHighlighted"] forState:UIControlStateHighlighted];
        
        [self.stopButton addTarget:self
                            action:@selector(stopAutoScroll)
                  forControlEvents:UIControlEventTouchUpInside];
        
        self.stopButton.hidden = YES;
        
        [self.view addSubview:self.stopButton];
        
        [self.stopButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.stopButton
                                                                  attribute:NSLayoutAttributeBottom
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0f
                                                                   constant:-16.0f];
        
        [self.view addConstraint:bottom];
        
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.stopButton
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.view
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0f
                                                                  constant:-16.0f];
        
        [self.view addConstraint:right];
    }
}

- (void)switchDirection
{
    CGAffineTransform transform;
    GBAutoScrollDirection direction;
    
    if (self.direction == GBAutoScrollDirectionLeftToRight) {
        transform = self.rightToLeftTransform;
        direction = GBAutoScrollDirectionRightToLeft;
    } else if (self.direction == GBAutoScrollDirectionRightToLeft) {
        transform = self.leftToRightTransform;
        direction = GBAutoScrollDirectionLeftToRight;
    }
    
    [UIView beginAnimations:@"Rotate" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5f];

    self.directionButton.transform = transform;
    
    [UIView commitAnimations];
    
    self.direction = direction;
    self.infiniteScrollView.direction = self.direction;
}

- (void)info
{
    NSString *identifier = @"Detail Segue";
    [self performSegueWithIdentifier:identifier sender:self];
}

- (void)addRandomColorPage
{
    if (self.data.count >= GBMaxNumberOfPages) {
        self.addButton.hidden = YES;
    } else {
        [self.data addObject:[self randomColorPageRecord]];
    }
    
    if (self.data.count > 1 && [self.playButton isHidden] && [self.stopButton isHidden]) {
        self.playButton.hidden = NO;
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

- (void)startAutoScroll
{
    [self.infiniteScrollView startAutoScroll];
    self.playButton.hidden = YES;
    self.stopButton.hidden = NO;
}

- (void)stopAutoScroll
{
    [self.infiniteScrollView stopAutoScroll];
    self.playButton.hidden = NO;
    self.stopButton.hidden = YES;
}

- (void)infiniteScrollViewDidScrollNextPage:(GBInfiniteScrollView *)infiniteScrollView
{
    if (self.debug) {
        NSLog(@"Did Scroll Next Page");
    }
}

- (void)infiniteScrollViewDidScrollPreviousPage:(GBInfiniteScrollView *)infiniteScrollView
{
    if (self.debug) {
        NSLog(@"Did Scroll Previous Page");
    }
}

- (NSInteger)numberOfPagesInInfiniteScrollView:(GBInfiniteScrollView *)infiniteScrollView
{
    return self.data.count;
}

- (GBInfiniteScrollViewPage *)infiniteScrollView:(GBInfiniteScrollView *)infiniteScrollView pageAtIndex:(NSUInteger)index;
{
    NSLog(@"Page at index %d", index);

    GBPageRecord *record = [self.data objectAtIndex:index];
    GBInfiniteScrollViewPage *page = [infiniteScrollView dequeueReusablePage];
    
    if (page == nil) {
        page = [[GBInfiniteScrollViewPage alloc] initWithFrame:self.view.bounds style:GBInfiniteScrollViewPageStyleText];
    }
    
    page.textLabel.text = record.text;
    page.textLabel.textColor = record.textColor;
    page.contentView.backgroundColor = record.backgroundColor;
    page.textLabel.font = [UIFont fontWithName: @"HelveticaNeue-UltraLight" size:[self fontSizeForNumber:(int)record.index]];
    
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
