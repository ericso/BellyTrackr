//
//  BTMeasurement.h
//  BellyTrackr
//
//  Created by Eric So on 10/9/13.
//  Copyright (c) 2013 So, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BTMeasurement : NSManagedObject

@property (nonatomic) float bellyMeasurementInCm;
@property (nonatomic) NSTimeInterval dateCreated;

@end
