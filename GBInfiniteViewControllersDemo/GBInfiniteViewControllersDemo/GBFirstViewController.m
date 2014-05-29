//
//  GBFirstViewController.m
//  GBInfiniteViewControllersDemo
//
//  Created by Gerardo Blanco García on 29/05/14.
//  Copyright (c) 2014 gblancogarcia. All rights reserved.
//

#import "GBFirstViewController.h"

#import "GBRoundBorderedButton.h"

@interface GBFirstViewController ()

@property (nonatomic, strong) GBRoundBorderedButton *button;

@end

@implementation GBFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUp];
}

- (void)setUp
{
    self.view.backgroundColor = [self randomColor];
    
    [self setUpButton];
}

- (UIColor *)randomColor
{
    CGFloat hue = (arc4random() % 256 / 256.0f);
    CGFloat saturation = (arc4random() % 128 / 256.0f) + 0.5f;
    CGFloat brightness = (arc4random() % 128 / 256.0f) + 0.5f;
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1.0f];
    
    return color;
}

- (void)setUpButton
{
    if (!self.button) {
        CGRect frame = CGRectMake(0.0f, 0.0f, 240.0f, 48.0f);
        
        self.button = [[GBRoundBorderedButton alloc] initWithFrame:frame ];
        [self.button setTitle:@"First" forState:UIControlStateNormal];
        
        self.button.normalColor = [UIColor whiteColor];
        self.button.highlightedColor = self.view.backgroundColor;
        self.button.borderWidth = 2.0f;
        
        [self.view addSubview:self.button];
        
        self.button.center = self.view.center;
        
        [self.button addTarget:self
                        action:@selector(gitHub)
              forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)gitHub
{
    NSURL *url = [NSURL URLWithString:@"https://github.com/gblancogarcia/GBInfiniteScrollView"];
    [[UIApplication sharedApplication] openURL:url];
}

@end
