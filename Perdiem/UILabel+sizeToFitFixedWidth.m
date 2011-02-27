//
//  UILabel+sizeToFitFixedWidth.m
//  Perdiem
//
//  Created by Jarod Luebbert on 2/26/11.
//  Copyright 2011 Franana Games. All rights reserved.
//

#import "UILabel+sizeToFitFixedWidth.h"

@implementation UILabel (BPExtensions)

- (void)sizeToFitFixedWidth:(NSInteger)fixedWidth
{
  self.frame = CGRectMake(self.frame.origin.x, 20.0f, fixedWidth, 0);
  self.lineBreakMode = UILineBreakModeWordWrap;
  self.numberOfLines = 0;
  [self sizeToFit];
}

@end
