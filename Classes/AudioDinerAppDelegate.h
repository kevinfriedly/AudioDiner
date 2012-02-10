//
//  AudioDinerAppDelegate.h
//  AudioDiner
//
//  Created by Kevin Friedly on 1/17/11.
//  Copyright 2011 Silicon Prairie Ventures, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AudioDinerEventTableController;
@class PicViewController;

#import "XMLRPCResponse.h"
#import "XMLRPCRequest.h"
#import	"XMLRPCConnection.h"

@interface AudioDinerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    NSMutableArray *theEvents;
	NSMutableDictionary *mainDict;
	NSMutableArray *songArray;
	NSMutableArray *localSongsArray;
	NSUInteger numberOfMonths;
	UITabBarController *myTabBarController;
}

- (void)getScheduleInBackground;
- (void)getSchedule;
- (id)executeXMLRPCRequest:(XMLRPCRequest *)req;
- (void)getSongs;
- (NSString *)getSongForIndex:(NSInteger)theIndex;
- (NSInteger)getNumberOfSongs;
- (NSString *)getLocalSongForIndex:(NSInteger)theIndex;
- (NSInteger)getTheNumberOfMonths;
- (id)getTheEvents;
- (NSInteger)getNumberOfEventsFor:(NSInteger)theIndex;
- (NSArray *)getEventFor:(NSInteger)theIndex;
- (NSDictionary *)getEventFor:(NSInteger)theIndex theSection:(NSInteger)theSection;
- (NSString *)getMonthForIndex:(NSInteger)theIndex;
- (void)resetMainViewController;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic,retain) NSMutableArray *theEvents;
@property (nonatomic,retain) NSMutableDictionary *mainDict;
@property (nonatomic,retain) NSMutableArray *songArray;
@property (nonatomic,retain) NSMutableArray *localSongsArray;
@property (nonatomic) NSUInteger numberOfMonths;
@property (nonatomic, retain) UITabBarController *myTabBarController;


@end

