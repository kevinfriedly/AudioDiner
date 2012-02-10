    //
//  PicViewController.m
//  AudioDiner
//
//  Created by Kevin Friedly on 1/23/11.
//  Copyright 2011 Silicon Prairie Ventures, Inc. All rights reserved.
//

#import "PicViewController.h"
#import "BigPicController.h"
#import "AudioViewController.h"

#import "XMLRPCResponse.h"
#import "XMLRPCRequest.h"
#import "XMLRPCConnection.h"

@implementation PicViewController

@synthesize theImagesArray;
@synthesize theImagesDataArray;
@synthesize imagesLoaded;
@synthesize numberOfPics;
@synthesize picTable;
@synthesize mainRootController;
@synthesize myAppDelegate;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
	  UITabBarItem *tbi = [self tabBarItem];
 
      [tbi setTitle:@"Pictures"];
 
    }
	
	self.theImagesArray = [[NSMutableArray alloc] init];
	self.theImagesDataArray = [[NSMutableArray alloc] init];
	
	[self performSelectorInBackground:@selector(loadImages) withObject:nil];
	
	self.imagesLoaded=0;
    	
    return self;
}

- (void)loadImages {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSString *server = @"http://www.audiodiner.com/mobile";
	XMLRPCRequest *reqHello = [[XMLRPCRequest alloc] initWithHost:[NSURL URLWithString:server]];
	
	[reqHello setMethod:@"mobile_Pics" withObjects:[NSArray arrayWithObjects:nil]];
	
	XMLRPCResponse *result = [XMLRPCConnection sendSynchronousXMLRPCRequest:reqHello];

	[reqHello release];
	
	//int theNumberOfPics = [[[result object] valueForKey:@"numberOfPics"] intValue];	
    int theNumberOfPics = [[[[result object] valueForKey:@"info"] valueForKey:@"numberOfPics"] intValue];
	for(int j=0; j<theNumberOfPics;j++) {	
	    NSURL *theUrl = [NSURL URLWithString: [NSString stringWithFormat:@"%@%d",@"http://www.audiodiner.com/",j]];
	    UIImage *theImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:theUrl]];
	    [self.theImagesArray addObject:theImage];
		
		[self.theImagesDataArray addObject:[[[result object] valueForKey:[NSString stringWithFormat:@"%d",j]] valueForKey:@"title"]];
	}
						
	self.imagesLoaded=1;
	self.numberOfPics = theNumberOfPics;
	
	[pool release];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.numberOfPics;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:(UITableViewCellStyle)UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	}
		
	if(self.imagesLoaded==1) {
	  [cell.imageView setImage:[self.theImagesArray objectAtIndex:indexPath.section]];
	}
	
    cell.textLabel.text = @"";
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return @"";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	// create the parent view that will hold header Label
	UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 80.0)];
	
	// create the button object
	UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.opaque = NO;
	headerLabel.textColor = [UIColor blackColor];
	headerLabel.highlightedTextColor = [UIColor whiteColor];
	headerLabel.font = [UIFont boldSystemFontOfSize:14];
	headerLabel.frame = CGRectMake(10.0, -10.0, 300.0, 40.0);
	
	// If you want to align the header text as centered
	// headerLabel.frame = CGRectMake(150.0, 0.0, 300.0, 44.0);
	
	//headerLabel.text = @"Image of the Month";
	headerLabel.text=[self.theImagesDataArray objectAtIndex:section];
	[customView addSubview:headerLabel];
	
	[headerLabel release];
	[customView autorelease];
	
	return customView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	BigPicController *bigPicController = [[BigPicController alloc] initWithEventDetails:@"BigPicController" bundle:nil eventDetails:[self.theImagesArray objectAtIndex:indexPath.section]];
	//BigPicController *bigPicController = [[BigPicController alloc] init];
	
	//self.mainRootController=[self.myAppDelegate.window rootViewController];
	//[self.myAppDelegate.window setRootViewController:bigPicController];
		
	[self.navigationController pushViewController:bigPicController animated:YES];
	
	[bigPicController release];
	
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

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
