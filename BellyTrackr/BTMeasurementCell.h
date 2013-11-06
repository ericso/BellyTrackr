//
//  BTMeasurementCell.h
//  BellyTrackr
//
//  Created by Eric So on 10/8/13.
//  Copyright (c) 2013 So, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTMeasurementCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *bellyMeasurementInCmLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateCreatedLabel;

@end
