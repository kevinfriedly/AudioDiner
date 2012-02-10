//
//  AudioViewController.m
//  AudioDiner
//
//  Created by Kevin Friedly on 2/5/11.
//  Copyright 2011 Silicon Prairie Ventures, Inc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h> 

#import "AudioViewController.h"

#import "StoredAudioController.h"

@interface UIImage (TPAdditions)
- (UIImage*)imageScaledToSize:(CGSize)size;
@end

@implementation UIImage (TPAdditions)
- (UIImage*)imageScaledToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end

@implementation AudioViewController

@synthesize playerView;
@synthesize myAppDelegate;
@synthesize mainRootController;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
     UITabBarItem *tbi = [self tabBarItem];
 
     [tbi setTitle:@"Music"];
	  
 }
 return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.myAppDelegate getNumberOfSongs];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:(UITableViewCellStyle)UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	}
	
	[cell.textLabel setFont:[UIFont boldSystemFontOfSize:12]];
	
	if(indexPath.section == 1) {
	    cell.textLabel.text=[self.myAppDelegate getSongForIndex:indexPath.row];
	} else {
		cell.textLabel.text=[self.myAppDelegate getLocalSongForIndex:indexPath.row];
	}
	cell.imageView.image=[[UIImage imageNamed:@"Note2.jpg"] imageScaledToSize:CGSizeMake(38, 38)];
	cell.imageView.layer.masksToBounds = YES;
	cell.imageView.layer.cornerRadius = 5.0;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	cell.indentationLevel = 1;   // not sure what these do
	cell.indentationWidth = 0;   // not sure what these do
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return @"This is it";
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
		
	if(section==0) {
	    headerLabel.text = @"Local songs";
	} else {
		headerLabel.text = @"Songs from the website";
	}
	[customView addSubview:headerLabel];
	
	return customView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	if(indexPath.section == 0) {
		StoredAudioController *storedAudioController = [[StoredAudioController alloc] initWithEventDetails:@"StoredAudioController" bundle:nil eventDetails:[self.myAppDelegate getLocalSongForIndex:indexPath.row] mainController:self];

		self.mainRootController=[self.myAppDelegate.window rootViewController];
		[self.myAppDelegate.window setRootViewController:storedAudioController];
		
		[storedAudioController release];
		
    } else {
		
		NSString *myMP3URL=[NSString stringWithFormat:@"%@%@%@",@"http://www.audiodiner.com/mobile/",[self.myAppDelegate getSongForIndex:indexPath.row],@".mp3"];

		UIWebView *webView = [[UIWebView alloc] initWithFrame: CGRectMake(0.0, 0.0, 1.0, 1.0)];  
		webView.delegate = self;  
		self.playerView = webView;  
		[webView release]; 
	
		NSURLRequest *request = [[NSURLRequest alloc] initWithURL: [NSURL URLWithString: myMP3URL] cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 1000];  
		[self.playerView loadRequest: request];  
		[request release];
	}
}

-(void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	
	[self.myAppDelegate getSongs];
}

- (void)goBack {
	[[self.myAppDelegate.window rootViewController] stopMusic];
	[self.myAppDelegate.window setRootViewController:self.mainRootController];
}

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
