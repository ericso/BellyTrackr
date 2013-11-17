//
//  BTGraphsViewController.m
//  BellyTrackr
//
//  Created by Eric So on 10/17/13.
//  Copyright (c) 2013 So, Inc. All rights reserved.
//

#import "BTGraphsViewController.h"
#import "BTMeasurementsStore.h"
#import "BTMeasurement.h"
#import "BTGraphView.h"

@implementation BTGraphsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Setup tab bar properties
        UITabBarItem *tbi = [self tabBarItem];
        [tbi setTitle:@"Progress"];
        UIImage *i = [UIImage imageNamed:@"ChartUp.png"];
        [tbi setImage:i];
        
        // Setup navigation bar properties
        UINavigationItem *ni = [self navigationItem];
        [ni setTitle:@"belly trackr"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"View will appear...");
    
    // Get data from the measurement store, reverse it, and pass that to the BTGraphView
    NSArray *data = [[BTMeasurementsStore sharedStore] allMeasurements];
    NSMutableArray *reversedData = [NSMutableArray arrayWithCapacity:[data count]];
    NSEnumerator *reverseEnumerator = [data reverseObjectEnumerator];
    for (id element in reverseEnumerator) {
        [reversedData addObject:element];
    }
    [(BTGraphView *)[progressScrollView subviews][0] setMeasurementsData:reversedData];
    
    CGRect frameRect = [(BTGraphView *)[progressScrollView subviews][0] frame];
    frameRect.size.width = kOffsetX + [reversedData count] * kStepX;
    [(BTGraphView *)[progressScrollView subviews][0] setFrame:frameRect];
    
    // Set the size of the scroll view's content so that it can scroll
    CGSize scrollSize = CGSizeMake(kOffsetX + [reversedData count] * kStepX, kDefaultGraphHeight);
    [progressScrollView setContentSize:scrollSize];
    
    // Get the date range and update the label
    NSDate *firstDate = [NSDate dateWithTimeIntervalSinceReferenceDate:((BTMeasurement *)reversedData[0]).dateCreated];
    NSDate *lastDate = [NSDate dateWithTimeIntervalSinceReferenceDate:((BTMeasurement *)reversedData[[reversedData count]-1]).dateCreated];
    
    // Create a date formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"MM-dd"];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:usLocale];
    
    // Set the date string
//    [dateRangeLabel setText:[NSString stringWithFormat:@"%@ - %@",[dateFormatter stringFromDate:firstDate], [dateFormatter stringFromDate:lastDate]]];
    [dateRangeLabel setText:[NSString stringWithFormat:@"%@ - %@",[dateFormatter stringFromDate:firstDate], [dateFormatter stringFromDate:lastDate]]];
    
    // Redraw the view
    [(BTGraphView *)[progressScrollView subviews][0] setNeedsDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIScrollView Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"Scrolling...");
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"Will begin dragging...");
}

@end
