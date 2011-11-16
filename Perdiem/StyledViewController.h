//
//  StyledViewController.h
//  Perdiem
//
//  Created by Jarod Luebbert on 2/18/11.
//  Copyright 2011 Jarod Luebbert. All rights reserved.
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

- (UIBarButtonItem *)customBarButtonItemWithText:(NSString *)buttonText withImageName:(NSString *)imageName;

@end
