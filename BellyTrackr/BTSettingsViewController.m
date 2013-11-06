//
//  BTSettingsViewController.m
//  BellyTrackr
//
//  Created by Eric So on 10/15/13.
//  Copyright (c) 2013 So, Inc. All rights reserved.
//

#import "BTSettingsViewController.h"

@implementation BTSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Setup tab bar properties
        UITabBarItem *tbi = [self tabBarItem];
        [tbi setTitle:@"Reminder"];
        UIImage *i = [UIImage imageNamed:@"Alarm.png"];
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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setReminder:(id)sender
{
    // Clear any local notifications in they exist
    NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *ln in localNotifications) {
        NSLog(@"The notification being canceled: %@", ln.alertBody);
        [[UIApplication sharedApplication] cancelLocalNotification:ln];
    }
    
    // Get current date from date picker
    NSDate *pickerDate = [reminderDatePicker date];
    
    // Schedule the notification
    UILocalNotification *ln = [[UILocalNotification alloc] init];
    ln.fireDate = pickerDate;
    ln.repeatInterval = NSDayCalendarUnit;
    ln.alertBody = @"Time to measure yourself!";
    ln.alertAction = @"Show";
    ln.timeZone = [NSTimeZone defaultTimeZone];
    ln.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:ln];
    
    // Display alert to inform user notification was set
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"Daily Reminder Set"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    // Request to reload table view data
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
    
    // Dismiss the view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
