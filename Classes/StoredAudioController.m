//
//  StoredAudioController.m
//  AudioDiner
//
//  Created by Kevin Friedly on 2/27/11.
//  Copyright 2011 Silicon Prairie Ventures, Inc. All rights reserved.
//

#import "StoredAudioController.h"

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@implementation StoredAudioController

@synthesize eventDetailsDictionary;
@synthesize songName;
@synthesize mainController;
@synthesize audioPlayer;
@synthesize songTitle;
@synthesize pausePlay;

@class AudioViewController;

- (id)initWithEventDetails:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil eventDetails:(NSString *)theAudioDetails mainController:(AudioViewController *)aMainController {
	self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		self.songName=theAudioDetails;
		self.mainController = aMainController;
		self.eventDetailsDictionary = nil;
	}
	return self;
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	AVAudioPlayer *anAudioPlayer;
	
	[self.songTitle setText:self.songName];
	
	NSString *soundPath = [[NSBundle mainBundle] pathForResource:[self.songName stringByReplacingOccurrencesOfString:@" " withString:@""] ofType:@"mp3"];
	
	NSURL *url = [NSURL fileURLWithPath:soundPath];
	
	NSError *error;
	anAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	[anAudioPlayer setDelegate:self];
	[anAudioPlayer play];
	self.audioPlayer=anAudioPlayer;
}

- (IBAction)pausePlay:(id)sender {
	UIButton *aButton = (UIButton *)sender;
		  
	if([[aButton currentTitle] isEqualToString:@"Pause"]) {
	    [pausePlay setTitle:@"Play" forState:UIControlStateNormal];
	    [self.audioPlayer pause];
	} else {
		[pausePlay setTitle:@"Pause" forState:UIControlStateNormal];
		[self.audioPlayer play];
    }
}

- (void)stopMusic {
	[self.audioPlayer stop];
}

- (void)goBack {
	[(AudioViewController *)self.mainController goBack];
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
