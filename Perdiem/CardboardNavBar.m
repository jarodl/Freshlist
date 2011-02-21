//
//  CardboardNavBar.m
//  Perdiem
//
//  Created by Jarod Luebbert on 2/18/11.
//  Copyright 2011 Jarod Luebbert. All rights reserved.
//

#import "CardboardNavBar.h"

@implementation CardboardNavBar

- (id)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    self.backgroundColor = [UIColor clearColor];
  }
  return self;
}

+ (Class)layerClass
{
  return [CardboardGradient class];
}

@end
