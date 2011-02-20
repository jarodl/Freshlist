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
    startPoint = CGPointMake(44.0, 0.0);
    endPoint = CGPointMake(44.0, self.frame.size.height);
    
    hasHighResScreen = NO;
    if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
      CGFloat scale = [[UIScreen mainScreen] scale];
      if (scale > 1.0) {
        hasHighResScreen = YES;
      }
    }
  }
  return self;
}

- (void)drawRect:(CGRect)rect
{
  // Drawing code
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  UIColor *strokeColor = NotebookLineColor;
  CGContextSetStrokeColorWithColor(context, [strokeColor CGColor]);
  CGContextSetLineWidth(context, 1.0);
  CGContextBeginPath(context);
  CGContextMoveToPoint(context, startPoint.x, startPoint.y);
  CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
  
  if (hasHighResScreen)
  {
    CGContextMoveToPoint(context, startPoint.x + 4.0f, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x + 4.0f, endPoint.y);
  }
  
  CGContextDrawPath(context, kCGPathStroke);
}

- (void)dealloc
{
  [super dealloc];
}

@end
