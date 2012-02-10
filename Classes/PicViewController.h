//
//  PicViewController.h
//  AudioDiner
//
//  Created by Kevin Friedly on 1/23/11.
//  Copyright 2011 Silicon Prairie Ventures, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioViewController.h"

@interface PicViewController : UIViewController {
	IBOutlet UITableView *imageTable;
	NSMutableArray *theImagesArray;
	NSMutableArray *theImagesDataArray;
	int	imagesLoaded;
	int numberOfPics;
	IBOutlet UITableView *picTable;
	UIViewController *mainRootController;
	AudioDinerAppDelegate *myAppDelegate;
}

- (void)loadImages;

@property (nonatomic, retain) NSMutableArray *theImagesArray;
@property (nonatomic, retain) NSMutableArray *theImagesDataArray;
@property (nonatomic) int imagesLoaded;
@property (nonatomic) int numberOfPics;
@property (nonatomic,retain) UITableView *picTable;
@property (nonatomic,retain) UIViewController *mainRootController;
@property (nonatomic,retain) AudioDinerAppDelegate *myAppDelegate;

@end
