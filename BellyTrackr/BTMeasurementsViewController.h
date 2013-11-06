//
//  BTMeasurementsViewController.h
//  BellyTrackr
//
//  Created by Eric So on 10/3/13.
//  Copyright (c) 2013 So, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTMeasurementsViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UIView *headerView;
}

//- (UIView *)headerView;

- (IBAction)addNewMeasurement:(id)sender;
- (IBAction)toggleEditingMode:(id)sender;
- (void)reloadTable;

@end
