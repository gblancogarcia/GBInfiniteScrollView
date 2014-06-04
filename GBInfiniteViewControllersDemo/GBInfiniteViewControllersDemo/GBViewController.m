//
//  GBViewController.m
//  GBInfiniteViewControllersDemo
//
//  Created by Gerardo Blanco García on 29/05/14.
//  Copyright (c) 2014 gblancogarcia. All rights reserved.
//

#import "GBViewController.h"

@interface GBViewController ()

@property (nonatomic, strong) UIViewController *firstViewController;
@property (nonatomic, strong) UIViewController *secondViewController;
@property (nonatomic, strong) GBInfiniteScrollView *infiniteScrollView;

@end

@implementation GBViewController

- (UIViewController *)firstViewController
{
    if (!_firstViewController) {
        _firstViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"First View Controller"];
    }
    
    return _firstViewController;
}

- (UIViewController *)secondViewController
{
    if (!_secondViewController) {
        _secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Second View Controller"];
    }
    
    return _secondViewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUp];
}

- (void)setUp
{
    self.infiniteScrollView = [[GBInfiniteScrollView alloc] initWithFrame:self.view.bounds];
    self.infiniteScrollView.infiniteScrollViewDataSource = self;
    self.infiniteScrollView.infiniteScrollViewDelegate = self;
    self.infiniteScrollView.interval = 3.0f;
    self.infiniteScrollView.pageIndex = 0;
    self.infiniteScrollView.autoScrollDirection = GBAutoScrollDirectionRightToLeft;
    
    self.infiniteScrollView.scrollsToTop = NO;
    
    self.infiniteScrollView.scrollDirection = GBScrollDirectionHorizontal;
    
    [self.view addSubview:self.infiniteScrollView];
    
    [self.infiniteScrollView reloadData];
}

- (NSInteger)numberOfPagesInInfiniteScrollView:(GBInfiniteScrollView *)infiniteScrollView
{
    return 2;
}

- (GBInfiniteScrollViewPage *)infiniteScrollView:(GBInfiniteScrollView *)infiniteScrollView pageAtIndex:(NSUInteger)index;
{
    GBInfiniteScrollViewPage *page = [infiniteScrollView dequeueReusablePage];
    
    if (page == nil) {
        page = [[GBInfiniteScrollViewPage alloc] initWithFrame:self.view.bounds
                                                         style:GBInfiniteScrollViewPageStyleCustom];
    }
    
    if (index == 0) {
        [self.firstViewController willMoveToParentViewController:nil];
        [self addChildViewController:self.firstViewController];
        [page.contentView addSubview:self.firstViewController.view];
    } else {
        [self.secondViewController willMoveToParentViewController:nil];
        [self addChildViewController:self.secondViewController];
        [page.contentView addSubview:self.secondViewController.view];
    }
    
    return page;
}

@end
