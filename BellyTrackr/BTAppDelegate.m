//
//  BTAppDelegate.m
//  BellyTrackr
//
//  Created by Eric So on 10/3/13.
//  Copyright (c) 2013 So, Inc. All rights reserved.
//

#import "BTAppDelegate.h"
#import "BTMeasurementsViewController.h"
#import "BTGraphsViewController.h"
#import "BTSettingsViewController.h"
#import "BTMeasurementsStore.h"

@implementation BTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    
    // Handle launching from a notification
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (locationNotification) {
        // Set icon badge number to zero
        application.applicationIconBadgeNumber = 0;
    }
    
    // Setting up view controllers
    BTMeasurementsViewController *mvc = [[BTMeasurementsViewController alloc] init];
    BTGraphsViewController *gvc = [[BTGraphsViewController alloc] init];
    BTSettingsViewController *svc = [[BTSettingsViewController alloc] init];
    
    // Setup properties of the nav bars
//    UIColor *navBarBackgroundColor = [UIColor colorWithRed:0 green:0.5 blue:0.5 alpha:1];
//    UIColor *navBarBackgroundColor = [UIColor blackColor];
    UIColor *navBarBackgroundColor = [UIColor colorWithRed:28/255.0f green:199/255.0f blue:100/255.0f alpha:0.7f];
    UIColor *navBarTextColor = [UIColor blueColor];
    
    // Set the text color of the navigation bars to be white
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: navBarTextColor}];
    
    // Setup a navigation controller for the measurements view
    UINavigationController *measurementsNavController = [[UINavigationController alloc] initWithRootViewController:mvc];
//    measurementsNavController.navigationBar.tintColor = navBarBackgroundColor;
    measurementsNavController.navigationBar.backgroundColor = navBarBackgroundColor;
    
    // Setup a navigation controller for the graphs view
    UINavigationController *graphsNavController = [[UINavigationController alloc] initWithRootViewController:gvc];
    //    graphsNavController.navigationBar.tintColor = navBarBackgroundColor;
    graphsNavController.navigationBar.backgroundColor = navBarBackgroundColor;
    
    // Setup a navigation controller for the settings view
    UINavigationController *settingsNavController = [[UINavigationController alloc] initWithRootViewController:svc];
    //    settingsNavController.navigationBar.tintColor = navBarBackgroundColor;
    settingsNavController.navigationBar.backgroundColor = navBarBackgroundColor;
    
    // TabBarController
    UITabBarController *tbc = [[UITabBarController alloc] init];
    NSArray *viewControllers = [NSArray arrayWithObjects:measurementsNavController, graphsNavController, settingsNavController, nil];
    [tbc setViewControllers:viewControllers];
    
    [[self window] setRootViewController:tbc];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // Save allMeasurements array to persistent storage
    BOOL success = [[BTMeasurementsStore sharedStore] saveChanges];
    if (success) {
        NSLog(@"Saved the measurements");
    } else {
        NSLog(@"Could not save the measurements");
    }
    NSLog(@"DEBUG: in applicationDidEnterBackground");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    BOOL success = [[BTMeasurementsStore sharedStore] saveChanges];
    if (success) {
        NSLog(@"Saved the measurements");
    } else {
        NSLog(@"Could not save the measurements");
    }
    NSLog(@"DEBUG: in applicationWillTerminate");
}


/// Handle local notifications ///
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reminder"
                                                        message:notification.alertBody
                                                       delegate:self
                                              cancelButtonTitle:@"Not Today"
                                              otherButtonTitles:@"Snooze", @"OK", nil];
        [alert show];
    }
    
    // Request to reload table view data
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
    
    // Set icon badge number to zero
    application.applicationIconBadgeNumber = 0;
}

- (void)setSnoozeNotification
{
    NSDate *notificationDate;
    
    // Grab the notification date of the last notification (there should be only one, unless user snoozed)
    NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *ln in localNotifications) {
        NSLog(@"The notification being snoozed: %@", ln.alertBody);
        notificationDate = [ln fireDate];
    }
    
    NSTimeInterval snoozeInterval = 600; // 10 minutes, interval is in seconds
    
    // Schedule the notification
    UILocalNotification *ln = [[UILocalNotification alloc] init];
    ln.fireDate = [notificationDate dateByAddingTimeInterval:snoozeInterval];
    ln.repeatInterval = 0;
    ln.alertBody = @"Time to measure yourself!";
    ln.alertAction = @"Show";
    ln.timeZone = [NSTimeZone defaultTimeZone];
    ln.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:ln];
}

#pragma mark UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"Not Today"]) {
        NSLog(@"User canceled today's measurement");
    } else if ([title isEqualToString:@"Snooze"]) {
        NSLog(@"User snoozed");
        // Set new notification for a little later
        [self setSnoozeNotification];
    } else if ([title isEqualToString:@"OK"]) {
        NSLog(@"User selected OK, opening new measurement modal...");
        
        // Change to the Timeline tab
        UITabBarController *tbc = (UITabBarController *)[[self window] rootViewController];
        [tbc setSelectedIndex:0];
        
        // TODO fix this by not forcing a change in the tab view, adding the measurement here, in the app delegate
        
        // Grab the instance of BTMeasurementViewController from the UITabViewController and call addNewMeasurement:
        UINavigationController *nav = (UINavigationController *)[[tbc viewControllers] objectAtIndex:0];
        BTMeasurementsViewController *mvc = (BTMeasurementsViewController *)nav.viewControllers[0];
//        NSLog(@"%@", [mvc description]);
        [mvc addNewMeasurement:self];
    }
}

@end
