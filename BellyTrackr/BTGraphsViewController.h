//
//  BTGraphsViewController.h
//  BellyTrackr
//
//  Created by Eric So on 10/17/13.
//  Copyright (c) 2013 So, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTGraphsViewController : UIViewController <UIScrollViewDelegate>
{
    __weak IBOutlet UIScrollView *progressScrollView;
    __weak IBOutlet UILabel *dateRangeLabel;
}

@end
