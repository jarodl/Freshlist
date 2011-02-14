//
//  AIButton.m
//  Gradients
//
//  Created by test on 9/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AIButton.h"
#import "AIBarGradientMatte.h"

@implementation AIButton

+ (Class)layerClass
{
	return [AIBarGradientMatte class];	
}

- (id)initWithFrame:(CGRect)frame
 {
  if ((self = [super initWithFrame:frame]))
	{
		self.layer.cornerRadius = frame.size.height/2;
  }
  return self;
}

- (void)drawRect:(CGRect)rect 
{
  if (self.selected) 
  {
    
  }
}

- (void)dealloc 
{
    [super dealloc];
}

@end
