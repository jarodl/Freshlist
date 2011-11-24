//
//  TornEdgeView.m
//  Perdiem
//
//  Created by Jarod Luebbert on 2/14/11.
//  Copyright 2011 Jarod Luebbert. All rights reserved.
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

- (void)dealloc
{
    [super dealloc];
}

@end
