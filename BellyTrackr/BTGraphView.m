//
//  BTGraphView.m
//  BellyTrackr
//
//  Created by Eric So on 10/18/13.
//  Copyright (c) 2013 So, Inc. All rights reserved.
//

#import "BTGraphView.h"
#import "BTMeasurement.h"

@implementation BTGraphView

@synthesize measurementsData;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code...
        NSLog(@"In BTGraphView's initWithFrame:");
    }
    return self;
}

- (void)drawGridLinesWithContext:(CGContextRef)ctx
{
    // Setup drawing grid lines
    CGContextSetLineWidth(ctx, 0.6);
    CGContextSetStrokeColorWithColor(ctx, [[UIColor lightGrayColor] CGColor]);
    
    // kDivisionInCmY gives the separation in horizontal lines in cm
    int numHorizontalLines = graphHeight / (kDivisionInCmY * pixelsPerCmMapping);
    
    for (int i = 0; i < numHorizontalLines; i++) {
        CGContextMoveToPoint(ctx, kOffsetX, kGraphBottom - kOffsetY - i * (kDivisionInCmY * pixelsPerCmMapping));
        CGContextAddLineToPoint(ctx, graphWidth, kGraphBottom - kOffsetY - i * (kDivisionInCmY * pixelsPerCmMapping));
    }
    
    // Commit the drawing
    CGContextStrokePath(ctx);
}

- (void)drawLablesWithContext:(CGContextRef)ctx
{
    // kDivisionInCmY gives the separation in horizontal lines in cm
    int numLabelsY = graphHeight / (kDivisionInCmY * pixelsPerCmMapping);
    
    // Draw the labels
//    CGContextSetTextMatrix(ctx, CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0));
//    CGContextSelectFont(ctx, "Helvetica", 18, kCGEncodingMacRoman);
//    CGContextSetTextDrawingMode(ctx, kCGTextFill);
//    CGContextSetFillColorWithColor(ctx, [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5] CGColor]);
//    for (int i = 0; i < numLabelsY; i++) {
//        NSString *label = [NSString stringWithFormat:@"- %d cm", i * 25];
//        CGContextShowTextAtPoint(ctx, 0, graphHeight - (kOffsetY + i * (kDivisionInCmY * pixelsPerCmMapping)), [label cStringUsingEncoding:NSUTF8StringEncoding], [label length]);
//    }
    
    // Setup CoreText
    int kFontSize = 14;
    CFMutableAttributedStringRef attrStr = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
    CTFontRef font = CTFontCreateWithName(CFSTR("Helvetica"), kFontSize, NULL);
    CFAttributedStringSetAttribute(attrStr, CFRangeMake(0, CFAttributedStringGetLength(attrStr)), kCTFontAttributeName, font);
    
    CGContextSetTextDrawingMode(ctx, kCGTextFill); // This is the default
    [[UIColor blackColor] setFill]; // This is the default
    
    // Draw the labels
    for (int i = 0; i < numLabelsY; i++) {
        NSString *label = [NSString stringWithFormat:@"- %d cm", i * 25];
        [label drawAtPoint:CGPointMake(0, graphHeight - (kOffsetY + i * (kDivisionInCmY * pixelsPerCmMapping))) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:kFontSize]}];
    }
    
    // Draw the X-axis labels
    int numLabelsX = numMeasurements;
    for (int i = 0; i < numLabelsX; i++) {
        // Convert time interval to NSDate
        NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:((BTMeasurement *)measurementsData[i]).dateCreated];
        
        // Create a date formatter
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd"];
        
        // Set the date string
        NSString *label = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]];
//        CGContextShowTextAtPoint(ctx, kOffsetX + i * kStepX, kGraphBottom, [label cStringUsingEncoding:NSUTF8StringEncoding], [label length]);
        [label drawAtPoint:CGPointMake(kOffsetX + i * kStepX, kGraphBottom - 50) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:kFontSize]}];
    }
    
}

- (void)drawLineGraphWithContext:(CGContextRef)ctx
{
    CGContextSetLineWidth(ctx, 2.0);
    CGContextSetStrokeColorWithColor(ctx, [[UIColor colorWithRed:1.0 green:0.5 blue:0 alpha:1.0] CGColor]);
    
//    CGContextSetFillColorWithColor(ctx, [[UIColor colorWithRed:1.0 green:0.5 blue:0 alpha:0.5] CGColor]);
    
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, kOffsetX, graphHeight - kOffsetY - pixelsPerCmMapping * ((BTMeasurement *)measurementsData[0]).bellyMeasurementInCm);
    
    for (int i = 0; i < numMeasurements; i++) {
        // Get the coordinates of the point
        float x = kOffsetX + i * kStepX;
        float y = graphHeight - kOffsetY - pixelsPerCmMapping * ((BTMeasurement *)measurementsData[i]).bellyMeasurementInCm;
        
        CGContextAddLineToPoint(ctx, x, y);
        NSLog(@"Measurement %d: %f", i, ((BTMeasurement *)measurementsData[i]).bellyMeasurementInCm);
    }
    
//    CGContextAddLineToPoint(ctx, kOffsetX + (numPoints -1) * kStepX, kGraphHeight);
//    CGContextClosePath(ctx);
    
    CGContextDrawPath(ctx, kCGPathStroke);
//    CGContextDrawPath(ctx, kCGPathFill);
    
    // Add a circle to each point
    CGContextSetFillColorWithColor(ctx, [[UIColor colorWithRed:1.0 green:0.5 blue:0 alpha:1] CGColor]);
    for (int i = 0; i < numMeasurements; i++) {
        // Get the coordinates of the point
        float x = kOffsetX + i * kStepX;
        float y = graphHeight - kOffsetY - pixelsPerCmMapping * ((BTMeasurement *)measurementsData[i]).bellyMeasurementInCm;
        
        // Draw the point
        CGRect rect = CGRectMake(x - kCircleRadius, y - kCircleRadius, 2 * kCircleRadius, 2 * kCircleRadius);
        CGContextAddEllipseInRect(ctx, rect);
    }
    CGContextDrawPath(ctx, kCGPathFillStroke);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Get a drawing context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (!measurementsData || [measurementsData count] == 0) {
        NSLog(@"measurementsData array is nil or empty");
    } else {
        // Determine the pixels per cm mapping
        // Find the value of the largest measurement
        float highestMeasurement = 0;
        for (BTMeasurement *measurement in measurementsData) {
            if (highestMeasurement < measurement.bellyMeasurementInCm) {
                highestMeasurement = measurement.bellyMeasurementInCm;
            }
        }
        
        graphHeight = [self frame].size.height;
        NSLog(@"graphHeight: %f", graphHeight);
        
    //    pixelsPerCmMapping = kDefaultGraphHeight / highestMeasurement;
        pixelsPerCmMapping = (graphHeight - kOffsetY) / (highestMeasurement * 1.5);
        NSLog(@"Pixel per cm mapping: %f", pixelsPerCmMapping);
        
        // Find the number of measurements
        numMeasurements = (int)[measurementsData count];
        
        // Determine the width of the graph
        graphWidth = numMeasurements * kStepX;
        NSLog(@"graphWidth: %f", graphWidth);
        
    //    // Draw the grid lines
    //    [self drawGridLinesWithContext:context];
        
        // Draw the graph labels
        [self drawLablesWithContext:context];
        
        // Draw a line graph
        [self drawLineGraphWithContext:context];
    }
    
}

@end
