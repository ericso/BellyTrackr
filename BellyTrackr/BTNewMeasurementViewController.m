//
//  BTNewMeasurementViewController.m
//  BellyTrackr
//
//  Created by Eric So on 10/5/13.
//  Copyright (c) 2013 So, Inc. All rights reserved.
//

#import "BTNewMeasurementViewController.h"
#import "BTMeasurementsViewController.h"
#import "BTMeasurement.h"
#import "BTMeasurementsStore.h"

@implementation BTNewMeasurementViewController

@synthesize measurement;
//@synthesize dismissBlock;

// User presses the add button to dismiss the modal view controller
 - (void)addMeasurementFromModal:(id)sender
{
    NSLog(@"In addMeasurementFromModal");
    
    // Check to see if the user entered anything in the text field
    if ([measurementField.text length] > 0) {
        // Dismiss the modal; presenting view controller will handel adding the measurement
        [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    } else {
        // If no entry, alert the user
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                        message:@"You forgot to enter your measurement..."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

// User presses the cancel button
- (void)cancelMeasurement:(id)sender
{
    NSLog(@"Canceling measurement");
    
    // Remove the newly added measurement
    [[BTMeasurementsStore sharedStore] removeMeasurement:[self measurement]];
    
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

// User changes the units
- (IBAction)changeUnits:(id)sender
{
    if (unitsSegmentedControl.selectedSegmentIndex == 0) {
        NSLog(@"cm selected");
        [(BTMeasurementsViewController *)[self presentingViewController] setUintsToUse: 0];
//        [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    } else if (unitsSegmentedControl.selectedSegmentIndex == 1) {
        NSLog(@"inches selected");
        [(BTMeasurementsViewController *)[self presentingViewController] setUintsToUse: 1];
//        [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    }
}

// Before the modal view disappears, we want to save the entered measurement
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Clear the first responder
    [[self view] endEditing:YES];
    
    // "Save" changes to the measurement
    [measurement setBellyMeasurementInCm:[[measurementField text] floatValue]];
}

@end
