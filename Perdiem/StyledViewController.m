//
//  StyledViewController.m
//  Perdiem
//
//  Created by Jarod Luebbert on 2/18/11.
//  Copyright 2011 Franana Games. All rights reserved.
//

#import "StyledViewController.h"
#import "ShadowedTornEdgeView.h"
#import "CustomNavigationBar.h"
#import "Globals.h"

@implementation StyledViewController

@synthesize showsNotebookLines;

- (void)viewDidLoad
{
  CustomNavigationBar *navBar = (CustomNavigationBar *)self.navigationController.navigationBar;
  [navBar setBackgroundWith:[UIImage imageNamed:@"blue_navbar"]];
}

- (UIBarButtonItem *)customBarButtonItemWithText:(NSString *)buttonText withImageName:(NSString *)imageName
{
  return [[[UIBarButtonItem alloc] initWithCustomView:[self customButtonWithText:buttonText stretch:CapLeftAndRight withImageName:imageName]] autorelease];
}

-(UIButton*)customButtonWithText:(NSString*)buttonText stretch:(CapLocation)location withImageName:(NSString *)imageName
{
  UIImage* buttonImage = nil;
  UIImage* buttonPressedImage = nil;
  NSUInteger buttonWidth = 0;
  if (location == CapLeftAndRight)
  {
    buttonWidth = BUTTON_WIDTH;
    buttonImage = [[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:CAP_WIDTH topCapHeight:0.0];
    buttonPressedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@Press", imageName]]
                          stretchableImageWithLeftCapWidth:CAP_WIDTH topCapHeight:0.0];
  }
  else
  {
    buttonWidth = BUTTON_SEGMENT_WIDTH;
    
    buttonImage = [self image:[[UIImage imageNamed:@"customBarButton"] stretchableImageWithLeftCapWidth:CAP_WIDTH topCapHeight:0.0] withCap:location capWidth:CAP_WIDTH buttonWidth:buttonWidth];
    buttonPressedImage = [self image:[[UIImage imageNamed:[NSString stringWithFormat:@"%@Press", imageName]]
                                      stretchableImageWithLeftCapWidth:CAP_WIDTH topCapHeight:0.0] withCap:location capWidth:CAP_WIDTH buttonWidth:buttonWidth];
  }
  
  
  UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.frame = CGRectMake(0.0, 0.0, buttonWidth, buttonImage.size.height);
  button.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
  button.titleLabel.textColor = [UIColor whiteColor];
  button.titleLabel.shadowOffset = CGSizeMake(0,-1);
  button.titleLabel.shadowColor = [UIColor darkGrayColor];
  
  [button setTitle:buttonText forState:UIControlStateNormal];
  [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
  [button setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
  [button setBackgroundImage:buttonPressedImage forState:UIControlStateSelected];
  button.adjustsImageWhenHighlighted = NO;
  
  return button;
}

-(UIImage*)image:(UIImage*)image withCap:(CapLocation)location capWidth:(NSUInteger)capWidth buttonWidth:(NSUInteger)buttonWidth
{
  UIGraphicsBeginImageContextWithOptions(CGSizeMake(buttonWidth, image.size.height), NO, 0.0);
  
  if (location == CapLeft)
    // To draw the left cap and not the right, we start at 0, and increase the width of the image by the cap width to push the right cap out of view
    [image drawInRect:CGRectMake(0, 0, buttonWidth + capWidth, image.size.height)];
  else if (location == CapRight)
    // To draw the right cap and not the left, we start at negative the cap width and increase the width of the image by the cap width to push the left cap out of view
    [image drawInRect:CGRectMake(0.0-capWidth, 0, buttonWidth + capWidth, image.size.height)];
  else if (location == CapMiddle)
    // To draw neither cap, we start at negative the cap width and increase the width of the image by both cap widths to push out both caps out of view
    [image drawInRect:CGRectMake(0.0-capWidth, 0, buttonWidth + (capWidth * 2), image.size.height)];
  
  UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return resultImage;
}

- (void)dealloc
{
  [super dealloc];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidUnload
{
  [super viewDidUnload];
}

@end
