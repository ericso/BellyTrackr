//
//  BTMeasurementsViewController.m
//  BellyTrackr
//
//  Created by Eric So on 10/3/13.
//  Copyright (c) 2013 So, Inc. All rights reserved.
//

#import "BTMeasurementsViewController.h"
#import "BTMeasurementsStore.h"
#import "BTMeasurement.h"
#import "BTNewMeasurementViewController.h"
#import "BTMeasurementCell.h"

@implementation BTMeasurementsViewController

- (id)init
{
//    self = [super initWithStyle:UITableViewStyleGrouped];
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // Setup tab bar properties
        UITabBarItem *tbi = [self tabBarItem];
        [tbi setTitle:@"Measurements"];
        UIImage *i = [UIImage imageNamed:@"Ruler.png"];
        [tbi setImage:i];
    }
    return self;
}

// Ensure all instances of BTMeasurementsViewController return with the UITableViewStylePlain style
- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self tableView] reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Setup navigation bar properties
    UINavigationItem *ni = [self navigationItem];
    [ni setTitle:@"belly trackr"];
    
    UIBarButtonItem *addMeasurementButton = [[UIBarButtonItem alloc] initWithTitle:@"+" style:UIBarButtonItemStylePlain target:self action:@selector(addNewMeasurement:)];
    self.navigationItem.rightBarButtonItem = addMeasurementButton;
    
    
    // Load the NIB file
    UINib *nib = [UINib nibWithNibName:@"BTMeasurementCell" bundle:nil];
    
    // Register this NIB which contains the cell
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"BTMeasurementCell"];
    
    // Add a notification observer
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTable)
                                                 name:@"reloadData"
                                               object:nil];
}

# pragma mark Table methods
// Enable editing mode
- (IBAction)toggleEditingMode:(id)sender
{
    if ([self isEditing]) {
        // Turn off editing
        [sender setTitle:@"-" forState:UIControlStateNormal];
        [self setEditing:NO animated:YES];
    } else {
        // Turn on editing
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        [self setEditing:YES animated:YES];
    }
}

- (IBAction)addNewMeasurement:(id)sender
{
    // Create a new measurement and add it to the store
    BTMeasurement *newMeasurement = [[BTMeasurementsStore sharedStore] createMeasurement];
    
    // Present the new measurement modal view controller
    BTNewMeasurementViewController *nmvc = [[BTNewMeasurementViewController alloc] init];
    [nmvc setMeasurement:newMeasurement];
    
    // Completion block for successfully adding a measurement
    void (^measurementCompletion)(void) = ^void(void) {
        // Figure out where that measurement is in the array
        int lastRow = [[[BTMeasurementsStore sharedStore] allMeasurements] indexOfObject:newMeasurement];
        
        NSLog(@"Last row: %d", lastRow);
        
        // Make a new index path for the 0th section, first row
        NSIndexPath *ip = [NSIndexPath indexPathForRow:lastRow inSection:0];
        
        NSLog(@"%@", ip);
        
        // Insert this new row into the table
        [[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:ip] withRowAnimation:UITableViewRowAnimationTop];
    };
    [self presentViewController:nmvc animated:YES completion:measurementCompletion];
}

- (void)reloadTable
{
    [[self tableView] reloadData];
}

# pragma mark UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[BTMeasurementsStore sharedStore] allMeasurements] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    BTMeasurement *measurement = [[[BTMeasurementsStore sharedStore] allMeasurements] objectAtIndex:row];
    
    // Get the new or recycled cell
    BTMeasurementCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BTMeasurementCell"];
    
    // Configure the cell with the BTMeasurement
    [[cell bellyMeasurementInCmLabel] setText:[NSString stringWithFormat:@"%03.1f cm", [measurement bellyMeasurementInCm]]];
    
    // Convert time interval to NSDate
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:[measurement dateCreated]];
    
    // Create a date formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    // Set the date in the cell
    NSString *formattedDateString = [dateFormatter stringFromDate:date];
    [[cell dateCreatedLabel] setText:[NSString stringWithFormat:@"%@", formattedDateString]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If the table view is asking to commit a delete command...
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Remove the measurement from the store
        BTMeasurementsStore *store = [BTMeasurementsStore sharedStore];
        NSArray *measurements = [store allMeasurements];
        BTMeasurement *measurement = [measurements objectAtIndex:[indexPath row]];
        [store removeMeasurement:measurement];
        
        // Remove the cell from the table view
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

# pragma mark UITableViewDelegate Methods
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    return [self headerView];
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    return [[self headerView] bounds].size.height;
    return 0.0;
}

@end
