//
//  GBDetailViewController.m
//  GBInfiniteScrollViewDemo
//
//  Created by Gerardo Blanco García on 12/04/14.
//  Copyright (c) 2014 Gerardo Blanco García. All rights reserved.
//

#import "GBDetailViewController.h"

#import "UIColor+Utils.h"
#import "GBRoundBorderedButton.h"

@interface GBDetailViewController ()

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) GBRoundBorderedButton *gitHubButton;

@end

@implementation GBDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUp];
}

- (void)setUp
{
    self.view.backgroundColor = [UIColor brightRedColor];
    [self setUpBackButton];
    [self setUpGitHubButton];
}

- (void)setUpBackButton
{
    if (!self.backButton) {
        self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 64.0f, 64.0f)];
        
        [self.backButton setImage:[UIImage imageNamed:@"CloseButton"] forState:UIControlStateNormal];
        [self.backButton setImage:[UIImage imageNamed:@"CloseButtonHighlighted"] forState:UIControlStateHighlighted];
        
        [self.backButton addTarget:self
                            action:@selector(back)
                  forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:self.backButton];
        
        [self.backButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        CGFloat constant = 24.0f;
        
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
            constant -= 20.0f;
        }
        
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.backButton
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.view
                                                               attribute:NSLayoutAttributeTop
                                                              multiplier:1.0f
                                                                constant:constant];
        
        [self.view addConstraint:top];
        
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.backButton
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.view
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0f
                                                                  constant:-16.0f];
        
        [self.view addConstraint:right];
    }
}

- (void)back
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)setUpGitHubButton
{
    if (!self.gitHubButton) {
        CGRect frame = CGRectMake(0.0f, 0.0f, 240.0f, 48.0f);
        
        self.gitHubButton = [[GBRoundBorderedButton alloc] initWithFrame:frame ];
        [self.gitHubButton setTitle:@"View on GitHub" forState:UIControlStateNormal];
        
        self.gitHubButton.normalColor = [UIColor whiteColor];
        self.gitHubButton.highlightedColor = [UIColor brightRedColor];
        self.gitHubButton.borderWidth = 2.0f;
        
        [self.view addSubview:self.gitHubButton];
        
        self.gitHubButton.center = self.view.center;
        
        [self.gitHubButton addTarget:self
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
