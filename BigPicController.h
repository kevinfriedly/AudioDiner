//
//  BigPicController.h
//  AudioDiner
//
//  Created by Kevin Friedly on 3/5/11.
//  Copyright 2011 Silicon Prairie Ventures, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioViewController.h"

@interface BigPicController : UIViewController {
	IBOutlet UIImageView *theImageView;
	UIImage *theImage;
}

@property (nonatomic,retain) IBOutlet UIImageView *theImageView;
@property (nonatomic,retain) UIImage *theImage;

- (id)initWithEventDetails:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil eventDetails:(UIImage *)theEventDetails;

@end
