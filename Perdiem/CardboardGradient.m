//
//  CardboardGradient.m
//  Perdiem
//
//  Created by Jarod Luebbert on 2/18/11.
//  Copyright 2011 Jarod Luebbert. All rights reserved.
//

#import "CardboardGradient.h"

@implementation CardboardGradient

- (id)init
{
	if ((self = [super init]))
  {
		UIColor *colorOne	 = [UIColor colorWithHue:0.091 saturation:0.48 brightness:0.91 alpha:1.0];
		UIColor *colorTwo	 = [UIColor colorWithHue:0.083 saturation:0.30 brightness:0.99 alpha:1.0];
		UIColor *colorThree = [UIColor colorWithHue:0.086 saturation:0.48 brightness:0.92 alpha:1.0];
		
		NSArray *colors =  [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, colorThree.CGColor, nil];		
		self.colors = colors;
		
		self.startPoint = CGPointMake(0.5, 0.0);
		self.endPoint = CGPointMake(0.5, 1.0);
	}
	return self;
}

@end
