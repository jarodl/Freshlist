//
//  NotebookView.m
//  Perdiem
//
//  Created by Jarod Luebbert on 2/14/11.
//  Copyright 2011 Franana Games. All rights reserved.
//

#import "NotebookView.h"
#import "Globals.h"

@implementation NotebookView

@synthesize startPoint;
@synthesize endPoint;

- (id)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame]))
  {
    startPoint = CGPointMake(35.0, 0.0);
    endPoint = CGPointMake(35.0, self.frame.size.height);
  }
  return self;
}

- (void)drawRect:(CGRect)rect
{
  // Drawing code
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  UIColor *strokeColor = NotebookLineColor;
  CGContextSetStrokeColorWithColor(context, [strokeColor CGColor]);
  CGContextSetLineWidth(context, 0.1);
  CGContextBeginPath(context);
  CGContextMoveToPoint(context, startPoint.x, startPoint.y);
  CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
  CGContextMoveToPoint(context, startPoint.x + 5.0f, startPoint.y);
  CGContextAddLineToPoint(context, endPoint.x + 5.0f, endPoint.y);
  
  CGContextDrawPath(context, kCGPathStroke);
}

- (void)dealloc
{
  [super dealloc];
}

@end
