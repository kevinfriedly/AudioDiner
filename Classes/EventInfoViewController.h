//
//  EventInfoViewController.h
//  AudioDiner
//
//  Created by Kevin Friedly on 2/4/11.
//  Copyright 2011 Silicon Prairie Ventures, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface EventInfoViewController : UIViewController {
	IBOutlet UITextView *eventDetails;
	NSDictionary *eventDetailsDictionary;
	IBOutlet MKMapView *mapView;
}


- (id)initWithEventDetails:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil eventDetails:(NSDictionary *)theEventDetails;
-(CLLocationCoordinate2D) getLocationFromAddress:(NSString*) address;

@property (nonatomic,retain) UITextView *eventDetails;
@property (nonatomic,retain) NSDictionary *eventDetailsDictionary;
@property (nonatomic,retain) MKMapView *mapView;

@end
