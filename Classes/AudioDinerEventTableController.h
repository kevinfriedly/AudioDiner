//
//  AudioDinerEventTableController.h
//  AudioDiner
//
//  Created by Kevin Friedly on 1/8/11.
//  Copyright 2011 Silicon Prairie Ventures, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AudioDinerAppDelegate.h"

@interface AudioDinerEventTableController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UITableView *eventTable;
	IBOutlet AudioDinerAppDelegate *myAppDelegate;
}

- (NSUInteger)indexFromIndexPath:(NSIndexPath*)indexPath;

- (IBAction) closeInfoView;

@property (nonatomic,retain) UITableView *eventTable;
@property (nonatomic,retain) AudioDinerAppDelegate *myAppDelegate;

@end
