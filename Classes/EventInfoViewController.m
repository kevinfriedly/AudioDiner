//
//  EventInfoViewController.m
//  AudioDiner
//
//  Created by Kevin Friedly on 2/4/11.
//  Copyright 2011 Silicon Prairie Ventures, Inc. All rights reserved.
//

#import "EventInfoViewController.h"
#import "AddressAnnotation.h"

@implementation EventInfoViewController

@synthesize eventDetails;
@synthesize eventDetailsDictionary;
@synthesize mapView;

- (id)initWithEventDetails:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil eventDetails:(NSDictionary *)theEventDetails {
	self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		self.eventDetailsDictionary = theEventDetails;
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
    [super viewDidLoad];

	id *theAddress=[self.eventDetailsDictionary objectForKey:@"address"];
	
	//NSString *urlAddress = [NSString stringWithFormat:@"%@%@",[self.eventDetailsDictionary objectForKey:@"location"],@"&output=embed"];
	//NSURL *url = [NSURL URLWithString:urlAddress];
	//NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	//[self.webMap loadRequest:requestObj];
	
	CLLocationCoordinate2D location;
	
	if(theAddress) {
		NSString *myString=[NSString stringWithFormat:@"%@\n%@\n%@",[self.eventDetailsDictionary objectForKey:@"title"],theAddress,[self.eventDetailsDictionary objectForKey:@"datetime"]];
		[self.eventDetails setText:myString];

	    location = [self getLocationFromAddress:[NSString stringWithFormat:@"%@",theAddress]];

		MKCoordinateRegion region;
		region.center=location;
		MKCoordinateSpan span;
		span.latitudeDelta=0.030f; // this should be adjusted for high vs. low latitude - calc by cosign or sign
		span.longitudeDelta=0.030f;
		region.span=span;
		
		[self.mapView setRegion:region animated:TRUE];	
		
		[self.mapView setCenterCoordinate:location animated:TRUE];
		
		AddressAnnotation *addAnnotation = [[AddressAnnotation alloc] initWithCoordinate:location];
		[self.mapView addAnnotation:addAnnotation];
		[addAnnotation release];
	} else {
		NSString *myString=[NSString stringWithFormat:@"%@\n%@",[self.eventDetailsDictionary objectForKey:@"title"],[self.eventDetailsDictionary objectForKey:@"datetime"]];
		[self.eventDetails setText:myString];
	}
}

-(CLLocationCoordinate2D) getLocationFromAddress:(NSString*) address {
	CLLocationCoordinate2D location;
	location.latitude = 0;
	location.longitude = 0;
	if(address > 0) {
		NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv", 
							   [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString]];
		NSArray *listItems = [locationString componentsSeparatedByString:@","];
		
		double latitude = 0.0;
		double longitude = 0.0;
		
		if([listItems count] >= 4 && [[listItems objectAtIndex:0] isEqualToString:@"200"]) {
			latitude = [[listItems objectAtIndex:2] doubleValue];
			longitude = [[listItems objectAtIndex:3] doubleValue];
		}
		location.latitude = latitude;
		location.longitude = longitude;

	} else {
			//Show error
			NSLog(@"error:address not found");
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"Address not found"
														   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];	
			[alert release];
	}
	return location;
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
