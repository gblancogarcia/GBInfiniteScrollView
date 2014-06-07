//
//  GBSecondViewController.m
//  GBInfiniteViewControllersDemo
//
//  Created by Gerardo Blanco García on 29/05/14.
//  Copyright (c) 2014 gblancogarcia. All rights reserved.
//

#import "GBTableViewController.h"

#import "GBRoundBorderedButton.h"

@interface GBTableViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) UIColor *color;

@end

@implementation GBTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUp];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)setUp
{
    self.color = [self randomColor];
    
    self.view.backgroundColor = self.color;
    self.tableView.backgroundColor = self.color;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    [self.refreshControl addTarget:self
                            action:@selector(refreshTable)
                  forControlEvents:UIControlEventValueChanged];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView addSubview:self.refreshControl];
    
    [self.tableView reloadData];
    
}

- (void)refreshTable
{
    [self.refreshControl endRefreshing];
    
    self.color = [self randomColor];
    
    self.view.backgroundColor = self.color;
    self.tableView.backgroundColor = self.color;
    
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    cell.backgroundColor = self.color;
    
    self.color = [self nextColor:self.color];
    
    if (indexPath.row == 2) {
        cell.textLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long) self.index];
    } else {
        cell.textLabel.text = @"";
    }
    
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
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

@end
