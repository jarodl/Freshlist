//
//  LinedView.m
//  Perdiem
//
//  Created by Jarod Luebbert on 2/18/11.
//  Copyright 2011 Jarod Luebbert. All rights reserved.
//

#import "LinedView.h"
#import "Globals.h"

@implementation LinedView

- (BOOL)isOpaque
{
  return NO;
}

- (void)drawRect:(CGRect)rect
{
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGFloat height = rect.size.height;
  CGFloat lineHeight = LineHeight;
  int numOfLines = (int)height/lineHeight;
  
  UIColor *strokeColor = SeperatorColor;
  CGContextSetAllowsAntialiasing(context, NO);
  CGContextSetStrokeColorWithColor(context, [strokeColor CGColor]);
  CGContextSetLineWidth(context, 1.0);
  CGContextBeginPath(context);
  
  CGFloat y = lineHeight + 18.0;
  for (int i = 0; i < numOfLines && y + 10 < height; i++)
  {
    CGContextMoveToPoint(context, 0.0, y);
    CGContextAddLineToPoint(context, rect.size.width, y);
    CGContextDrawPath(context, kCGPathStroke);
    y += lineHeight;
  }
}

@end
