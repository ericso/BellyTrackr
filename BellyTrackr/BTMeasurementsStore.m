//
//  BTMeasurementsStore.m
//  BellyTrackr
//
//  Created by Eric So on 10/3/13.
//  Copyright (c) 2013 So, Inc. All rights reserved.
//

#import "BTMeasurementsStore.h"
#import "BTMeasurement.h"

@implementation BTMeasurementsStore

+ (BTMeasurementsStore *)sharedStore
{
    static BTMeasurementsStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:nil] init];
    }
    return sharedStore;
} // create singleton sharedStore

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedStore];
} // prevent allocWithZone from creating a new sharedStore

- (id)init
{
    self = [super init];
    if (self) {
        // Read in BellyTrackr.xcdatamodeld
        model = [NSManagedObjectModel mergedModelFromBundles:nil];
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        
        // SQLite database location
        NSString *path = [self measurementArchivePath];
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        
        NSError *error = nil;
        
        // Try to open the SQLite database
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            [NSException raise:@"Open failed" format:@"Reason: %@", [error localizedDescription]];
        }
        
        // Create the managed object context
        context = [[NSManagedObjectContext alloc] init];
        [context setPersistentStoreCoordinator:psc];
        
        // The managed object context can manage undo, but we don't need it
        [context setUndoManager:nil];
        
        [self loadAllMeasurements];
    }
    return self;
}

- (NSArray *)allMeasurements
{
    return allMeasurements;
}

- (BTMeasurement *)createMeasurement
{
    BTMeasurement *measurement = [NSEntityDescription insertNewObjectForEntityForName:@"BTMeasurement" inManagedObjectContext:context];
//    [allMeasurements addObject:measurement];
    [allMeasurements insertObject:measurement atIndex:0]; // To make sure measurement gets added at top of tableview
    
    return measurement;
}

- (void)removeMeasurement:(BTMeasurement *)measurement
{
    // Remove the measurment from the context
    [context deleteObject:measurement];
    // Remove the measurement from the allMeasurements array
    [allMeasurements removeObjectIdenticalTo:measurement];
}

#pragma mark Persistent Storage Methods
- (NSString *)measurementArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // get only one document directory from that list
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    
//    return [documentDirectory stringByAppendingPathComponent:@"measurements.archive"];
    return [documentDirectory stringByAppendingPathComponent:@"store.data "];
}

- (BOOL)saveChanges
{
    // Update all records in store.data with any changes since last time
    NSError *error = nil;
    BOOL successful = [context save:&error];
    if (!successful) {
        NSLog(@"Error saving: %@", [error localizedDescription]);
    }
    return successful;
}

- (void)loadAllMeasurements
{
    if (!allMeasurements) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *e = [[model entitiesByName] objectForKey:@"BTMeasurement"];
        [request setEntity:e];
        
        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"dateCreated" ascending:NO];
        [request setSortDescriptors:[NSArray arrayWithObject:sd]];
        
        NSError *error;
        NSArray *result = [context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"%@", [error localizedDescription]];
        }
        
        allMeasurements = [[NSMutableArray alloc] initWithArray:result];
    }
}

@end
