//
//  BTMeasurementsStore.h
//  BellyTrackr
//
//  Created by Eric So on 10/3/13.
//  Copyright (c) 2013 So, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BTMeasurement;

@interface BTMeasurementsStore : NSObject
{
    NSMutableArray *allMeasurements;
    NSMutableArray *allAssetTypes;
    NSManagedObjectContext *context;
    NSManagedObjectModel *model;
}

+ (BTMeasurementsStore *)sharedStore;
- (NSArray *)allMeasurements;
- (BTMeasurement *)createMeasurement;
- (void)removeMeasurement:(BTMeasurement *)measurement;

// Functions for saving to persistent storage
- (NSString *)measurementArchivePath;
- (BOOL)saveChanges;

@end
