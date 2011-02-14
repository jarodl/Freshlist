//
//  AIShadowGradient.m
//  Gradients
//
//  Created by test on 9/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AIShadowGradient.h"

@implementation AIShadowGradient

- (id)init
{
	if ((self = [super init]))
  {
		UIColor *colorOne	 = [UIColor colorWithHue:0.581 saturation:0.27 brightness:0.2 alpha:0.20];
		UIColor *colorTwo	 = [UIColor colorWithHue:0.581 saturation:0.27 brightness:0.2 alpha:0.10];
		UIColor *colorThree = [UIColor colorWithHue:0.581 saturation:0.27 brightness:0.2 alpha:0.0];
		
		NSArray *colors =  [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, colorThree.CGColor, nil];		
		self.colors = colors;
		
		self.startPoint = CGPointMake(0.5, 0.0);
		self.endPoint = CGPointMake(0.5, 1.0);
	}
	return self;
}

@end
