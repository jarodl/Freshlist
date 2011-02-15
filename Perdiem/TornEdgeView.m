//
//  TornEdgeView.m
//  Perdiem
//
//  Created by Jarod Luebbert on 2/14/11.
//  Copyright 2011 Franana Games. All rights reserved.
//

#import "TornEdgeView.h"

@implementation TornEdgeView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
      self.opaque = YES;
      self.backgroundColor = [UIColor clearColor];
//      self.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"paperedge.png"]];
      paperImage = [UIImage imageNamed:@"paperedge.png"];
      [self setStartPoint:CGPointMake(self.startPoint.x + 2.0f, self.startPoint.y - 3.0)];
      [self setEndPoint:CGPointMake(self.endPoint.x + 2.0f, self.endPoint.y - 3.0)];
    }
  
    return self;
}

- (void)drawRect:(CGRect)rect
{
  //Since we are retaining the image, we append with ret_ref.  this reminds us to release at a later date.
  CGImageRef image_to_tile_ret_ref = CGImageRetain(paperImage.CGImage); 
  
  CGRect image_rect;
  image_rect.size = paperImage.size;  //This sets the tile to the native size of the image.  Change this value to adjust the size of an indivitual "tile."
  
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  CGContextDrawTiledImage(context, image_rect, image_to_tile_ret_ref);
  
  CGImageRelease(image_to_tile_ret_ref);
//  CGImageRef image = CGImageRetain(paperImage.CGImage);
//  
//  CGRect imageRect;
//  imageRect.origin = CGPointMake(0.0, 0.0);
//  imageRect.size = CGSizeMake(CGImageGetWidth(image), CGImageGetHeight(image));
//  
//  CGContextRef context = UIGraphicsGetCurrentContext();       
//  CGContextClipToRect(context, CGRectMake(0.0, 0.0, rect.size.width, rect.size.height));      
//  CGContextDrawTiledImage(context, imageRect, image);
//  CGImageRelease(image);
  
  [super drawRect:rect];
}

- (void)dealloc
{
    [super dealloc];
}

@end
