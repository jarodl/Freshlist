//
//  TimeViewController.h
//  Perdiem
//
//  Created by Jarod Luebbert on 2/16/11.
//  Copyright 2011 Franana Games. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TimeViewController : UIViewController
{
  UILabel *tutorialText;
  UIDatePicker *timePicker;
}

@property (nonatomic, retain) IBOutlet UILabel *tutorialText;
@property (nonatomic, retain) IBOutlet UIDatePicker *timePicker;

@end
