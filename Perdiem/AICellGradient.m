//
//  AICellGradient.m
//  Gradients
//
//  Created by test on 9/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AICellGradient.h"

@implementation AICellGradient

- (id)init
{
	if ((self = [super init]))
  {
		UIColor *shadow		= [UIColor colorWithHue:0.666 saturation:0.0 brightness:0.5 alpha:0.6];
		UIColor *norm		= [UIColor colorWithHue:0.666 saturation:0.0 brightness:1.0 alpha:0.0];
		UIColor *white	= [UIColor colorWithHue:0.666 saturation:0.0 brightness:0.0 alpha:0.3];
		
		NSArray *colors =  [NSArray arrayWithObjects:(id)white.CGColor, shadow.CGColor, norm.CGColor, norm.CGColor, shadow.CGColor, white.CGColor, nil];
				
		self.colors = colors;	
		
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
		NSNumber *stopTwo		= [NSNumber numberWithFloat:0.02];
		NSNumber *stopThree		= [NSNumber numberWithFloat:0.15];
		NSNumber *stopFour	        = [NSNumber numberWithFloat:0.85];
		NSNumber *stopFive		= [NSNumber numberWithFloat:0.98];
    NSNumber *stopSix = [NSNumber numberWithFloat:1.0];
		
		NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, stopThree, stopFour, stopFive, stopSix, nil];
		
		self.locations = locations;

		self.startPoint = CGPointMake(0.5, 0.0);		
		self.endPoint = CGPointMake(0.5, 1.0);
	}
	return self;
}

@end
