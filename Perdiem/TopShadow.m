//
//  TopShadow.m
//  Perdiem
//
//  Created by Jarod Luebbert on 2/18/11.
//  Copyright 2011 Jarod Luebbert. All rights reserved.
//

#import "TopShadow.h"
#import "TopShadowGradient.h"

@implementation TopShadow

+ (Class)layerClass
{
  return [TopShadowGradient class];
}

- (void)dealloc
{
    [super dealloc];
}

@end
