//
//  NewTaskViewController.h
//  Perdiem
//
//  Created by Jarod Luebbert on 2/12/11.
//  Copyright 2011 Jarod Luebbert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewTaskViewController : UIViewController <UITextViewDelegate>
{
  UITextView *newTaskField;
  IBOutlet UIBarButtonItem *saveTaskButton;
}

@property (nonatomic, retain) IBOutlet UITextView *newTaskField;

- (IBAction)saveTask;

@end
