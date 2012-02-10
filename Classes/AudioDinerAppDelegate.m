//
//  AudioDinerAppDelegate.m
//  AudioDiner
//
//  Created by Kevin Friedly on 1/17/11.
//  Copyright 2011 Silicon Prairie Ventures, Inc. All rights reserved.
//

#import "AudioDinerAppDelegate.h"

#import "ScheduleNavController.h"
#import "PicNavController.h"
#import "AudioDinerEventTableController.h"
#import "EventInfoViewController.h"
#import "PicViewController.h"
#import "AudioViewController.h"

#import "XMLRPCResponse.h"
#import "XMLRPCRequest.h"
#import "XMLRPCConnection.h"

@implementation AudioDinerAppDelegate

@synthesize window;
@synthesize mainDict;
@synthesize songArray;
@synthesize localSongsArray;
@synthesize numberOfMonths;
@synthesize theEvents;
@synthesize myTabBarController;


#pragma mark -
#pragma mark Application lifecycle


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {  	
    // Override point for customization after application launch.
    	
	UINavigationController *scheduleNavController = [[ScheduleNavController alloc] initWithNibName:@"ScheduleNavController" bundle:nil];
	UINavigationController *picNavController = [[PicNavController alloc] initWithNibName:@"PicNavController" bundle:nil];

	
	AudioDinerEventTableController *scheduleController = [[AudioDinerEventTableController alloc]
									initWithNibName:@"AudioDinerEventTableController" bundle:nil];
	[scheduleController setTitle:@"Schedule"];
	
	scheduleController.myAppDelegate = self;
	scheduleController.eventTable.delegate=scheduleController;
	scheduleController.eventTable.dataSource=scheduleController;
	
	[scheduleNavController pushViewController:scheduleController animated:NO];
				
	PicViewController *picViewController = [[PicViewController alloc]
							        initWithNibName:@"PicViewController" bundle:nil];
	picViewController.myAppDelegate=self;
	
	[picNavController pushViewController:picViewController animated:NO];

	AudioViewController *audioViewController = [[AudioViewController alloc] initWithNibName:@"AudioViewController" bundle:nil];
	[audioViewController setTitle:@"Songs"];
	audioViewController.myAppDelegate=self;
		
	UITabBarController *tabBarController = [[UITabBarController alloc] init];
	self.myTabBarController = tabBarController;

	NSArray *viewControllers = [NSArray arrayWithObjects:scheduleNavController, picNavController, audioViewController, nil];
	
	[tabBarController setViewControllers:viewControllers];
	[audioViewController release];
	
	[window setRootViewController:tabBarController];
	
	self.localSongsArray = [[NSMutableArray alloc] initWithObjects:@"Goodbye Again",@"Nuke The Whales",nil];

	[tabBarController release];
	[scheduleNavController release];
	[picNavController release];
	[scheduleController release];
	[picViewController release];
			
    [self.window makeKeyAndVisible];
		
    return YES;
}

- (id)executeXMLRPCRequest:(XMLRPCRequest *)req {
	XMLRPCResponse *userInfoResponse = [XMLRPCConnection sendSynchronousXMLRPCRequest:req];
	
	return userInfoResponse;
}

- (void)resetMainViewController {
	//[self.window setRootViewController:self.mainViewController];
	[window setRootViewController:self.myTabBarController];
}

-(void)getScheduleInBackground {
	id result;

	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	//NSString *server = @"http://localhost:8080";
	NSString *server = @"http://www.audiodiner.com/mobile";
	
	XMLRPCRequest *reqHello = [[XMLRPCRequest alloc] initWithHost:[NSURL URLWithString:server]];
	
	//[reqHello setMethod:@"testXML" withObjects:[NSArray arrayWithObjects:nil]];
	[reqHello setMethod:@"mobile_Schedule" withObjects:[NSArray arrayWithObjects:nil]];
	
	result=[self executeXMLRPCRequest:reqHello];
	
	[reqHello release];
	
	if( ![result isKindOfClass:[NSString class]] ) { //err occured.
		NSString *server = @"http://www.audiodiner.com/mobile";
	}
	
	if(!self.mainDict) {
		self.mainDict=[[[NSMutableDictionary alloc] init] autorelease];
	}
	self.mainDict=[result object];		
	
	[pool release];
}

-(void)getSchedule {
	id result;
			
	//NSString *server = @"http://localhost:8080";
	NSString *server = @"http://www.audiodiner.com/mobile";
	
	XMLRPCRequest *reqHello = [[XMLRPCRequest alloc] initWithHost:[NSURL URLWithString:server]];
	
	//[reqHello setMethod:@"testXML" withObjects:[NSArray arrayWithObjects:nil]];
	[reqHello setMethod:@"mobile_Schedule" withObjects:[NSArray arrayWithObjects:nil]];
	
	result=[self executeXMLRPCRequest:reqHello];
	
	[reqHello release];
	
	//if( [result isEqualToString:@"NSURLErrorDomain"] ) { //err occured.
	//	NSString *eventsText=@"error";
	//}
	
	if(!self.mainDict) {
		self.mainDict=[[[NSMutableDictionary alloc] init] autorelease];
	}
	self.mainDict=[result object];		
}

- (NSInteger)getTheNumberOfMonths {
	NSDictionary *aDict1 = [self.mainDict valueForKey:@"generalInfo"];
	int returnVal = [[aDict1 valueForKey:@"numberOfMonths"] intValue];
 	return returnVal;
}

- (id)getTheEvents {
	return self.theEvents;
}

- (NSInteger)getNumberOfEventsFor:(NSInteger)theIndex {
	return [[[self.mainDict valueForKey:[NSString stringWithFormat:@"%d",theIndex]] valueForKey:@"numberOfEvents"] intValue];
}

- (NSString *)getMonthForIndex:(NSInteger)theIndex {
	return [[self.mainDict valueForKey:[NSString stringWithFormat:@"%d",theIndex]] valueForKey:@"month"];
}

- (NSArray *)getEventFor:(NSInteger)theIndex {
	NSInteger eventCounter=0;
	NSString *eventString=@"";
		
	id generalInfoDict=[self.mainDict valueForKey:@"generalInfo"];
	NSInteger aNumberOfMonths=[[generalInfoDict valueForKey:@"numberOfMonths"] intValue];
	self.numberOfMonths = aNumberOfMonths;
	
	for(int i=0; i<aNumberOfMonths;i++) {
	    NSDictionary *aMonthDict=[self.mainDict valueForKey:[NSString stringWithFormat:@"%d", i]];
		id numberOfEvents=[aMonthDict valueForKey:@"numberOfEvents"];
		for(int j=0; j<[numberOfEvents intValue];j++) {	
			NSDictionary *anEvent=[aMonthDict valueForKey:[NSString stringWithFormat:@"%d",j]];
			if(eventCounter == theIndex) {
				//return [NSString stringWithFormat:@"%@%@%@",[anEvent valueForKey:@"datetime"],@" - ",[anEvent valueForKey:@"description"]];
				NSMutableArray *returnArray=[[[NSMutableArray alloc] init] autorelease];
				[returnArray addObject:[NSString stringWithFormat:@"%@",[anEvent valueForKey:@"datetime"]]];
				[returnArray addObject:[NSString stringWithFormat:@"%@",[anEvent valueForKey:@"title"]]];
				[returnArray addObject:[NSString stringWithFormat:@"%@",[anEvent valueForKey:@"publicPrivate"]]];
				return returnArray;
			}
			eventCounter=eventCounter+1;
			
	        id aDateTime=[anEvent valueForKey:@"datetime"];
		    id aDescription=[anEvent valueForKey:@"description"];
		    if(aDateTime) {
				eventString=[NSString stringWithFormat:@"%@%@%@",aDateTime,@" ",aDescription];
				if(!self.theEvents) {
					self.theEvents=[[NSMutableArray alloc] init];
				}
		        [theEvents addObject:eventString];
		    }
		}
    }
	return 0;
}


- (NSDictionary *)getEventFor:(NSInteger)theIndex theSection:(NSInteger)theSection {
	return [[self.mainDict valueForKey:[NSString stringWithFormat:@"%d",theSection]] valueForKey:[NSString stringWithFormat:@"%d",theIndex]];
}

- (NSArray *)getExtendedEventFor:(NSInteger)theIndex {
	NSInteger eventCounter=0;
	NSString *eventString=@"";
	
	id generalInfoDict=[self.mainDict valueForKey:@"generalInfo"];
	NSInteger aNumberOfMonths=[[generalInfoDict valueForKey:@"numberOfMonths"] intValue];
	self.numberOfMonths = aNumberOfMonths;
	
	for(int i=0; i<aNumberOfMonths;i++) {
	    NSDictionary *aMonthDict=[self.mainDict valueForKey:[NSString stringWithFormat:@"%d", i]];
		id numberOfEvents=[aMonthDict valueForKey:@"numberOfEvents"];
		for(int j=0; j<[numberOfEvents intValue];j++) {	
			NSDictionary *anEvent=[aMonthDict valueForKey:[NSString stringWithFormat:@"%d",j]];
			if(eventCounter == theIndex) {
				NSMutableArray *returnArray=[[[NSMutableArray alloc] init] autorelease];
				[returnArray addObject:[NSString stringWithFormat:@"%@",[anEvent valueForKey:@"datetime"]]];
				[returnArray addObject:[NSString stringWithFormat:@"%@",[anEvent valueForKey:@"title"]]];
				[returnArray addObject:[NSString stringWithFormat:@"%@",[anEvent valueForKey:@"publicPrivate"]]];
				[returnArray addObject:[NSString stringWithFormat:@"%@",[anEvent valueForKey:@"address"]]];
				[returnArray addObject:[NSString stringWithFormat:@"%@",[anEvent valueForKey:@"location"]]];
				return returnArray;
			}
			eventCounter=eventCounter+1;
			
	        id aDateTime=[anEvent valueForKey:@"datetime"];
		    id aDescription=[anEvent valueForKey:@"description"];
		    if(aDateTime) {
				eventString=[NSString stringWithFormat:@"%@%@%@",aDateTime,@" ",aDescription];
				if(!self.theEvents) {
					self.theEvents=[[NSMutableArray alloc] init];
				}
		        [theEvents addObject:eventString];
		    }
		}
    }
	return 0;
}

-(void)getSongs {
	id result;
	
	//NSString *server = @"http://localhost:8080";
	NSString *server = @"http://www.audiodiner.com/mobile";
	
	XMLRPCRequest *reqHello = [[XMLRPCRequest alloc] initWithHost:[NSURL URLWithString:server]];
	
	//[reqHello setMethod:@"testXML" withObjects:[NSArray arrayWithObjects:nil]];
	[reqHello setMethod:@"mobile_SongList" withObjects:[NSArray arrayWithObjects:nil]];
	
	result=[self executeXMLRPCRequest:reqHello];
	
	[reqHello release];
	
	//if( ![result isKindOfClass:[NSString class]] ) //err occured.
	//	eventsText.text=@"error";
	
	if(!self.songArray) {
		self.songArray=[[[NSMutableArray alloc] init] autorelease];
	}
	self.songArray=[result object];		
}

- (NSString *)getSongForIndex:(NSInteger)theIndex {
	NSString *returnString = [NSString stringWithFormat:@"%@",[self.songArray objectAtIndex:theIndex]];
	return returnString;
}

- (NSInteger)getNumberOfSongs {
	return [self.songArray count];
}

- (NSString *)getLocalSongForIndex:(NSInteger)theIndex {
	return [self.localSongsArray objectAtIndex:theIndex];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
	NSLog(@"Entering background");
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */	
}


- (void)applicationWillTerminate:(UIApplication *)application {
	NSLog(@"terminating");
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [window release];

    [super dealloc];
}


@end
