//
//  StyledViewController.h
//  Perdiem
//
//  Created by Jarod Luebbert on 2/18/11.
//  Copyright 2011 Franana Games. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BUTTON_WIDTH 54.0
#define BUTTON_SEGMENT_WIDTH 51.0
#define CAP_WIDTH 5.0

typedef enum {
  CapLeft          = 0,
  CapMiddle        = 1,
  CapRight         = 2,
  CapLeftAndRight  = 3
} CapLocation;

@interface StyledViewController : UIViewController
{
  BOOL showsNotebookLines;
}

@property (assign) BOOL showsNotebookLines;

@end

@interface StyledViewController (PrivateMethods)
- (UIButton*)customButtonWithText:(NSString*)buttonText stretch:(CapLocation)location withImageName:(NSString *)imageName;
- (UIBarButtonItem *)customBarButtonItemWithText:(NSString *)buttonText withImageName:(NSString *)imageName;
- (UIImage*)image:(UIImage*)image withCap:(CapLocation)location capWidth:(NSUInteger)capWidth buttonWidth:(NSUInteger)buttonWidth;
@end
