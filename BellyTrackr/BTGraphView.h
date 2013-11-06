//
//  BTGraphView.h
//  BellyTrackr
//
//  Created by Eric So on 10/18/13.
//  Copyright (c) 2013 So, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface BTGraphView : UIView
{
    float pixelsPerCmMapping;
    int numMeasurements;
    float graphWidth;
    float graphHeight;
}

@property (nonatomic, retain) NSArray *measurementsData;

@end
