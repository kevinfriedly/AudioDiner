//
//  AudioViewController.h
//  AudioDiner
//
//  Created by Kevin Friedly on 2/5/11.
//  Copyright 2011 Silicon Prairie Ventures, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AudioDinerAppDelegate.h"

@interface AudioViewController : UIViewController <UIWebViewDelegate> {
	IBOutlet AudioDinerAppDelegate *myAppDelegate;
	UIViewController *mainRootController;
}

- (IBAction)goBack;

@property (nonatomic, retain) UIWebView *playerView;
@property (nonatomic,retain) UIViewController *mainRootController;
@property (nonatomic,retain) AudioDinerAppDelegate *myAppDelegate;

@end
