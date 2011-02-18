//
//  TopShadowGradient.m
//  Perdiem
//
//  Created by Jarod Luebbert on 2/18/11.
//  Copyright 2011 Franana Games. All rights reserved.
//

#import "TopShadowGradient.h"

@implementation TopShadowGradient

- (id)init
{
	if ((self = [super init]))
  {
		UIColor *shadow		= [UIColor colorWithHue:0.0 saturation:0.0 brightness:0.0 alpha:0.7];
		UIColor *white	= [UIColor colorWithHue:0.0 saturation:0.0 brightness:1.0 alpha:0.0];
		
		NSArray *colors =  [NSArray arrayWithObjects:(id)shadow.CGColor, white.CGColor, nil];
    
		self.colors = colors;	
		
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
		NSNumber *stopTwo		= [NSNumber numberWithFloat:0.5];
		
		NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
		
		self.locations = locations;
    
		self.startPoint = CGPointMake(0.5, 0.0);		
		self.endPoint = CGPointMake(0.5, 1.0);
	}
	return self;
}

@end
