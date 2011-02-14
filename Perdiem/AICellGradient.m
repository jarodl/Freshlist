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
		UIColor *colorOne		= [UIColor colorWithHue:1.0 saturation:0.0 brightness:1.0 alpha:1.0];
		UIColor *colorTwo		= [UIColor colorWithHue:0.666 saturation:0.0 brightness:0.9 alpha:1.0];
		UIColor *colorThree	= [UIColor colorWithHue:0.666 saturation:0.0 brightness:0.9 alpha:1.0];
		UIColor *colorFour	= [UIColor colorWithHue:0.666 saturation:0.0 brightness:0.7 alpha:1.0];
		
		NSArray *colors =  [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, colorThree.CGColor, colorFour.CGColor, nil];
				
		self.colors = colors;	
		
		NSNumber *stopOne		= [NSNumber numberWithFloat:0.0];
		NSNumber *stopTwo		= [NSNumber numberWithFloat:0.02];
		NSNumber *stopThree	        = [NSNumber numberWithFloat:0.98];
		NSNumber *stopFour		= [NSNumber numberWithFloat:1.0];
		
		NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, stopThree, stopFour, nil];
		
		self.locations = locations;

		self.startPoint = CGPointMake(0.5, 0.0);		
		self.endPoint = CGPointMake(0.5, 1.0);
	}
	return self;
}

@end
