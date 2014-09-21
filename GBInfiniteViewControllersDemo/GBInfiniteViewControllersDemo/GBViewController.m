//
//  GBViewController.m
//  GBInfiniteViewControllersDemo
//
//  Created by Gerardo Blanco García on 29/05/14.
//  Copyright (c) 2014 gblancogarcia. All rights reserved.
//

#import "GBViewController.h"

#import "GBTableViewController.h"

@interface GBViewController ()

@property (nonatomic, strong) GBInfiniteScrollView *infiniteScrollView;
@property (nonatomic, strong) NSMutableArray *viewControllers;

@end

@implementation GBViewController

- (NSMutableArray *)viewControllers
{
    if (!_viewControllers) {
        _viewControllers = [[NSMutableArray alloc] initWithCapacity:[self numberOfViewControllers]];
        
        for (int index = [self firstIndex]; index < [self numberOfViewControllers]; index++) {
            [_viewControllers insertObject:[NSNull null] atIndex:index];
        }
    }
    
    return _viewControllers;
}

- (NSUInteger)numberOfViewControllers
{
    return 1000;
}

- (NSUInteger)firstIndex
{
    return 0;
}

- (NSUInteger)lastIndex
{
    return fmax([self firstIndex], [self numberOfViewControllers] - 1);
}

- (NSUInteger)nextIndex:(NSUInteger)index
{
    return (index == [self lastIndex]) ? [self firstIndex] : (index + 1);
}

- (NSUInteger)previousIndex:(NSUInteger)index
{
    return (index == [self firstIndex]) ? [self lastIndex] : (index - 1);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUp];
}

- (void)setUp
{
    self.infiniteScrollView = [[GBInfiniteScrollView alloc] initWithFrame:self.view.bounds];
    
    self.infiniteScrollView.autoScrollDirection = GBAutoScrollDirectionRightToLeft;
    self.infiniteScrollView.infiniteScrollViewDataSource = self;
    self.infiniteScrollView.infiniteScrollViewDelegate = self;
    self.infiniteScrollView.interval = 3.0f;
    self.infiniteScrollView.pageIndex = 0;
    self.infiniteScrollView.scrollDirection = GBScrollDirectionHorizontal;
    self.infiniteScrollView.scrollsToTop = NO;
    
    [self.view addSubview:self.infiniteScrollView];
    
    [self.infiniteScrollView reloadData];
}

- (NSInteger)numberOfPagesInInfiniteScrollView:(GBInfiniteScrollView *)infiniteScrollView
{
    return [self numberOfViewControllers];
}

- (GBInfiniteScrollViewPage *)infiniteScrollView:(GBInfiniteScrollView *)infiniteScrollView pageAtIndex:(NSUInteger)index;
{
    GBInfiniteScrollViewPage *page = [infiniteScrollView dequeueReusablePage];
    
    if (page == nil) {
        page = [[GBInfiniteScrollViewPage alloc] initWithFrame:self.view.bounds
                                                         style:GBInfiniteScrollViewPageStyleCustom];
    }
    
    GBTableViewController *controller = nil;
    
    if ([NSNull null] == [self.viewControllers objectAtIndex:index]) {
        controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Table View Controller"];
        [self.viewControllers replaceObjectAtIndex:index withObject:controller];
    } else {
        controller = [self.viewControllers objectAtIndex:index];
    }
    
    controller.index = index;
    
    [controller willMoveToParentViewController:nil];
    [self addChildViewController:controller];
    [page.contentView addSubview:controller.view];
    
    return page;
}


- (void)infiniteScrollViewDidScrollNextPage:(GBInfiniteScrollView *)infiniteScrollView
{
    [self resetViewControllers];
}

- (void)infiniteScrollViewDidScrollPreviousPage:(GBInfiniteScrollView *)infiniteScrollView
{
    [self resetViewControllers];
}

- (void)resetViewControllers
{
    NSUInteger currentIndex = self.infiniteScrollView.currentPageIndex;
    NSUInteger previousIndex = [self previousIndex:currentIndex];
    NSUInteger nextIndex = [self nextIndex:currentIndex];
    
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController *controller, NSUInteger idx, BOOL *stop) {
        if ((idx != currentIndex) && (idx != previousIndex) && (idx != nextIndex)) {
            if ([NSNull null] != [self.viewControllers objectAtIndex:idx]) {
                *stop = YES;
                UIViewController *controller = [self.viewControllers objectAtIndex:idx];
                [controller removeFromParentViewController];
                controller = nil;
                [self.viewControllers replaceObjectAtIndex:idx withObject:[NSNull null]];
            }
        }
    }];
}

@end
