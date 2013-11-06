//
//  BTMeasurement.m
//  BellyTrackr
//
//  Created by Eric So on 10/9/13.
//  Copyright (c) 2013 So, Inc. All rights reserved.
//

#import "BTMeasurement.h"


@implementation BTMeasurement

@dynamic bellyMeasurementInCm;
@dynamic dateCreated;

#pragma mark CoreData Methods
- (void)awakeFromFetch
{
    [super awakeFromFetch];
}

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    NSTimeInterval t = [[NSDate date] timeIntervalSinceReferenceDate];
    [self setDateCreated:t];
}

@end
