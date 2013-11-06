//
//  BTNewMeasurementViewController.h
//  BellyTrackr
//
//  Created by Eric So on 10/5/13.
//  Copyright (c) 2013 So, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BTMeasurement;

@interface BTNewMeasurementViewController : UIViewController
{
    __weak IBOutlet UIButton *cancelButton;
    __weak IBOutlet UIButton *addButton;
    __weak IBOutlet UITextField *measurementField;
}

@property (nonatomic, strong) BTMeasurement *measurement;
//@property (nonatomic, copy) void (^dismissBlock)(void);

- (IBAction)addMeasurementFromModal:(id)sender;
- (IBAction)cancelMeasurement:(id)sender;

@end
