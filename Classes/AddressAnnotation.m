//
//  AddressAnnotation.m
//  AudioDiner
//
//  Created by Kevin Friedly on 3/5/11.
//  Copyright 2011 Silicon Prairie Ventures, Inc. All rights reserved.
//

#import "AddressAnnotation.h"

@implementation AddressAnnotation
@synthesize coordinate;

- (NSString *)subtitle{
	return nil;
}

- (NSString *)title{
	return nil;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c{
	coordinate=c;
	return self;
}

@end