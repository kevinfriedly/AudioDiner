//
//  StoredAudioController.h
//  AudioDiner
//
//  Created by Kevin Friedly on 2/27/11.
//  Copyright 2011 Silicon Prairie Ventures, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

#import "AudioViewController.h"

@interface StoredAudioController : UIViewController <AVAudioPlayerDelegate> {
	NSDictionary *eventDetailsDictionary;
	NSString *songName;
	AudioViewController *mainController;
	AVAudioPlayer *audioPlayer;
	IBOutlet UILabel *songTitle;
	IBOutlet UIButton *pausePlay;
}


- (id)initWithEventDetails:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil eventDetails:(NSString *)theEventDetails mainController:(UIViewController *)aMainController;
- (IBAction)pausePlay:(id)sender;
- (IBAction)goBack;

@property (nonatomic,retain) NSDictionary *eventDetailsDictionary;
@property (nonatomic,retain) NSString *songName;
@property (nonatomic,retain) UIViewController *mainController;
@property (nonatomic,retain) AVAudioPlayer *audioPlayer;
@property (nonatomic,retain) IBOutlet UILabel *songTitle;
@property (nonatomic,retain) IBOutlet UIButton *pausePlay;
@end

