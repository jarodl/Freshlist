//
//  CheckBoxControl.h
//  Perdiem
//
//  Created by Jarod Luebbert on 2/13/11.
//  Copyright 2011 Franana Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckBoxControl : UIControl
{
  BOOL selected;
  UIImageView *imageView;
  UIImage *normalImage;
  UIImage *selectedImage;
}

@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UIImage *normalImage;
@property (nonatomic, retain) UIImage *selectedImage;

- (void)toggle;

@end
