    //
//  AudioDinerEventTableController.m
//  AudioDiner
//
//  Created by Kevin Friedly on 1/8/11.
//  Copyright 2011 Silicon Prairie Ventures, Inc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h> 

#import "AudioDinerEventTableController.h"
#import "EventInfoViewController.h"

#import "AudioDinerAppDelegate.h"


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

@implementation AudioDinerEventTableController

@synthesize myAppDelegate;
@synthesize eventTable;


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
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
			
}


-(void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];

	[self.myAppDelegate getSchedule];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [self.myAppDelegate getTheNumberOfMonths];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.myAppDelegate getNumberOfEventsFor:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	NSMutableString *publicPrivate = [[self.myAppDelegate getEventFor:(NSInteger)[self indexFromIndexPath:indexPath]] objectAtIndex:2];
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:(UITableViewCellStyle)UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	}
	
	[cell.textLabel setFont:[UIFont boldSystemFontOfSize:12]];
	
	cell.textLabel.text=[[self.myAppDelegate getEventFor:[self indexFromIndexPath:indexPath]] objectAtIndex:0];
	cell.imageView.image=[[UIImage imageNamed:@"Note2.jpg"] imageScaledToSize:CGSizeMake(38, 38)];
	cell.imageView.layer.masksToBounds = YES;
	cell.imageView.layer.cornerRadius = 5.0;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	cell.indentationLevel = 1;   // not sure what these do
	cell.indentationWidth = 0;   // not sure what these do
	
	if([publicPrivate isEqualToString:@"Private"]) {
	//if([publicPrivate length]>1) {
	    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@%@",@"   Private event - ",[[self.myAppDelegate getEventFor:[self indexFromIndexPath:indexPath]] objectAtIndex:1]];
    } else {
		cell.detailTextLabel.textColor=[UIColor colorWithRed:0.7 green:0 blue:0 alpha:1];
		cell.detailTextLabel.text=[NSString stringWithFormat:@"%@%@",@"   ",[[self.myAppDelegate getEventFor:[self indexFromIndexPath:indexPath]] objectAtIndex:1]];
	}
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [self.myAppDelegate getMonthForIndex:section];
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
	
	headerLabel.text = [self.myAppDelegate getMonthForIndex:section];
	[customView addSubview:headerLabel];
	
	[headerLabel release];
	[customView autorelease];
	
	return customView;
}

- (NSUInteger)indexFromIndexPath:(NSIndexPath*)indexPath
{
    NSUInteger index=0;
    for( int i=0; i<indexPath.section; i++ )
        index += [self.eventTable numberOfRowsInSection:i];
	
    index += indexPath.row;
	
    return index;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	EventInfoViewController *eventInfoViewController = [[EventInfoViewController alloc] initWithEventDetails:@"EventInfoViewController" bundle:nil eventDetails:[self.myAppDelegate getEventFor:indexPath.row theSection:indexPath.section]];

	[self.navigationController pushViewController:eventInfoViewController animated:YES];
	
    [eventInfoViewController release];
}

- (IBAction)closeInfoView {
	[self.myAppDelegate resetMainViewController];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)dealloc {
    [super dealloc];
}


@end
