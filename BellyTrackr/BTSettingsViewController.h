//
//  BTSettingsViewController.h
//  BellyTrackr
//
//  Created by Eric So on 10/15/13.
//  Copyright (c) 2013 So, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTSettingsViewController : UIViewController
{
    __weak IBOutlet UIDatePicker *reminderDatePicker;
    __weak IBOutlet UIButton *setBtn;
}

- (IBAction)setReminder:(id)sender;

@end
