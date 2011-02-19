//
//  ShadowedTornEdgeView.m
//  Perdiem
//
//  Created by Jarod Luebbert on 2/18/11.
//  Copyright 2011 Franana Games. All rights reserved.
//

#import "ShadowedTornEdgeView.h"
#import "Globals.h"
#import "TopShadow.h"

@implementation ShadowedTornEdgeView

@synthesize showsNotebookLines;

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
    
    [self setStartPoint:CGPointMake(self.startPoint.x + 1.0f, self.startPoint.y - 3.0)];
    [self setEndPoint:CGPointMake(self.endPoint.x + 1.0f, self.endPoint.y - 3.0)];
    
    TopShadow *topShadow = [[TopShadow alloc] initWithFrame:self.frame];
    [self addSubview:topShadow];
    [topShadow release];
    showsNotebookLines = YES;
  }
  return self;
}

- (void)drawRect:(CGRect)rect
{
//  //Since we are retaining the image, we append with RetRef.  this reminds us to release at a later date.
//  if (paperImage)
//  {
//    CGImageRef tiledImageRetRef = CGImageRetain(paperImage.CGImage); 
//    CGRect imageRect = CGRectMake(0.0, 0.0, paperImage.size.width, paperImage.size.height);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextDrawTiledImage(context, imageRect, tiledImageRetRef);
//    
//    CGImageRelease(tiledImageRetRef);
//  }
  if (showsNotebookLines)
    [super drawRect:rect];
}

@end
