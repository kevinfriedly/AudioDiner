//
//  BigPicController.m
//  AudioDiner
//
//  Created by Kevin Friedly on 3/5/11.
//  Copyright 2011 Silicon Prairie Ventures, Inc. All rights reserved.
//

#import "BigPicController.h"


@implementation BigPicController

@synthesize theImageView;
@synthesize theImage;

- (id)initWithEventDetails:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil eventDetails:(UIImage *)theEventDetails {
	self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
	    self.theImage=theEventDetails;
	}
	return self;
}


/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	[self.theImageView setImage:self.theImage];
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
