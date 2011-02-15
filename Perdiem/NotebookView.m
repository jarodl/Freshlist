//
//  NotebookView.m
//  Perdiem
//
//  Created by Jarod Luebbert on 2/14/11.
//  Copyright 2011 Franana Games. All rights reserved.
//

#import "NotebookView.h"

@implementation NotebookView

- (id)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame]))
  {
    // Initialization code
  }
  return self;
}

- (void)drawRect:(CGRect)rect
{
  // Drawing code
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  UIColor *strokeColor = [UIColor colorWithRed:1.0 green:0.474 blue:0.772 alpha:1.0];
  CGContextSetStrokeColorWithColor(context, [strokeColor CGColor]);
  CGContextSetLineWidth(context, 0.1);
  CGContextBeginPath(context);
  CGContextMoveToPoint(context, 35.0, 0.0);
  CGContextAddLineToPoint(context, 35.0, self.frame.size.height);
  CGContextMoveToPoint(context, 38.0, 0.0);
  CGContextAddLineToPoint(context, 38.0, self.frame.size.height);
  
  CGContextDrawPath(context, kCGPathStroke);
}

- (void)dealloc
{
  [super dealloc];
}

@end
