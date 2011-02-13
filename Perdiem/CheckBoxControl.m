//
//  CheckBoxControl.m
//  Perdiem
//
//  Created by Jarod Luebbert on 2/13/11.
//  Copyright 2011 Franana Games. All rights reserved.
//

#import "CheckBoxControl.h"

@implementation CheckBoxControl

@synthesize imageView, selectedImage, normalImage;

- (id)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame]))
  {
    normalImage = [UIImage imageNamed:@"unchecked.png"];
    selectedImage = [UIImage imageNamed:@"checked.png"];
    imageView = [[UIImageView alloc] initWithImage:normalImage];
    
    [self addSubview:imageView];
    [self addTarget:self action:@selector(toggle) forControlEvents:UIControlEventTouchUpInside];
  }
  
  return self;
}

- (void)toggle
{
  selected = !selected;
  imageView.image = selected ? selectedImage : normalImage;
  
  NSDictionary *dict = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:self.tag] forKey:@"CellCheckToggled"];
  [[NSNotificationCenter defaultCenter] postNotificationName: @"CellCheckToggled" object: self userInfo: dict];
}

@end
