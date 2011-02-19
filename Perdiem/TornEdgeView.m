//
//  TornEdgeView.m
//  Perdiem
//
//  Created by Jarod Luebbert on 2/14/11.
//  Copyright 2011 Franana Games. All rights reserved.
//

#import "TornEdgeView.h"
#import "TopShadow.h"

@implementation TornEdgeView

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
    }
  
    return self;
}

//- (void)drawRect:(CGRect)rect
//{
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
//  
//  [super drawRect:rect];
//}

- (void)dealloc
{
    [super dealloc];
}

@end
