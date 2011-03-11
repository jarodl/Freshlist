//
//  ShadowedTornEdgeView.m
//  Perdiem
//
//  Created by Jarod Luebbert on 2/18/11.
//  Copyright 2011 Jarod Luebbert. All rights reserved.
//

#import "ShadowedTornEdgeView.h"
#import "Globals.h"
#import "TopShadow.h"

@implementation ShadowedTornEdgeView

- (id)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame]))
  {
    self.opaque = YES;
    self.backgroundColor = [UIColor clearColor];
    
    paperImage = [UIImage imageNamed:@"paperTear"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:paperImage];
    [self addSubview:imageView];
    [imageView release];
    
    TopShadow *topShadow = [[TopShadow alloc] initWithFrame:self.frame];
    [self addSubview:topShadow];
    [topShadow release];
  }
  return self;
}

@end
